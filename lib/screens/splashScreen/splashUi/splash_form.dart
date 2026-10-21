import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luckystone/extra/assets_constants.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/splashScreen/splashCubit/splash_cubit.dart';
import 'package:luckystone/screens/splashScreen/splashCubit/splash_state.dart';

class SplashForm extends StatelessWidget {
  const SplashForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          // Shopping is open to guests; login is asked only for cart,
          // wishlist and checkout.
          Navigator.pushReplacementNamed(context, RoutesName.home);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [MyColor.primary, MyColor.primaryDark],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageConstants.appLogo, width: 120, height: 120),
              const SizedBox(height: 20),
              const Text(
                TextConstants.appName,
                style: TextStyle(
                  color: MyColor.gold,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                TextConstants.tagLine,
                style: TextStyle(
                  color: MyColor.goldLight,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
