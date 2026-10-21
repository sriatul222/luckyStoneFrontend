import 'package:flutter/material.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/routes/routes_name.dart';

// Shopping is open to guests; cart, wishlist, addresses and orders need a
// login. These helpers open the Login screen first when a guest asks for them.
class AuthGuard {
  /// Returns true when the user is logged in (already, or after the Login /
  /// Register screen that this opens for guests).
  static Future<bool> ensureLoggedIn(BuildContext context) async {
    if (isLoggedIn) return true;
    await Navigator.pushNamed(context, RoutesName.login);
    return isLoggedIn;
  }

  /// Opens [routeName], asking a guest to log in first.
  static Future<void> openWhenLoggedIn(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    if (await ensureLoggedIn(context) && context.mounted) {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }
}
