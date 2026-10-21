import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/registerScreen/registerCubit/register_cubit.dart';
import 'package:luckystone/screens/registerScreen/registerUi/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (BuildContext context) => RegisterCubit(),
      child: const RegisterForm(),
    );
  }
}
