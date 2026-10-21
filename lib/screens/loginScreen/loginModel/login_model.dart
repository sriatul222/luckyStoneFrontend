// Model for POST /api/v1/auth/login and /auth/register (same response).

import 'package:luckystone/extra/json_parser.dart';

class LoginModel {
  final String accessToken;
  final UserModel user;

  const LoginModel({required this.accessToken, required this.user});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: parseString(json['access_token']),
      user: UserModel.fromJson(parseMap(json['user'])),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String mobile;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      mobile: parseString(json['mobile']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'mobile': mobile,
  };
}
