import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/addressScreen/addressCubit/address_cubit.dart';
import 'package:luckystone/screens/addressScreen/addressUi/address_form.dart';

class AddressScreen extends StatelessWidget {
  /// [selectMode] = opened from Checkout: tapping an address returns it.
  const AddressScreen({super.key, this.selectMode = false});

  final bool selectMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressCubit>(
      create: (BuildContext context) => AddressCubit()..getAddresses(),
      child: AddressForm(selectMode: selectMode),
    );
  }
}
