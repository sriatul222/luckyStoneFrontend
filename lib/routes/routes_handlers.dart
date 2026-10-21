import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressUi/add_address_screen.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/addressScreen/addressUi/address_screen.dart';
import 'package:luckystone/screens/cartScreen/cartUi/cart_screen.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutUi/checkout_screen.dart';
import 'package:luckystone/screens/homeScreen/homeUi/home_screen.dart';
import 'package:luckystone/screens/loginScreen/loginUi/login_screen.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersUi/my_orders_screen.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsUi/order_details_screen.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsUi/product_details_screen.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';
import 'package:luckystone/screens/productListScreen/productListUi/product_list_screen.dart';
import 'package:luckystone/screens/registerScreen/registerUi/register_screen.dart';
import 'package:luckystone/screens/splashScreen/splashUi/splash_screen.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistUi/wishlist_screen.dart';

// Screen arguments come from Navigator.pushNamed(..., arguments: x) and are
// read here with fluro's context.arguments.
class RouteHandlers {
  static Handler splashHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const SplashScreen();
    },
  );

  static Handler homePageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const HomeScreen();
    },
  );

  static Handler loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const LoginScreen();
    },
  );

  static Handler registerHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RegisterScreen();
    },
  );

  static Handler productListHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final filter = context?.arguments;
      return ProductListScreen(
        filter: filter is ProductListFilter
            ? filter
            : const ProductListFilter(),
      );
    },
  );

  static Handler productDetailsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final productId = context?.arguments;
      return ProductDetailsScreen(productId: productId is int ? productId : 0);
    },
  );

  static Handler wishlistHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WishlistScreen();
    },
  );

  static Handler cartHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const CartScreen();
    },
  );

  static Handler addressListHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return AddressScreen(selectMode: context?.arguments == true);
    },
  );

  static Handler addAddressHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final address = context?.arguments;
      return AddAddressScreen(
        address: address is AddressModel ? address : null,
      );
    },
  );

  static Handler checkoutHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const CheckoutScreen();
    },
  );

  static Handler myOrdersHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MyOrdersScreen();
    },
  );

  static Handler orderDetailsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final orderId = context?.arguments;
      return OrderDetailsScreen(orderId: orderId is int ? orderId : 0);
    },
  );
}
