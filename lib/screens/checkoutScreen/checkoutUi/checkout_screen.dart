import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutCubit/checkout_cubit.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutUi/checkout_form.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutCubit>(
      create: (BuildContext context) => CheckoutCubit()..getCheckoutData(),
      child: const CheckoutForm(),
    );
  }
}
