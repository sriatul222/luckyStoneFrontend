import 'package:fluro/fluro.dart';

import 'routes_handlers.dart';
import 'routes_name.dart';

class FluroRouters {
  static final router = FluroRouter();

  static void setupRouter(FluroRouter router) {
    router.define(
      RoutesName.splashScreen,
      handler: RouteHandlers.splashHandler,
    );
    router.define(
      RoutesName.home,
      handler: RouteHandlers.homePageHandler,
    );
    router.define(
      RoutesName.login,
      handler: RouteHandlers.loginHandler,
    );
    router.define(
      RoutesName.register,
      handler: RouteHandlers.registerHandler,
    );
    router.define(
      RoutesName.productList,
      handler: RouteHandlers.productListHandler,
    );
    router.define(
      RoutesName.productDetails,
      handler: RouteHandlers.productDetailsHandler,
    );
    router.define(
      RoutesName.wishlist,
      handler: RouteHandlers.wishlistHandler,
    );
    router.define(
      RoutesName.cart,
      handler: RouteHandlers.cartHandler,
    );
    router.define(
      RoutesName.addressList,
      handler: RouteHandlers.addressListHandler,
    );
    router.define(
      RoutesName.addAddress,
      handler: RouteHandlers.addAddressHandler,
    );
    router.define(
      RoutesName.checkout,
      handler: RouteHandlers.checkoutHandler,
    );
    router.define(
      RoutesName.myOrders,
      handler: RouteHandlers.myOrdersHandler,
    );
    router.define(
      RoutesName.orderDetails,
      handler: RouteHandlers.orderDetailsHandler,
    );
  }
}
