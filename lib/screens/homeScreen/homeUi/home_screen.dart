import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/homeScreen/homeCubit/home_cubit.dart';
import 'package:luckystone/screens/homeScreen/homeUi/home_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit()..getHomeData(),
      child: const HomeForm(),
    );
  }
}
