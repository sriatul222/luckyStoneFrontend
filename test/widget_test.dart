import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/extra/common_validator.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

void main() {
  test('parses home API response', () {
    final home = HomeModel.fromJson({
      'metal_rates': [
        {'id': 1, 'metal': 'gold', 'purity': '22K', 'rate_per_gram': 11780},
      ],
      'featured': [
        {
          'id': 7,
          'name': 'Solitaire Ring',
          'price': 45120.5,
          'original_price': 47000,
          'in_stock': true,
        },
      ],
    });

    expect(home.metalRates.single.label, 'Gold 22K');
    expect(home.metalRates.single.ratePerGram, 11780);
    expect(home.featured.single.hasDiscount, isTrue);
    expect(home.categories, isEmpty);
  });

  test('validates Indian mobile numbers', () {
    expect(InputValidation.validateMobileNumber('9876543210', 'err'), isNull);
    expect(InputValidation.validateMobileNumber('12345', 'err'), 'err');
  });
}
