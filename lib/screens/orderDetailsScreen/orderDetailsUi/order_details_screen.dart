import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsCubit/order_details_cubit.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsUi/order_details_form.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsCubit>(
      create: (BuildContext context) => OrderDetailsCubit(orderId)..getOrder(),
      child: const OrderDetailsForm(),
    );
  }
}
