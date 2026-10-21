import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';

late NetworkBloc _networkBloc;

Widget _appBar({required String title, required int actions}) {
  return BlocProvider<NetworkBloc>.value(
    value: _networkBloc,
    child: MaterialApp(
      home: MediaQuery(
        // Narrow phone with the system font size turned up
        data: const MediaQueryData(
          size: Size(320, 640),
          textScaler: TextScaler.linear(1.3),
        ),
        child: Scaffold(
          appBar: CommonAppBar(
            title: title,
            tittleSpace: 16,
            appBar: AppBar(),
            iconButton: title.isNotEmpty,
            widgets: List.generate(
              actions,
              (_) =>
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // See auth_form_test.dart: keep the connection checker off the fake clock.
  setUpAll(() => _networkBloc = NetworkBloc());
  tearDownAll(() => _networkBloc.close());

  testWidgets('logo title shrinks instead of overflowing', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_appBar(title: '', actions: 4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('long screen title shrinks instead of overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _appBar(title: 'Product Details for Bridal Jewellery', actions: 2),
    );
    expect(tester.takeException(), isNull);
  });
}
