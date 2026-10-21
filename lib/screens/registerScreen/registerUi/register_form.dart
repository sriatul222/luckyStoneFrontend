import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/screens/loginScreen/loginUi/login_form.dart';
import 'package:luckystone/screens/registerScreen/registerCubit/register_cubit.dart';
import 'package:luckystone/screens/registerScreen/registerCubit/register_state.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/hint_text.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/rich_text.dart';
import 'package:luckystone/widgets/text_input_field.dart';
import 'package:luckystone/widgets/text_input_field_password.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          FlutterToast.showToast('Welcome to ${TextConstants.appName}!');
          // Login screen pops itself too when it gets true back
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.homeBackgroundColor,
        appBar: CommonAppBar(
          title: TextConstants.register,
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
                          title: TextConstants.createAccount,
                          subTitle: TextConstants.registerSubTitle,
                        ),
                        const SizedBox(height: 24),
                        const HintText(hint: '${TextConstants.fullName}*'),
                        const SizedBox(height: 4),
                        TextInputFields(
                          key: const Key('registerName'),
                          maxLines: 1,
                          textInputType: TextInputType.name,
                          maxLength: 40,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: MyColor.primary,
                          ),
                          validator: cubit.nameChanged,
                          onChanged: cubit.nameChanged,
                        ),
                        const SizedBox(height: 14),
                        const HintText(hint: '${TextConstants.email}*'),
                        const SizedBox(height: 4),
                        TextInputFields(
                          key: const Key('registerEmail'),
                          maxLines: 1,
                          textInputType: TextInputType.emailAddress,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: MyColor.primary,
                          ),
                          validator: cubit.emailChanged,
                          onChanged: cubit.emailChanged,
                        ),
                        const SizedBox(height: 14),
                        const HintText(hint: '${TextConstants.mobileNumber}*'),
                        const SizedBox(height: 4),
                        TextInputFields(
                          key: const Key('registerMobile'),
                          maxLines: 1,
                          textInputType: TextInputType.phone,
                          maxLength: 10,
                          prefixIcon: const Icon(
                            Icons.phone_android,
                            color: MyColor.primary,
                          ),
                          validator: cubit.mobileChanged,
                          onChanged: cubit.mobileChanged,
                        ),
                        const SizedBox(height: 14),
                        const HintText(
                          hint: '${TextConstants.password}* (min 8 characters)',
                        ),
                        const SizedBox(height: 4),
                        TextInputFieldPassword(
                          key: const Key('registerPassword'),
                          textInputAction: TextInputAction.next,
                          validator: cubit.passwordChanged,
                          onChanged: cubit.passwordChanged,
                        ),
                        const SizedBox(height: 14),
                        const HintText(
                          hint: '${TextConstants.confirmPassword}*',
                        ),
                        const SizedBox(height: 4),
                        TextInputFieldPassword(
                          key: const Key('registerConfirmPassword'),
                          validator: cubit.confirmPasswordChanged,
                          onChanged: cubit.confirmPasswordChanged,
                        ),
                        const SizedBox(height: 28),
                        ButtonWidget(
                          key: const Key('registerButton'),
                          buttonName: TextConstants.createAccount,
                          filled: true,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              cubit.register();
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: RichTextWidget(
                            text1: TextConstants.haveAccount,
                            text2: TextConstants.login,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<RegisterCubit, RegisterState>(
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
}
