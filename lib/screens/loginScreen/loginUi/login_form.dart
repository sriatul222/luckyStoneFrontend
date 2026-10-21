import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luckystone/extra/assets_constants.dart';
import 'package:luckystone/extra/biometric_auth.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/loginScreen/loginCubit/login_cubit.dart';
import 'package:luckystone/screens/loginScreen/loginCubit/login_state.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/hint_text.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/rich_text.dart';
import 'package:luckystone/widgets/text_input_field.dart';
import 'package:luckystone/widgets/text_input_field_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status.isSubmissionSuccess) {
          await _offerBiometric();
          if (!context.mounted) return;
          FlutterToast.showToast('Login successful');
          // true tells AuthGuard / the caller that the user is now logged in
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.homeBackgroundColor,
        appBar: CommonAppBar(
          title: TextConstants.login,
          tittleSpace: 0,
          appBar: AppBar(),
          iconButton: true,
        ),
        body: SafeArea(
          child: NoNetworkWidget(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthHeader(
                          title: TextConstants.welcomeBack,
                          subTitle: TextConstants.loginSubTitle,
                        ),
                        const SizedBox(height: 28),
                        const HintText(hint: '${TextConstants.emailOrMobile}*'),
                        const SizedBox(height: 4),
                        const _UsernameInputField(),
                        const SizedBox(height: 14),
                        const HintText(hint: '${TextConstants.password}*'),
                        const SizedBox(height: 4),
                        _PasswordInputField(),
                        const SizedBox(height: 28),
                        ButtonWidget(
                          key: const Key('loginButton'),
                          buttonName: TextConstants.login,
                          filled: true,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login();
                            }
                          },
                        ),
                        const _BiometricLoginSection(),
                        const SizedBox(height: 12),
                        Center(
                          child: RichTextWidget(
                            text1: TextConstants.noAccount,
                            text2: TextConstants.createAccount,
                            onTap: () async {
                              final registered = await Navigator.pushNamed(
                                context,
                                RoutesName.register,
                              );
                              if (registered == true && context.mounted) {
                                await _offerBiometric();
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) =>
                      state.status.isSubmissionInProgress
                      ? const Loading()
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// "Use Face ID next time?" after a password login or a new account.
  Future<void> _offerBiometric() async {
    final cubit = context.read<LoginCubit>();
    if (!await cubit.shouldOfferBiometric() || !mounted) return;
    final label = cubit.state.biometricLabel;
    final turnOn = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: MyColor.white,
        icon: Icon(
          BiometricAuth.iconFor(label),
          size: 48,
          color: MyColor.primary,
        ),
        title: Text(
          'Use $label to login?',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 17),
        ),
        content: Text(
          'Next time, login with $label instead of typing your password.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              TextConstants.notNow,
              style: TextStyle(color: MyColor.hintColor),
            ),
          ),
          TextButton(
            key: const Key('turnOnBiometric'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              TextConstants.turnOn,
              style: TextStyle(
                color: MyColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (turnOn == true && await cubit.enableBiometric()) {
      FlutterToast.showToast('$label login turned on');
    }
  }
}

/// "or  Login with Face ID" under the Login button, once it is turned on.
class _BiometricLoginSection extends StatelessWidget {
  const _BiometricLoginSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.canLoginWithBiometric != current.canLoginWithBiometric ||
          previous.biometricLabel != current.biometricLabel ||
          previous.biometricUserName != current.biometricUserName,
      builder: (context, state) {
        if (!state.canLoginWithBiometric) return const SizedBox.shrink();
        return Column(
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Divider(color: MyColor.lightGray)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    TextConstants.or,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: MyColor.hintColor,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: MyColor.lightGray)),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              key: const Key('biometricLoginButton'),
              onTap: () {
                FocusScope.of(context).unfocus();
                context.read<LoginCubit>().loginWithBiometric();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: MyColor.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MyColor.primary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      BiometricAuth.iconFor(state.biometricLabel),
                      color: MyColor.primary,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.biometricUserName.isNotEmpty
                              ? 'Login as ${state.biometricUserName} with ${state.biometricLabel}'
                              : 'Login with ${state.biometricLabel}',
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: MyColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Logo + heading shared by Login and Register.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(ImageConstants.appLogo, width: 64, height: 64),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: MyColor.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subTitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: MyColor.hintColor,
          ),
        ),
      ],
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  const _UsernameInputField();

  @override
  Widget build(BuildContext context) {
    return TextInputFields(
      key: const Key('loginUsername'),
      maxLines: 1,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      hintText: 'e.g. name@email.com or 9876543210',
      prefixIcon: const Icon(Icons.person_outline, color: MyColor.primary),
      validator: (username) {
        return context.read<LoginCubit>().usernameChanged(username);
      },
      onChanged: (username) {
        context.read<LoginCubit>().usernameChanged(username);
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextInputFieldPassword(
      key: const Key('loginPassword'),
      textInputAction: TextInputAction.done,
      validator: (password) {
        return context.read<LoginCubit>().passwordChanged(password);
      },
      onChanged: (password) {
        context.read<LoginCubit>().passwordChanged(password);
      },
    );
  }
}
