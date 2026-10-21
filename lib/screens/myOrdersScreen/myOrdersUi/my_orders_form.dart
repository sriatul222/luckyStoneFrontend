import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/route_observer.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersCubit/my_orders_cubit.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersCubit/my_orders_state.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersModel/my_orders_model.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class MyOrdersForm extends StatefulWidget {
  const MyOrdersForm({super.key});

  @override
  State<MyOrdersForm> createState() => _MyOrdersFormState();
}

class _MyOrdersFormState extends State<MyOrdersForm>
    with RefreshOnReturn<MyOrdersForm> {
  // An order may have been cancelled on Order Details
  @override
  void onReturn() => context.read<MyOrdersCubit>().getOrders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: TextConstants.myOrders,
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
            builder: (context, state) {
              if (state.orders.isEmpty) {
                if (state.status.isSubmissionInProgress ||
                    state.status.isPure) {
                  return const Loading();
                }
                return EmptyStateWidget(
                  icon: Icons.receipt_long_outlined,
                  message: state.status.isSubmissionFailure
                      ? 'Unable to load your orders.'
                      : TextConstants.noOrders,
                  buttonName: state.status.isSubmissionFailure
                      ? 'Retry'
                      : TextConstants.continueShopping,
                  onTap: state.status.isSubmissionFailure
                      ? () => context.read<MyOrdersCubit>().getOrders()
                      : () => Navigator.popUntil(
                          context,
                          ModalRoute.withName(RoutesName.home),
                        ),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 300) {
                    context.read<MyOrdersCubit>().loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  color: MyColor.primary,
                  onRefresh: () => context.read<MyOrdersCubit>().getOrders(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount:
                        state.orders.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.orders.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyColor.gold,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }
                      return _OrderTile(order: state.orders[index]);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('order_${order.id}'),
      onTap: () => Navigator.pushNamed(
        context,
        RoutesName.orderDetails,
        arguments: order.id,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColor.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '#${order.orderNumber}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MyColor.primaryDark,
                    ),
                  ),
                ),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              MyUtils.dateTime(order.createdAt),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: MyColor.hintColor,
              ),
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${order.itemCount} item(s) • ${order.paymentLabel}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: MyColor.darkGrey,
                    ),
                  ),
                ),
                Text(
                  MyUtils.exactPrice(order.total),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MyColor.primary,
                  ),
                ),
                const Icon(Icons.chevron_right, color: MyColor.hintColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
