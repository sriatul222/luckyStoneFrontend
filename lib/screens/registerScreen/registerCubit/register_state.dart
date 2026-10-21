import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.name = '',
    this.email = '',
    this.mobile = '',
    this.password = '',
    this.confirmPassword = '',
  });

  final FormzStatus status;
  final String? exceptionError;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    name,
    email,
    mobile,
    password,
    confirmPassword,
  ];

  RegisterState copyWith({
    FormzStatus? status,
    String? exceptionError,
    String? name,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
  }) {
    return RegisterState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
