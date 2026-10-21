import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/route_observer.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistCubit/wishlist_cubit.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistCubit/wishlist_state.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/product_card.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class WishlistForm extends StatefulWidget {
  const WishlistForm({super.key});

  @override
  State<WishlistForm> createState() => _WishlistFormState();
}

class _WishlistFormState extends State<WishlistForm>
    with RefreshOnReturn<WishlistForm> {
  // The heart may have been changed on Product Details
  @override
  void onReturn() => context.read<WishlistCubit>().getWishlist();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: TextConstants.myWishlist,
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
        widgets: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, RoutesName.cart),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: MyColor.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              if (state.products.isEmpty) {
                if (state.status.isSubmissionInProgress ||
                    state.status.isPure) {
                  return const Loading();
                }
                return EmptyStateWidget(
                  icon: Icons.favorite_border,
                  message: state.status.isSubmissionFailure
                      ? 'Unable to load your wishlist.'
                      : TextConstants.emptyWishlist,
                  buttonName: state.status.isSubmissionFailure
                      ? 'Retry'
                      : TextConstants.continueShopping,
                  onTap: state.status.isSubmissionFailure
                      ? () => context.read<WishlistCubit>().getWishlist()
                      : () => Navigator.pushNamed(
                          context,
                          RoutesName.productList,
                        ),
                );
              }
              return Stack(
                children: [
                  RefreshIndicator(
                    color: MyColor.primary,
                    onRefresh: () =>
                        context.read<WishlistCubit>().getWishlist(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.64,
                          ),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          topRight: Material(
                            color: MyColor.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => context.read<WishlistCubit>().remove(
                                product.id,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: MyColor.darkGrey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.removeStatus.isSubmissionInProgress)
                    const Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
