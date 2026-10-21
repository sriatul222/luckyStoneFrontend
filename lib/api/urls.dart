import 'package:flutter/foundation.dart';

// atul asl backend = LuckyStoneBackend (FastAPI). Start it with `python main.py`.
//
// Local URLs:
//   Android emulator -> http://10.0.2.2:8000/  (10.0.2.2 is your Mac's localhost)
//   iOS simulator/web -> http://127.0.0.1:8000/
//   Real phone        -> your Mac's Wi-Fi IP from config/dev.json:
//                        flutter run --dart-define-from-file=config/dev.json
//                        (see README "Real phone")
//   Render (online)   -> https URL from config/prod.json, works on any network:
//                        flutter run --dart-define-from-file=config/prod.json

class AppURLs {
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static final String appBaseURL = _baseUrlOverride.isNotEmpty
      ? _baseUrlOverride
      : (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          ? 'http://10.0.2.2:8000/'
          : 'http://127.0.0.1:8000/';

  static final String apiURL = '${appBaseURL}api/v1/';

  // Auth
  static final String registerApi = '${apiURL}auth/register';
  static final String loginApi = '${apiURL}auth/login';
  static final String profileApi = '${apiURL}auth/me';
  static final String changePasswordApi = '${apiURL}auth/change-password';

  // Home & catalogue
  static final String homeApi = '${apiURL}home';
  static final String metalRatesApi = '${apiURL}metal-rates';
  static final String bannersApi = '${apiURL}banners';
  static final String categoriesApi = '${apiURL}categories';
  static final String collectionsApi = '${apiURL}collections';
  static final String storesApi = '${apiURL}stores';

  // Products: GET productsApi supports ?q=&category=&collection=&metal=&purity=
  // &gender=&occasion=&min_price=&max_price=&sort=&page=&page_size=
  static final String productsApi = '${apiURL}products';
  static String productDetailsApi(int productId) => '$productsApi/$productId';
  static String productReviewsApi(int productId) =>
      '$productsApi/$productId/reviews';

  // Wishlist
  static final String wishlistApi = '${apiURL}wishlist';
  static String wishlistItemApi(int productId) => '$wishlistApi/$productId';

  // Cart
  static final String cartApi = '${apiURL}cart';
  static final String cartItemsApi = '${apiURL}cart/items';
  static String cartItemApi(int itemId) => '$cartItemsApi/$itemId';

  // Addresses
  static final String addressesApi = '${apiURL}addresses';
  static String addressApi(int addressId) => '$addressesApi/$addressId';

  // Orders
  static final String ordersApi = '${apiURL}orders';
  static String orderDetailsApi(int orderId) => '$ordersApi/$orderId';
  static String cancelOrderApi(int orderId) => '$ordersApi/$orderId/cancel';

  // Uploaded images come back as "/media/..." paths
  static String mediaUrl(String path) {
    if (path.isEmpty || path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$appBaseURL$cleanPath';
  }
}
