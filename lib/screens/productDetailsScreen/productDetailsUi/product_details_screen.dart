import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsCubit/product_details_cubit.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsUi/product_details_form.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (BuildContext context) =>
          ProductDetailsCubit(productId)..getDetails(),
      child: const ProductDetailsForm(),
    );
  }
}
