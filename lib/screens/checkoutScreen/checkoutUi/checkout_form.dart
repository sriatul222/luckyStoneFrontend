import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/addressScreen/addressUi/address_form.dart';
import 'package:luckystone/screens/cartScreen/cartUi/cart_form.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutCubit/checkout_cubit.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutCubit/checkout_state.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class CheckoutForm extends StatelessWidget {
  const CheckoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) =>
          previous.orderStatus != current.orderStatus,
      listener: (context, state) {
        final order = state.placedOrder;
        if (state.orderStatus.isSubmissionSuccess && order != null) {
          _showOrderPlacedDialog(context, order);
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.homeBackgroundColor,
        appBar: CommonAppBar(
          title: TextConstants.checkout,
          tittleSpace: 0,
          appBar: AppBar(),
          iconButton: true,
        ),
        body: SafeArea(
          child: NoNetworkWidget(
            child: BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (context, state) {
                if (state.status.isSubmissionInProgress ||
                    state.status.isPure) {
                  return const Loading();
                }
                if (state.status.isSubmissionFailure) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    message: 'Unable to load checkout.',
                    buttonName: 'Retry',
                    onTap: () =>
                        context.read<CheckoutCubit>().getCheckoutData(),
                  );
                }
                if (state.cart.isEmpty && state.placedOrder == null) {
                  return EmptyStateWidget(
                    icon: Icons.shopping_bag_outlined,
                    message: TextConstants.emptyCart,
                    buttonName: TextConstants.continueShopping,
                    onTap: () => Navigator.popUntil(
                      context,
                      ModalRoute.withName(RoutesName.home),
                    ),
                  );
                }
                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        _AddressSection(address: state.selectedAddress),
                        _ItemsSection(state: state),
                        const _PaymentSection(),
                        CartPriceSummary(summary: state.cart.summary),
                      ],
                    ),
                    if (state.orderStatus.isSubmissionInProgress)
                      const Loading(),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<CheckoutCubit, CheckoutState>(
          buildWhen: (previous, current) =>
              previous.cart != current.cart ||
              previous.status != current.status,
          builder: (context, state) {
            if (!state.status.isSubmissionSuccess || state.cart.isEmpty) {
              return const SizedBox.shrink();
            }
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                decoration: BoxDecoration(
                  color: MyColor.white,
                  border: Border(top: BorderSide(color: MyColor.lightGray)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        MyUtils.exactPrice(state.cart.summary.total),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: MyColor.primary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: ButtonWidget(
                        key: const Key('placeOrderButton'),
                        buttonName: TextConstants.placeOrder,
                        filled: true,
                        onTap: () => context.read<CheckoutCubit>().placeOrder(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showOrderPlacedDialog(BuildContext context, OrderDetailsModel order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: MyColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: MyColor.goldLight,
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: MyColor.success,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                TextConstants.orderPlaced,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: MyColor.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Order #${order.order.orderNumber}\n'
                '${MyUtils.exactPrice(order.order.total)} • ${order.order.paymentLabel}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: MyColor.hintColor,
                ),
              ),
              const SizedBox(height: 18),
              ButtonWidget(
                key: const Key('viewMyOrdersButton'),
                buttonName: TextConstants.myOrders,
                filled: true,
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  dialogContext,
                  RoutesName.myOrders,
                  ModalRoute.withName(RoutesName.home),
                ),
              ),
              ButtonWidget(
                buttonName: TextConstants.continueShopping,
                onTap: () => Navigator.popUntil(
                  dialogContext,
                  ModalRoute.withName(RoutesName.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.address});

  final AddressModel? address;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    return SectionCard(
      title: TextConstants.deliveryAddress,
      trailing: address == null
          ? null
          : GestureDetector(
              key: const Key('changeAddressButton'),
              onTap: () async {
                final picked = await Navigator.pushNamed(
                  context,
                  RoutesName.addressList,
                  arguments: true,
                );
                if (picked is AddressModel) cubit.selectAddress(picked);
              },
              child: const Text(
                'CHANGE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MyColor.gold,
                ),
              ),
            ),
      child: address == null
          ? ButtonWidget(
              key: const Key('checkoutAddAddressButton'),
              buttonName: '+ ${TextConstants.addAddress}',
              onTap: () async {
                final saved = await Navigator.pushNamed(
                  context,
                  RoutesName.addAddress,
                );
                if (saved is AddressModel) cubit.selectAddress(saved);
              },
            )
          : AddressDetails(address: address!),
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Items (${state.cart.summary.totalQuantity})',
      child: Column(
        children: state.cart.items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: ProductImage(
                          imageUrl: item.product.imageUrl,
                          iconSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: MyColor.darkGrey,
                            ),
                          ),
                          Text(
                            [
                              'Qty ${item.quantity}',
                              if (item.size.isNotEmpty) 'Size ${item.size}',
                            ].join(' • '),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: MyColor.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      MyUtils.exactPrice(item.lineTotal),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MyColor.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: TextConstants.paymentMethod,
      child: Column(
        children: [
          _PaymentOption(
            icon: Icons.payments_outlined,
            label: TextConstants.cashOnDelivery,
            selected: true,
          ),
          _PaymentOption(
            icon: Icons.credit_card,
            label: TextConstants.onlinePayment,
            selected: false,
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.selected,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? MyColor.darkGrey : MyColor.hintColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? MyColor.primary : MyColor.lightGray,
            size: 20,
          ),
          const SizedBox(width: 10),
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
