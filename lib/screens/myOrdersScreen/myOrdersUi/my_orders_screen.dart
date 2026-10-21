import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersCubit/my_orders_cubit.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersUi/my_orders_form.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyOrdersCubit>(
      create: (BuildContext context) => MyOrdersCubit()..getOrders(),
      child: const MyOrdersForm(),
    );
  }
}
