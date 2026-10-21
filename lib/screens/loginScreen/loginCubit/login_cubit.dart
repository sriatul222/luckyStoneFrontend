import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/app_constants.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/extra/biometric_auth.dart';
import 'package:luckystone/extra/common_validator.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/shared_preferences.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/screens/loginScreen/loginCubit/login_state.dart';
import 'package:luckystone/screens/loginScreen/loginModel/login_model.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  /// Accepts a registered email or 10 digit mobile number.
  String? usernameChanged(String? value) {
    final username = (value ?? '').trim();
    emit(state.copyWith(username: username));
    if (RegExp(r'^\d+$').hasMatch(username)) {
      return InputValidation.validateMobileNumber(
        username,
        'Please enter a valid mobile number',
      );
    }
    return InputValidation.validateEmail(
      username.toLowerCase(),
      'Please enter a valid email or mobile number',
    );
  }

  String? passwordChanged(String? value) {
    emit(state.copyWith(password: value ?? ''));
    return InputValidation.validateNewPassword(
      value ?? '',
      'Please enter your password',
    );
  }

  Future<void> login() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Login request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final username = state.username.contains('@')
          ? state.username.toLowerCase()
          : state.username;
      final response = await ApiHandler.handler.postApi(AppURLs.loginApi, {
        'username': username,
        'password': state.password,
      });

      if (response?.statusCode == 200 && response.data['success'] == true) {
        await saveSession(LoginModel.fromJson(response.data['data']));
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }

  /// Saves the token (and user for the account sheet). Also used by Register.
  static Future<void> saveSession(LoginModel login) async {
    await AppPreferences.shared.saveLogin(login.accessToken);
    AppPreferences.shared.saveSharedPreferences(
      AppConstants.user,
      jsonEncode(login.user.toJson()),
    );
    // Keeps Face ID login working for 30 days after this login
    await BiometricAuth.instance.renewToken(
      token: login.accessToken,
      user: login.user.toJson(),
    );
  }

  // ---------------- Fingerprint / Face ID ----------------

  /// Shows "Login with Face ID" when the phone has it and it was turned on.
  Future<void> loadBiometric() async {
    final biometric = BiometricAuth.instance;
    final label = await biometric.availableLabel();
    final enabled = label.isNotEmpty && await biometric.isEnabled();
    final user = enabled ? await biometric.savedUser() : null;
    if (isClosed) return;
    emit(
      state.copyWith(
        biometricLabel: label,
        biometricEnabled: enabled,
        biometricUserName: parseString(user?['name']),
      ),
    );
  }

  /// Logs in with the token saved when Face ID login was turned on.
  Future<void> loginWithBiometric() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Login request already in progress');
    }

    final biometric = BiometricAuth.instance;
    if (!await biometric.authenticate('Login to ${TextConstants.appName}')) {
      return;
    }
    final token = await biometric.savedToken();
    if (token == null || token.isEmpty) return _turnOffBiometric();

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      // ApiHandler sends the global token: check the saved one with /auth/me
      accessToken = token;
      final response = await ApiHandler.handler.getApi(AppURLs.profileApi);

      if (response?.statusCode == 200 && response.data['success'] == true) {
        await saveSession(
          LoginModel(
            accessToken: token,
            user: UserModel.fromJson(response.data['data']),
          ),
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        // On a 401 (token older than 30 days, or user blocked) ApiHandler
        // has already cleared the token and shown the backend's message.
        final rejected = accessToken.isEmpty;
        accessToken = '';
        if (rejected) await _turnOffBiometric();
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      accessToken = '';
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }

  /// After a password login or register: ask to turn on Face ID login when
  /// the phone has it and it isn't already set up for this account.
  Future<bool> shouldOfferBiometric() async {
    if (state.biometricLabel.isEmpty) return false;
    final saved = await BiometricAuth.instance.savedUser();
    final current = BiometricAuth.instance.currentUser();
    return current != null && saved?['email'] != current['email'];
  }

  Future<bool> enableBiometric() =>
      BiometricAuth.instance.turnOnForCurrentUser(state.biometricLabel);

  Future<void> _turnOffBiometric() async {
    await BiometricAuth.instance.disable();
    if (isClosed) return;
    emit(state.copyWith(biometricEnabled: false, biometricUserName: ''));
  }
}
