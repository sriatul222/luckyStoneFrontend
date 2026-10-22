import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/api/urls.dart';

void main() {
  test('API URLs use the https server address', () {
    expect(AppURLs.appBaseURL, startsWith('https://'));
    expect(AppURLs.appBaseURL, endsWith('/'));
    expect(AppURLs.apiURL, '${AppURLs.appBaseURL}api/v1/');
    expect(AppURLs.productDetailsApi(7), '${AppURLs.apiURL}products/7');
    expect(
      AppURLs.mediaUrl('/media/products/ring.jpg'),
      '${AppURLs.appBaseURL}media/products/ring.jpg',
    );
  });
}
