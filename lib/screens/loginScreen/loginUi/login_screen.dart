import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/loginScreen/loginCubit/login_cubit.dart';
import 'package:luckystone/screens/loginScreen/loginUi/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (BuildContext context) => LoginCubit()..loadBiometric(),
      child: const LoginForm(),
    );
  }
}
