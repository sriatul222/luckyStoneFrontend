import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/screens/loginScreen/loginUi/login_screen.dart';
import 'package:luckystone/screens/registerScreen/registerUi/register_screen.dart';

// Validation runs before any API call, so these need no backend.
late NetworkBloc _networkBloc;

Widget _app(Widget screen) {
  return BlocProvider<NetworkBloc>.value(
    value: _networkBloc,
    child: MaterialApp(home: screen),
  );
}

void main() {
  // Created outside the widget tests' fake clock: the connection checker
  // opens a socket with a 10 s timeout, which testWidgets would report as a
  // pending timer.
  setUpAll(() => _networkBloc = NetworkBloc());
  tearDownAll(() => _networkBloc.close());

  testWidgets('login shows errors for empty and invalid input', (tester) async {
    await tester.pumpWidget(_app(const LoginScreen()));

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
    expect(
      find.text('Please enter a valid email or mobile number'),
      findsOneWidget,
    );
    expect(find.text('Please enter your password'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('loginUsername')), '12345');
    await tester.enterText(find.byKey(const Key('loginPassword')), 'secret');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
    expect(find.text('Please enter a valid mobile number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsNothing);
  });

  testWidgets('register checks password length and match', (tester) async {
    await tester.pumpWidget(_app(const RegisterScreen()));

    await tester.enterText(find.byKey(const Key('registerName')), 'Asha Nair');
    await tester.enterText(
      find.byKey(const Key('registerEmail')),
      'Asha@Example.com',
    );
    await tester.enterText(
      find.byKey(const Key('registerMobile')),
      '9876543210',
    );
    await tester.enterText(find.byKey(const Key('registerPassword')), 'short');
    await tester.enterText(
      find.byKey(const Key('registerConfirmPassword')),
      'different',
    );
    await tester.ensureVisible(find.byKey(const Key('registerButton')));
    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();

    expect(find.text('Please enter a valid name'), findsNothing);
    // Upper-case email is accepted (it is sent in lower case)
    expect(find.text('Please enter a valid email'), findsNothing);
    expect(
      find.text('Please enter a valid 10 digit mobile number'),
      findsNothing,
    );
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
