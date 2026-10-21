import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/splashScreen/splashCubit/splash_cubit.dart';
import 'package:luckystone/screens/splashScreen/splashUi/splash_form.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (BuildContext context) => SplashCubit()..initializeApp(),
      child: const SplashForm(),
    );
  }
}
