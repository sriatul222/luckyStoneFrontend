import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressCubit/add_address_cubit.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressCubit/add_address_state.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/hint_text.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/text_input_field.dart';

class AddAddressForm extends StatefulWidget {
  const AddAddressForm({super.key});

  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddAddressCubit>();
    // Initial values (filled when editing)
    final initial = cubit.state;
    return BlocListener<AddAddressCubit, AddAddressState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          FlutterToast.showToast(
            state.isEdit ? 'Address updated' : 'Address added',
          );
          Navigator.pop(context, state.savedAddress);
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.homeBackgroundColor,
        appBar: CommonAppBar(
          title: initial.isEdit
              ? TextConstants.editAddress
              : TextConstants.addAddress,
          tittleSpace: 0,
          appBar: AppBar(),
          iconButton: true,
        ),
        body: SafeArea(
          child: NoNetworkWidget(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Field(
                          label: '${TextConstants.fullName}*',
                          fieldKey: 'addressFullName',
                          initialValue: initial.fullName,
                          textInputType: TextInputType.name,
                          maxLength: 40,
                          validator: cubit.fullNameChanged,
                        ),
                        _Field(
                          label: '${TextConstants.mobileNumber}*',
                          fieldKey: 'addressMobile',
                          initialValue: initial.mobile,
                          textInputType: TextInputType.phone,
                          maxLength: 10,
                          validator: cubit.mobileChanged,
                        ),
                        _Field(
                          label: 'House No. / Building / Street*',
                          fieldKey: 'addressLine1',
                          initialValue: initial.line1,
                          textInputType: TextInputType.streetAddress,
                          maxLength: 255,
                          validator: cubit.line1Changed,
                        ),
                        _Field(
                          label: 'Area / Locality',
                          fieldKey: 'addressLine2',
                          initialValue: initial.line2,
                          textInputType: TextInputType.streetAddress,
                          maxLength: 255,
                          validator: (_) => null,
                          onChanged: cubit.line2Changed,
                        ),
                        _Field(
                          label: 'Landmark',
                          fieldKey: 'addressLandmark',
                          initialValue: initial.landmark,
                          textInputType: TextInputType.text,
                          maxLength: 255,
                          validator: (_) => null,
                          onChanged: cubit.landmarkChanged,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _Field(
                                label: 'Pincode*',
                                fieldKey: 'addressPincode',
                                initialValue: initial.pincode,
                                textInputType: TextInputType.number,
                                maxLength: 6,
                                validator: cubit.pincodeChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _Field(
                                label: 'City*',
                                fieldKey: 'addressCity',
                                initialValue: initial.city,
                                textInputType: TextInputType.text,
                                maxLength: 40,
                                validator: cubit.cityChanged,
                              ),
                            ),
                          ],
                        ),
                        _Field(
                          label: 'State*',
                          fieldKey: 'addressState',
                          initialValue: initial.stateName,
                          textInputType: TextInputType.text,
                          maxLength: 40,
                          textInputAction: TextInputAction.done,
                          validator: cubit.stateNameChanged,
                        ),
                        const HintText(hint: 'Address Type'),
                        const SizedBox(height: 6),
                        BlocBuilder<AddAddressCubit, AddAddressState>(
                          buildWhen: (previous, current) =>
                              previous.addressType != current.addressType ||
                              previous.isDefault != current.isDefault,
                          builder: (context, state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                children: const ['home', 'work', 'other']
                                    .map(
                                      (type) => ChoiceChip(
                                        label: Text(
                                          type[0].toUpperCase() +
                                              type.substring(1),
                                        ),
                                        selected: state.addressType == type,
                                        showCheckmark: false,
                                        selectedColor: MyColor.primary,
                                        backgroundColor: MyColor.primaryBg,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: state.addressType == type
                                              ? MyColor.white
                                              : MyColor.primary,
                                        ),
                                        onSelected: (_) =>
                                            cubit.addressTypeChanged(type),
                                      ),
                                    )
                                    .toList(),
                              ),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                value: state.isDefault,
                                activeTrackColor: MyColor.primary,
                                onChanged: cubit.isDefaultChanged,
                                title: const Text(
                                  'Make this my default address',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: MyColor.darkGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ButtonWidget(
                          key: const Key('saveAddressButton'),
                          buttonName: TextConstants.saveAddress,
                          filled: true,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              cubit.saveAddress();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AddAddressCubit, AddAddressState>(
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

/// Label + text field. Required fields validate (and save) through
/// [validator]; optional ones save through [onChanged].
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.fieldKey,
    required this.initialValue,
    required this.textInputType,
    required this.maxLength,
    required this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final String fieldKey;
  final String initialValue;
  final TextInputType textInputType;
  final int maxLength;
  final String? Function(String? value) validator;
  final void Function(String value)? onChanged;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HintText(hint: label),
          const SizedBox(height: 4),
          TextInputFields(
            key: Key(fieldKey),
            maxLines: 1,
            initialValue: initialValue,
            textInputType: textInputType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            validator: validator,
            onChanged: onChanged ?? (value) => validator(value),
          ),
        ],
      ),
    );
  }
}
