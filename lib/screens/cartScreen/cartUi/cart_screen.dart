import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/cartScreen/cartCubit/cart_cubit.dart';
import 'package:luckystone/screens/cartScreen/cartUi/cart_form.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (BuildContext context) => CartCubit()..getCart(),
      child: const CartForm(),
    );
  }
}
