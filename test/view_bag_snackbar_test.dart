import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsCubit/product_details_cubit.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsUi/product_details_form.dart';

/// Lets the test say "added to bag" without calling the API.
class _FakeProductDetailsCubit extends ProductDetailsCubit {
  _FakeProductDetailsCubit() : super(1);

  void addedToBag() =>
      emit(state.copyWith(cartStatus: FormzStatus.submissionSuccess));
}

late NetworkBloc _networkBloc;

void main() {
  // See auth_form_test.dart: keep the connection checker off the fake clock.
  setUpAll(() => _networkBloc = NetworkBloc());
  tearDownAll(() => _networkBloc.close());

  testWidgets('VIEW BAG still opens the bag after leaving product details', (
    tester,
  ) async {
    final cubit = _FakeProductDetailsCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider<NetworkBloc>.value(
        value: _networkBloc,
        child: MaterialApp(
          onGenerateRoute: (settings) => settings.name == RoutesName.cart
              ? MaterialPageRoute(
                  builder: (_) => const Scaffold(body: Text('bag page')),
                )
              : null,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<ProductDetailsCubit>.value(
                      value: cubit,
                      child: const ProductDetailsForm(),
                    ),
                  ),
                ),
                child: const Text('open product'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open product details and add to bag -> "Added to your bag" + VIEW BAG
    await tester.tap(find.text('open product'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    cubit.addedToBag();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('VIEW BAG'), findsOneWidget);

    // Leave product details while the snackbar is still showing
    Navigator.of(tester.element(find.byType(ProductDetailsForm))).pop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ProductDetailsForm), findsNothing);
    expect(find.text('VIEW BAG'), findsOneWidget);

    await tester.tap(find.text('VIEW BAG'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(find.text('bag page'), findsOneWidget);
  });
}
