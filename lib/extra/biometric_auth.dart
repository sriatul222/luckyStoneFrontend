import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:luckystone/extra/app_constants.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/shared_preferences.dart';

/// Fingerprint / Face ID login.
///
/// After a password login the user can turn it on: the login token (JWT,
/// valid 30 days) and the user are kept in the iOS Keychain / Android
/// Keystore. "Login with Face ID" reads them back after the fingerprint or
/// face check, so the password is never stored on the phone. Every password
/// login renews the saved token. Logout keeps it, so the user can come back
/// with Face ID; turn it off from the account menu.
class BiometricAuth {
  /// Replace with a fake in widget tests.
  static BiometricAuth instance = BiometricAuth();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    // Not copied to a new phone or backup
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );

  static const String _tokenKey = 'biometricToken';
  static const String _userKey = 'biometricUser';

  /// "Face ID", "Fingerprint", ... for the enrolled biometric, or '' when the
  /// phone has none (no hardware, nothing enrolled, or permission denied).
  Future<String> availableLabel() async {
    try {
      if (!await _localAuth.canCheckBiometrics) return '';
      final types = await _localAuth.getAvailableBiometrics();
      if (types.isEmpty) return '';
      final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
      if (types.contains(BiometricType.face)) {
        return isIOS ? 'Face ID' : 'Face Unlock';
      }
      if (types.contains(BiometricType.fingerprint)) {
        return isIOS ? 'Touch ID' : 'Fingerprint';
      }
      // Android often reports only "strong" / "weak"
      return 'Fingerprint';
    } catch (e) {
      MyUtils.printLog('Biometric check failed: $e');
      return '';
    }
  }

  /// Shows the system fingerprint / face prompt. Returns true on a match.
  Future<bool> authenticate(String reason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      MyUtils.printLog('Biometric login failed: $e');
      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
          break;
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          FlutterToast.showToast(
            'Too many attempts. Please login with your password.',
          );
          break;
        default:
          FlutterToast.showToast(
            'Biometric login is not available right now. Please use your password.',
          );
      }
      return false;
    } catch (e) {
      MyUtils.printLog('Biometric login failed: $e');
      return false;
    }
  }

  /// Turned on for this phone (a token is saved).
  Future<bool> isEnabled() async =>
      (await _read(_tokenKey))?.isNotEmpty ?? false;

  Future<String?> savedToken() => _read(_tokenKey);

  /// The user biometric login is set up for ({id, name, email, mobile}).
  Future<Map<String, dynamic>?> savedUser() async {
    final json = await _read(_userKey);
    if (json == null || json.isEmpty) return null;
    try {
      final user = jsonDecode(json);
      return user is Map<String, dynamic> ? user : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> enable({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: jsonEncode(user));
    } catch (e) {
      MyUtils.printLog('Saving biometric login failed: $e');
    }
  }

  /// Asks for the fingerprint / face, then saves the current session
  /// (token + user saved by the last login). Returns true when turned on.
  Future<bool> turnOnForCurrentUser(String label) async {
    final user = currentUser();
    if (!isLoggedIn || accessToken.isEmpty || user == null) return false;
    if (!await authenticate('Confirm to turn on $label login')) return false;
    await enable(token: accessToken, user: user);
    return true;
  }

  /// The logged-in user saved by LoginCubit.saveSession, or null.
  Map<String, dynamic>? currentUser() {
    final json = AppPreferences.shared.getSharedPreferences(AppConstants.user);
    if (json is! String || json.isEmpty) return null;
    try {
      final user = jsonDecode(json);
      return user is Map<String, dynamic> ? user : null;
    } catch (_) {
      return null;
    }
  }

  static IconData iconFor(String label) =>
      label.startsWith('Face') ? Icons.face : Icons.fingerprint;

  Future<void> disable() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (e) {
      MyUtils.printLog('Removing biometric login failed: $e');
    }
  }

  /// After a password login: renew the saved token when biometric login is
  /// set up for the same account, so it keeps working for another 30 days.
  Future<void> renewToken({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final saved = await savedUser();
    if (saved != null && saved['email'] == user['email']) {
      await enable(token: token, user: user);
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      MyUtils.printLog('Reading biometric login failed: $e');
      return null;
    }
  }
}
