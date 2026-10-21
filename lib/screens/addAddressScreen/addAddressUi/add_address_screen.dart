import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressCubit/add_address_cubit.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressUi/add_address_form.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';

class AddAddressScreen extends StatelessWidget {
  /// Pops with the saved AddressModel. Pass [address] to edit it.
  const AddAddressScreen({super.key, this.address});

  final AddressModel? address;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddAddressCubit>(
      create: (BuildContext context) => AddAddressCubit(address),
      child: const AddAddressForm(),
    );
  }
}
