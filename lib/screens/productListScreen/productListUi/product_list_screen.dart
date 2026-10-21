import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/productListScreen/productListCubit/product_list_cubit.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';
import 'package:luckystone/screens/productListScreen/productListUi/product_list_form.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, this.filter = const ProductListFilter()});

  final ProductListFilter filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductListCubit>(
      create: (BuildContext context) => ProductListCubit(filter)..getProducts(),
      child: const ProductListForm(),
    );
  }
}
