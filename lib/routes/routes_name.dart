class RoutesName {
  static String splashScreen = "splashScreen";
  static String home = "homePage";

  // Auth (arguments: none; both pop with true after a successful login)
  static String login = "login";
  static String register = "register";

  // Catalogue
  static String productList = "productList"; // arguments: ProductListFilter
  static String productDetails = "productDetails"; // arguments: int productId

  // Shopping (login needed)
  static String wishlist = "wishlist";
  static String cart = "cart";
  static String addressList = "addressList"; // arguments: bool selectMode
  // arguments: AddressModel? to edit; pops with the saved AddressModel
  static String addAddress = "addAddress";
  static String checkout = "checkout";
  static String myOrders = "myOrders";
  static String orderDetails = "orderDetails"; // arguments: int orderId
}
