import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.username = '',
    this.password = '',
    this.biometricLabel = '',
    this.biometricEnabled = false,
    this.biometricUserName = '',
  });

  final FormzStatus status;
  final String? exceptionError;
  final String username;
  final String password;
  // "Face ID" / "Fingerprint" when the phone has one enrolled, else ''
  final String biometricLabel;
  // Biometric login was turned on for an account on this phone
  final bool biometricEnabled;
  final String biometricUserName;

  bool get canLoginWithBiometric =>
      biometricLabel.isNotEmpty && biometricEnabled;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    username,
    password,
    biometricLabel,
    biometricEnabled,
    biometricUserName,
  ];

  LoginState copyWith({
    FormzStatus? status,
    String? exceptionError,
    String? username,
    String? password,
    String? biometricLabel,
    bool? biometricEnabled,
    String? biometricUserName,
  }) {
    return LoginState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      username: username ?? this.username,
      password: password ?? this.password,
      biometricLabel: biometricLabel ?? this.biometricLabel,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricUserName: biometricUserName ?? this.biometricUserName,
    );
  }
}
