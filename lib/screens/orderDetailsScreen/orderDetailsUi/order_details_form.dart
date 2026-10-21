import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/addressScreen/addressUi/address_form.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsCubit/order_details_cubit.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsCubit/order_details_state.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class OrderDetailsForm extends StatelessWidget {
  const OrderDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: TextConstants.orderDetails,
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
            builder: (context, state) {
              final details = state.details;
              if (details == null) {
                if (state.status.isSubmissionFailure) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    message: 'Unable to load this order.',
                    buttonName: 'Retry',
                    onTap: () => context.read<OrderDetailsCubit>().getOrder(),
                  );
                }
                return const Loading();
              }
              final order = details.order;
              return Stack(
                children: [
                  RefreshIndicator(
                    color: MyColor.primary,
                    onRefresh: () =>
                        context.read<OrderDetailsCubit>().getOrder(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        SectionCard(
                          title: '#${order.orderNumber}',
                          trailing: OrderStatusChip(status: order.status),
                          child: Column(
                            children: [
                              PriceRow(
                                label: 'Placed on',
                                value: MyUtils.dateTime(order.createdAt),
                              ),
                              PriceRow(
                                label: 'Payment',
                                value: order.paymentLabel,
                              ),
                              PriceRow(
                                label: 'Payment status',
                                value: order.paymentStatus,
                              ),
                            ],
                          ),
                        ),
                        SectionCard(
                          title: 'Items (${details.items.length})',
                          child: Column(
                            children: details.items
                                .map((item) => _OrderItemTile(item: item))
                                .toList(),
                          ),
                        ),
                        SectionCard(
                          title: TextConstants.deliveryAddress,
                          child: AddressDetails(
                            address: details.shippingAddress,
                          ),
                        ),
                        SectionCard(
                          title: TextConstants.priceDetails,
                          child: Column(
                            children: [
                              PriceRow(
                                label: 'Subtotal',
                                value: MyUtils.exactPrice(order.subtotal),
                              ),
                              if (order.discount > 0)
                                PriceRow(
                                  label: 'Making charges discount',
                                  value:
                                      '- ${MyUtils.exactPrice(order.discount)}',
                                  valueColor: MyColor.success,
                                ),
                              PriceRow(
                                label: 'GST',
                                value: MyUtils.exactPrice(order.gst),
                              ),
                              const Divider(),
                              PriceRow(
                                label: 'Order Total',
                                value: MyUtils.exactPrice(order.total),
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                        if (order.canCancel)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                            child: ButtonWidget(
                              key: const Key('cancelOrderButton'),
                              buttonName: TextConstants.cancelOrder,
                              onTap: () => _confirmCancel(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (state.cancelStatus.isSubmissionInProgress ||
                      (state.status.isSubmissionInProgress))
                    const Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    final cubit = context.read<OrderDetailsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Cancel this order?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        content: const Text(
          'The items will be released and you will not be charged.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Keep Order',
              style: TextStyle(color: MyColor.hintColor),
            ),
          ),
          TextButton(
            key: const Key('confirmCancelOrder'),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.cancelOrder();
            },
            child: const Text(
              TextConstants.cancelOrder,
              style: TextStyle(color: MyColor.discountRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.productId == null
          ? null
          : () => Navigator.pushNamed(
              context,
              RoutesName.productDetails,
              arguments: item.productId,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: ProductImage(imageUrl: item.imageUrl, iconSize: 24),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
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
                      '${item.purity} ${item.metal}',
                      '${item.netWeight} g',
                      if (item.size.isNotEmpty) 'Size ${item.size}',
                      'Qty ${item.quantity}',
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
    );
  }
}
