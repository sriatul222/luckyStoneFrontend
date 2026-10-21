import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistCubit/wishlist_cubit.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistUi/wishlist_form.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishlistCubit>(
      create: (BuildContext context) => WishlistCubit()..getWishlist(),
      child: const WishlistForm(),
    );
  }
}
