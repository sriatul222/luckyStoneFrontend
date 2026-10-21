import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/common_validator.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/loginScreen/loginCubit/login_cubit.dart';
import 'package:luckystone/screens/loginScreen/loginModel/login_model.dart';
import 'package:luckystone/screens/registerScreen/registerCubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  String? nameChanged(String? value) {
    final name = (value ?? '').trim();
    emit(state.copyWith(name: name));
    return InputValidation.validateUserName(name, 'Please enter a valid name');
  }

  String? emailChanged(String? value) {
    final email = (value ?? '').trim().toLowerCase();
    emit(state.copyWith(email: email));
    return InputValidation.validateEmail(email, 'Please enter a valid email');
  }

  String? mobileChanged(String? value) {
    final mobile = (value ?? '').trim();
    emit(state.copyWith(mobile: mobile));
    return InputValidation.validateMobileNumber(
      mobile,
      'Please enter a valid 10 digit mobile number',
    );
  }

  String? passwordChanged(String? value) {
    emit(state.copyWith(password: value ?? ''));
    return InputValidation.validateMinLength(
      value ?? '',
      8,
      'Password must be at least 8 characters',
    );
  }

  String? confirmPasswordChanged(String? value) {
    emit(state.copyWith(confirmPassword: value ?? ''));
    return InputValidation.validateConfirmPassword(
      state.password,
      value ?? '',
      'Passwords do not match',
    );
  }

  Future<void> register() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Register request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.postApi(AppURLs.registerApi, {
        'name': state.name,
        'email': state.email,
        'mobile': state.mobile,
        'password': state.password,
      });

      if (response?.statusCode == 201 && response.data['success'] == true) {
        await LoginCubit.saveSession(
          LoginModel.fromJson(response.data['data']),
        );
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
}
