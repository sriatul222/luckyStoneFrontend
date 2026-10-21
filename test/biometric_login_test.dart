import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/extra/biometric_auth.dart';
import 'package:luckystone/screens/loginScreen/loginUi/login_screen.dart';

/// Pretends the phone has [label] enrolled and biometric login is [enabled]
/// for Asha, without the platform plugins.
class _FakeBiometricAuth extends BiometricAuth {
  _FakeBiometricAuth({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Future<String> availableLabel() async => label;

  @override
  Future<bool> isEnabled() async => enabled;

  @override
  Future<Map<String, dynamic>?> savedUser() async =>
      enabled ? {'name': 'Asha', 'email': 'asha@example.com'} : null;
}

late NetworkBloc _networkBloc;

Future<void> _pumpLogin(WidgetTester tester, BiometricAuth biometric) async {
  BiometricAuth.instance = biometric;
  await tester.pumpWidget(
    BlocProvider<NetworkBloc>.value(
      value: _networkBloc,
      child: const MaterialApp(home: LoginScreen()),
    ),
  );
  await tester.pump(); // loadBiometric()
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final realBiometric = BiometricAuth.instance;

  // See auth_form_test.dart: keep the connection checker off the fake clock.
  setUpAll(() => _networkBloc = NetworkBloc());
  tearDownAll(() => _networkBloc.close());
  tearDown(() => BiometricAuth.instance = realBiometric);

  group('saved biometric login', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    const asha = {'id': 1, 'name': 'Asha', 'email': 'asha@example.com'};
    const ravi = {'id': 2, 'name': 'Ravi', 'email': 'ravi@example.com'};

    test('turn on, renew for the same account, turn off', () async {
      final biometric = BiometricAuth();
      expect(await biometric.isEnabled(), isFalse);

      await biometric.enable(token: 'token-1', user: asha);
      expect(await biometric.isEnabled(), isTrue);
      expect(await biometric.savedToken(), 'token-1');
      expect((await biometric.savedUser())?['name'], 'Asha');

      // Password login as the same user keeps Face ID working with the new token
      await biometric.renewToken(token: 'token-2', user: asha);
      expect(await biometric.savedToken(), 'token-2');

      // Someone else logging in with a password does not take it over
      await biometric.renewToken(token: 'token-3', user: ravi);
      expect(await biometric.savedToken(), 'token-2');
      expect((await biometric.savedUser())?['email'], 'asha@example.com');

      await biometric.disable();
      expect(await biometric.isEnabled(), isFalse);
      expect(await biometric.savedUser(), isNull);
    });

    test('picks a face or fingerprint icon', () {
      expect(BiometricAuth.iconFor('Face ID'), Icons.face);
      expect(BiometricAuth.iconFor('Face Unlock'), Icons.face);
      expect(BiometricAuth.iconFor('Fingerprint'), Icons.fingerprint);
      expect(BiometricAuth.iconFor('Touch ID'), Icons.fingerprint);
    });
  });

  group('login screen', () {
    testWidgets('shows Face ID login once it is turned on', (tester) async {
      await _pumpLogin(
        tester,
        _FakeBiometricAuth(label: 'Face ID', enabled: true),
      );
      expect(find.byKey(const Key('biometricLoginButton')), findsOneWidget);
      expect(find.text('Login as Asha with Face ID'), findsOneWidget);
      expect(find.byIcon(Icons.face), findsOneWidget);
    });

    testWidgets('hides it when not turned on yet', (tester) async {
      await _pumpLogin(
        tester,
        _FakeBiometricAuth(label: 'Fingerprint', enabled: false),
      );
      expect(find.byKey(const Key('biometricLoginButton')), findsNothing);
    });

    testWidgets('hides it when the phone has no biometrics', (tester) async {
      await _pumpLogin(tester, _FakeBiometricAuth(label: '', enabled: true));
      expect(find.byKey(const Key('biometricLoginButton')), findsNothing);
    });
  });
}
