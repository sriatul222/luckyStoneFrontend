import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/extra/common_validator.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';
import 'package:luckystone/screens/loginScreen/loginModel/login_model.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersModel/my_orders_model.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsModel/product_details_model.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';

// JSON samples copied from real LuckyStoneBackend responses.
const Map<String, dynamic> _productCard = {
  'id': 1,
  'name': 'Aarna Diamond Solitaire Ring',
  'slug': 'aarna-diamond-solitaire-ring',
  'sku': 'LS-RG-001',
  'category_name': 'Rings',
  'category_slug': 'rings',
  'metal': 'gold',
  'purity': '18K',
  'net_weight': 2.9,
  'gross_weight': 3.2,
  'image_url': '',
  'price': 72599.42,
  'original_price': 73117.72,
  'discount_percent': 10.0,
  'rating': 0.0,
  'review_count': 0,
  'in_stock': true,
  'is_featured': true,
};

void main() {
  test('parses login / register response', () {
    final login = LoginModel.fromJson({
      'access_token': 'jwt-token',
      'token_type': 'bearer',
      'user': {
        'id': 3,
        'name': 'Asha',
        'email': 'asha@example.com',
        'mobile': '9876543210',
      },
    });

    expect(login.accessToken, 'jwt-token');
    expect(login.user.name, 'Asha');
    expect(UserModel.fromJson(login.user.toJson()).mobile, '9876543210');
  });

  test('builds product list query from filter', () {
    const filter = ProductListFilter(title: 'Rings', category: 'rings');
    expect(filter.toQuery(page: 1), {
      'category': 'rings',
      'sort': 'newest',
      'page': 1,
      'page_size': 20,
    });

    final filtered = filter
        .copyWith(q: ' solitaire ', sort: 'price_low_to_high')
        .withFilters(metal: 'gold', purity: '18K', minPrice: 50000);
    expect(filtered.toQuery(page: 2), {
      'q': 'solitaire',
      'category': 'rings',
      'metal': 'gold',
      'purity': '18K',
      'min_price': 50000.0,
      'sort': 'price_low_to_high',
      'page': 2,
      'page_size': 20,
    });
    expect(filtered.appliedFilterCount, 3);
    // Clearing the sheet keeps search, category and sort
    expect(filtered.withFilters().appliedFilterCount, 0);
    expect(filtered.withFilters().category, 'rings');
    expect(filtered.withFilters().q, filtered.q);
  });

  test('parses product page', () {
    final page = ProductPageModel.fromJson({
      'items': [_productCard],
      'page': 1,
      'page_size': 20,
      'total': 16,
      'total_pages': 8,
    });

    expect(page.items.single.name, 'Aarna Diamond Solitaire Ring');
    expect(page.totalPages, 8);
  });

  test('parses product details with price breakup and sizes', () {
    final details = ProductDetailsModel.fromJson({
      ..._productCard,
      'description': 'A classic round solitaire.',
      'collection_name': 'Bridal',
      'image_urls': [],
      'gender': 'women',
      'occasion': 'engagement',
      'sizes': ['8', '10', '12'],
      'stone_type': 'Diamond',
      'stone_weight_carat': 0.3,
      'stone_quality': 'GH-VS',
      'making_charge_percent': 18.0,
      'stock': 6,
      'is_wishlisted': true,
      'price_breakup': {
        'metal_rate': 9640.0,
        'metal_value': 27956.0,
        'making_charges': 5032.08,
        'making_discount': 503.21,
        'stone_value': 38000.0,
        'subtotal': 70484.87,
        'gst_percent': 3.0,
        'gst': 2114.55,
        'total': 72599.42,
      },
    });

    expect(details.product.price, 72599.42);
    expect(details.product.hasDiscount, isTrue);
    expect(details.needsSize, isTrue);
    expect(details.sizes, ['8', '10', '12']);
    expect(details.isWishlisted, isTrue);
    expect(details.images, isEmpty);
    expect(details.priceBreakup.gst, 2114.55);
    expect(
      details.priceBreakup.subtotal + details.priceBreakup.gst,
      closeTo(details.priceBreakup.total, 0.01),
    );
  });

  test('parses cart and caps quantity by stock', () {
    final cart = CartModel.fromJson({
      'items': [
        {
          'id': 1,
          'product': _productCard,
          'size': '12',
          'quantity': 2,
          'unit_price': 72599.42,
          'line_total': 145198.84,
          'available_stock': 6,
        },
        {
          'id': 2,
          'product': {..._productCard, 'id': 9, 'in_stock': false},
          'size': '',
          'quantity': 1,
          'unit_price': 100,
          'line_total': 100,
          'available_stock': 0,
        },
      ],
      'summary': {
        'item_count': 2,
        'total_quantity': 3,
        'subtotal': 70988.08,
        'discount': 503.21,
        'gst': 2114.55,
        'total': 72599.42,
      },
    });

    expect(cart.items.first.product.name, 'Aarna Diamond Solitaire Ring');
    expect(cart.items.first.maxQuantity, 6);
    expect(cart.items.last.isAvailable, isFalse);
    expect(cart.hasUnavailableItems, isTrue);
    expect(cart.summary.totalQuantity, 3);
    expect(const CartModel().isEmpty, isTrue);
  });

  test('parses address and builds request body', () {
    final address = AddressModel.fromJson({
      'id': 4,
      'full_name': 'Asha',
      'mobile': '9876543210',
      'line1': '12 MG Road',
      'line2': '',
      'landmark': 'Metro station',
      'city': 'Kochi',
      'state': 'Kerala',
      'pincode': '682001',
      'address_type': 'home',
      'is_default': true,
    });

    expect(
      address.fullAddress,
      '12 MG Road, Near Metro station, Kochi, Kerala - 682001',
    );
    expect(address.toJson()['is_default'], isTrue);
    expect(address.toJson().containsKey('id'), isFalse);
  });

  test('parses order list and order details', () {
    final summary = {
      'id': 1,
      'order_number': 'LS261015184702',
      'status': 'PLACED',
      'payment_method': 'COD',
      'payment_status': 'PENDING',
      'item_count': 1,
      'subtotal': 70988.08,
      'discount': 503.21,
      'gst': 2114.55,
      'total': 72599.42,
      'created_at': '2026-10-15T12:07:03.495140+05:30',
      'updated_at': '2026-10-15T12:07:03.495140+05:30',
    };

    final page = OrderPageModel.fromJson({
      'items': [summary],
      'page': 1,
      'total_pages': 1,
    });
    expect(page.items.single.canCancel, isTrue);
    expect(page.items.single.paymentLabel, 'Cash on Delivery');
    expect(page.items.single.createdAt, isNotNull);

    final details = OrderDetailsModel.fromJson({
      ...summary,
      'status': 'SHIPPED',
      'shipping_address': {
        'full_name': 'Asha',
        'mobile': '9876543210',
        'line1': '12 MG Road',
        'city': 'Kochi',
        'state': 'Kerala',
        'pincode': '682001',
        'address_type': 'home',
      },
      'items': [
        {
          'id': 1,
          'product_id': null,
          'product_name': 'Aarna Diamond Solitaire Ring',
          'size': '12',
          'quantity': 1,
          'unit_price': 72599.42,
          'line_total': 72599.42,
        },
      ],
    });
    expect(details.order.canCancel, isFalse);
    expect(details.shippingAddress.city, 'Kochi');
    expect(details.items.single.productId, isNull);
    expect(details.items.single.size, '12');
  });

  test('validates pincode and password length', () {
    expect(InputValidation.validatePincode('682001', 'err'), isNull);
    expect(InputValidation.validatePincode('082001', 'err'), 'err');
    expect(InputValidation.validatePincode('68200', 'err'), 'err');
    expect(InputValidation.validateMinLength('Secret@12', 8, 'err'), isNull);
    expect(InputValidation.validateMinLength('short', 8, 'err'), 'err');
  });
}
