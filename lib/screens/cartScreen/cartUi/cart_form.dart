import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/route_observer.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/cartScreen/cartCubit/cart_cubit.dart';
import 'package:luckystone/screens/cartScreen/cartCubit/cart_state.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class CartForm extends StatefulWidget {
  const CartForm({super.key});

  @override
  State<CartForm> createState() => _CartFormState();
}

class _CartFormState extends State<CartForm> with RefreshOnReturn<CartForm> {
  // Back from Product Details / Checkout: prices or items may have changed
  @override
  void onReturn() => context.read<CartCubit>().getCart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: TextConstants.myCart,
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cart = state.cart;
              if (cart.isEmpty) {
                if (state.status.isSubmissionInProgress ||
                    state.status.isPure) {
                  return const Loading();
                }
                return EmptyStateWidget(
                  icon: Icons.shopping_bag_outlined,
                  message: state.status.isSubmissionFailure
                      ? 'Unable to load your bag.'
                      : TextConstants.emptyCart,
                  buttonName: state.status.isSubmissionFailure
                      ? 'Retry'
                      : TextConstants.continueShopping,
                  onTap: state.status.isSubmissionFailure
                      ? () => context.read<CartCubit>().getCart()
                      : () => Navigator.pushReplacementNamed(
                          context,
                          RoutesName.productList,
                        ),
                );
              }
              return Stack(
                children: [
                  RefreshIndicator(
                    color: MyColor.primary,
                    onRefresh: () => context.read<CartCubit>().getCart(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        ...cart.items.map((item) => _CartItemTile(item: item)),
                        CartPriceSummary(summary: cart.summary),
                      ],
                    ),
                  ),
                  if (state.updateStatus.isSubmissionInProgress)
                    const Loading(),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        buildWhen: (previous, current) => previous.cart != current.cart,
        builder: (context, state) {
          final cart = state.cart;
          if (cart.isEmpty) return const SizedBox.shrink();
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyUtils.exactPrice(cart.summary.total),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: MyColor.primary,
                          ),
                        ),
                        Text(
                          '${cart.summary.totalQuantity} item(s) incl. GST',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: MyColor.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: ButtonWidget(
                      key: const Key('checkoutButton'),
                      buttonName: TextConstants.checkout,
                      filled: true,
                      onTap: () {
                        if (cart.hasUnavailableItems) {
                          FlutterToast.showToast(
                            'Please remove out of stock items first',
                          );
                          return;
                        }
                        Navigator.pushNamed(context, RoutesName.checkout);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final cubit = context.read<CartCubit>();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColor.lightGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              RoutesName.productDetails,
              arguments: product.id,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 84,
                height: 84,
                child: ProductImage(imageUrl: product.imageUrl),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MyColor.darkGrey,
                        ),
                      ),
                    ),
                    InkWell(
                      key: Key('removeCartItem_${item.id}'),
                      onTap: () => cubit.removeItem(item),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: MyColor.hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  [
                    '${product.purity} ${product.metal}',
                    '${product.netWeight} g',
                    if (item.size.isNotEmpty) 'Size ${item.size}',
                  ].join(' • '),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: MyColor.hintColor,
                  ),
                ),
                if (!item.isAvailable)
                  Text(
                    product.inStock
                        ? 'Only ${item.availableStock} left in stock'
                        : TextConstants.outOfStock,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: MyColor.discountRed,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityStepper(
                      quantity: item.quantity,
                      onMinus: item.quantity > 1
                          ? () => cubit.updateQuantity(item, item.quantity - 1)
                          : null,
                      onPlus: item.quantity < item.maxQuantity
                          ? () => cubit.updateQuantity(item, item.quantity + 1)
                          : null,
                    ),
                    const Spacer(),
                    Text(
                      MyUtils.exactPrice(item.lineTotal),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MyColor.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, VoidCallback? onTap) => InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? MyColor.lightGray : MyColor.primary,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColor.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove, onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MyColor.darkGrey,
              ),
            ),
          ),
          button(Icons.add, onPlus),
        ],
      ),
    );
  }
}

/// Subtotal / discount / GST / total. Also shown on Checkout.
class CartPriceSummary extends StatelessWidget {
  const CartPriceSummary({super.key, required this.summary});

  final CartSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: TextConstants.priceDetails,
      child: Column(
        children: [
          PriceRow(
            label: 'Subtotal (${summary.totalQuantity} item(s))',
            value: MyUtils.exactPrice(summary.subtotal),
          ),
          if (summary.discount > 0)
            PriceRow(
              label: 'Making charges discount',
              value: '- ${MyUtils.exactPrice(summary.discount)}',
              valueColor: MyColor.success,
            ),
          PriceRow(label: 'GST', value: MyUtils.exactPrice(summary.gst)),
          const PriceRow(
            label: 'Delivery',
            value: 'FREE',
            valueColor: MyColor.success,
          ),
          const Divider(),
          PriceRow(
            label: 'Total Amount',
            value: MyUtils.exactPrice(summary.total),
            bold: true,
          ),
        ],
      ),
    );
  }
}
