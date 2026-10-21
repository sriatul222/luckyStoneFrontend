import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/addressScreen/addressCubit/address_cubit.dart';
import 'package:luckystone/screens/addressScreen/addressCubit/address_state.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class AddressForm extends StatelessWidget {
  const AddressForm({super.key, required this.selectMode});

  final bool selectMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: selectMode
            ? TextConstants.deliveryAddress
            : TextConstants.myAddresses,
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              if (state.addresses.isEmpty) {
                if (state.status.isSubmissionInProgress ||
                    state.status.isPure) {
                  return const Loading();
                }
                return EmptyStateWidget(
                  icon: Icons.location_on_outlined,
                  message: state.status.isSubmissionFailure
                      ? 'Unable to load your addresses.'
                      : TextConstants.noAddress,
                  buttonName: state.status.isSubmissionFailure
                      ? 'Retry'
                      : TextConstants.addAddress,
                  onTap: state.status.isSubmissionFailure
                      ? () => context.read<AddressCubit>().getAddresses()
                      : () => _openAddressForm(context),
                );
              }
              return Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: state.addresses
                        .map(
                          (address) => AddressTile(
                            address: address,
                            onTap: selectMode
                                ? () => Navigator.pop(context, address)
                                : null,
                            actions: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: MyColor.primary,
                                  ),
                                  onPressed: () => _openAddressForm(
                                    context,
                                    address: address,
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: MyColor.hintColor,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(context, address),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (state.deleteStatus.isSubmissionInProgress)
                    const Loading(),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
          child: ButtonWidget(
            key: const Key('addAddressButton'),
            buttonName: '+ ${TextConstants.addAddress}',
            filled: true,
            onTap: () => _openAddressForm(context),
          ),
        ),
      ),
    );
  }

  Future<void> _openAddressForm(
    BuildContext context, {
    AddressModel? address,
  }) async {
    final cubit = context.read<AddressCubit>();
    final saved = await Navigator.pushNamed(
      context,
      RoutesName.addAddress,
      arguments: address,
    );
    if (saved is AddressModel) {
      // From checkout a new address is picked straight away
      if (selectMode && address == null && context.mounted) {
        Navigator.pop(context, saved);
        return;
      }
      cubit.getAddresses();
    }
  }

  void _confirmDelete(BuildContext context, AddressModel address) {
    final cubit = context.read<AddressCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Delete this address?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        content: Text(
          address.fullAddress,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: MyColor.hintColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteAddress(address);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: MyColor.discountRed),
            ),
          ),
        ],
      ),
    );
  }
}

/// One address card. Used on the address list and on Checkout.
class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
    this.onTap,
    this.actions,
  });

  final AddressModel address;
  final VoidCallback? onTap;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 12),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: address.isDefault ? MyColor.gold : MyColor.lightGray,
          ),
        ),
        child: AddressDetails(address: address, trailing: actions),
      ),
    );
  }
}

/// Name / type / default badge + full address + mobile.
class AddressDetails extends StatelessWidget {
  const AddressDetails({super.key, required this.address, this.trailing});

  final AddressModel address;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                address.fullName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MyColor.darkGrey,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _Badge(text: address.addressType.toUpperCase()),
            if (address.isDefault) ...[
              const SizedBox(width: 6),
              const _Badge(text: 'DEFAULT', color: MyColor.goldDark),
            ],
            const Spacer(),
            ?trailing,
          ],
        ),
        const SizedBox(height: 4),
        Text(
          address.fullAddress,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            height: 1.4,
            color: MyColor.hintColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mobile: ${address.mobile}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: MyColor.darkGrey,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.color = MyColor.primary});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
