import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/auth_guard.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsCubit/product_details_cubit.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsCubit/product_details_state.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsModel/product_details_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class ProductDetailsForm extends StatelessWidget {
  const ProductDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) =>
          previous.cartStatus != current.cartStatus,
      listener: (context, state) {
        if (!state.cartStatus.isSubmissionSuccess) return;
        if (state.buyNow) {
          Navigator.pushNamed(context, RoutesName.cart);
        } else {
          // The snackbar stays on screen after this page is closed, when this
          // page's context no longer works, so keep the app's navigator.
          final navigator = Navigator.of(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: MyColor.primaryDark,
                content: const Text(
                  'Added to your bag',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                action: SnackBarAction(
                  label: 'VIEW BAG',
                  textColor: MyColor.gold,
                  onPressed: () => navigator.pushNamed(RoutesName.cart),
                ),
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.homeBackgroundColor,
        appBar: CommonAppBar(
          title: TextConstants.productDetails,
          tittleSpace: 0,
          appBar: AppBar(),
          iconButton: true,
          widgets: [
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              buildWhen: (previous, current) =>
                  previous.isWishlisted != current.isWishlisted,
              builder: (context, state) => IconButton(
                key: const Key('wishlistToggle'),
                onPressed: () async {
                  final cubit = context.read<ProductDetailsCubit>();
                  if (await AuthGuard.ensureLoggedIn(context)) {
                    cubit.toggleWishlist();
                  }
                },
                icon: Icon(
                  state.isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: state.isWishlisted
                      ? MyColor.discountRed
                      : MyColor.primary,
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  AuthGuard.openWhenLoggedIn(context, RoutesName.cart),
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: MyColor.primary,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: NoNetworkWidget(
            child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                final details = state.details;
                if (details == null) {
                  if (state.status.isSubmissionFailure) {
                    return EmptyStateWidget(
                      icon: Icons.error_outline,
                      message: 'Unable to load this product.',
                      buttonName: 'Retry',
                      onTap: () =>
                          context.read<ProductDetailsCubit>().getDetails(),
                    );
                  }
                  return const Loading();
                }
                return Stack(
                  children: [
                    RefreshIndicator(
                      color: MyColor.primary,
                      onRefresh: () =>
                          context.read<ProductDetailsCubit>().getDetails(),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          _ImageCarousel(
                            images: details.images,
                            currentIndex: state.imageIndex,
                          ),
                          _TitleBlock(details: details),
                          if (details.needsSize)
                            _SizePicker(
                              sizes: details.sizes,
                              selectedSize: state.selectedSize,
                            ),
                          _PriceBreakupCard(details: details),
                          _SpecsCard(details: details),
                          _ReviewsCard(
                            details: details,
                            reviews: state.reviews,
                          ),
                        ],
                      ),
                    ),
                    if (state.cartStatus.isSubmissionInProgress)
                      const Loading(),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              buildWhen: (previous, current) =>
                  previous.details != current.details,
              builder: (context, state) {
                final details = state.details;
                if (details == null) return const SizedBox.shrink();
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                    decoration: BoxDecoration(
                      color: MyColor.white,
                      border: Border(top: BorderSide(color: MyColor.lightGray)),
                    ),
                    child: details.product.inStock
                        ? Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  key: const Key('addToCartButton'),
                                  buttonName: TextConstants.addToCart,
                                  onTap: () =>
                                      _addToCart(context, buyNow: false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ButtonWidget(
                                  key: const Key('buyNowButton'),
                                  buttonName: TextConstants.buyNow,
                                  filled: true,
                                  onTap: () =>
                                      _addToCart(context, buyNow: true),
                                ),
                              ),
                            ],
                          )
                        : const ButtonWidget(
                            buttonName: TextConstants.outOfStock,
                            onTap: null,
                          ),
                  ),
                );
              },
            ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, {required bool buyNow}) async {
    final cubit = context.read<ProductDetailsCubit>();
    // Ask for the size first, then login, so the guest is not asked twice
    if (!cubit.isSizeSelected()) return;
    if (await AuthGuard.ensureLoggedIn(context)) {
      cubit.addToCart(buyNow: buyNow);
    }
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({required this.images, required this.currentIndex});

  final List<String> images;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    const double height = 300;
    if (images.isEmpty) {
      return const SizedBox(
        height: height,
        child: ProductImage(imageUrl: '', iconSize: 96),
      );
    }
    return Column(
      children: [
        CarouselSlider(
          items: images
              .map(
                (url) => Container(
                  width: double.infinity,
                  color: MyColor.primaryBg,
                  child: CachedNetworkImage(
                    imageUrl: AppURLs.mediaUrl(url),
                    fit: BoxFit.contain,
                    errorWidget: (_, _, _) => const Icon(
                      Icons.diamond_outlined,
                      size: 96,
                      color: MyColor.primary,
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: height,
            viewportFraction: 1,
            enableInfiniteScroll: images.length > 1,
            onPageChanged: (index, _) =>
                context.read<ProductDetailsCubit>().changeImage(index),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final bool active = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: active ? 18 : 6,
                  decoration: BoxDecoration(
                    color: active ? MyColor.gold : MyColor.lightGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.details});

  final ProductDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final product = details.product;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              product.categoryName,
              details.collectionName,
            ].where((text) => text.isNotEmpty).join(' • ').toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              letterSpacing: .8,
              color: MyColor.goldDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MyColor.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            children: [
              Text(
                MyUtils.price(product.price),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: MyColor.primary,
                ),
              ),
              if (product.hasDiscount)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    MyUtils.price(product.originalPrice),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: MyColor.hintColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              if (product.discountPercent > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '${product.discountPercent.toStringAsFixed(0)}% off on making charges',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MyColor.success,
                    ),
                  ),
                ),
            ],
          ),
          const Text(
            'Price inclusive of GST. Based on today\'s metal rate.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: MyColor.hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (product.reviewCount > 0) ...[
                const Icon(Icons.star, size: 16, color: MyColor.gold),
                const SizedBox(width: 2),
                Text(
                  '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: MyColor.darkGrey,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                !product.inStock
                    ? TextConstants.outOfStock
                    : details.stock <= 3
                    ? 'Only ${details.stock} left'
                    : 'In stock',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: !product.inStock || details.stock <= 3
                      ? MyColor.discountRed
                      : MyColor.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizePicker extends StatelessWidget {
  const _SizePicker({required this.sizes, required this.selectedSize});

  final List<String> sizes;
  final String selectedSize;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: TextConstants.selectSize,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sizes.map((size) {
          final selected = size == selectedSize;
          return GestureDetector(
            key: Key('size_$size'),
            onTap: () => context.read<ProductDetailsCubit>().selectSize(size),
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? MyColor.primary : MyColor.white,
                border: Border.all(
                  color: selected ? MyColor.primary : MyColor.lightGray,
                ),
              ),
              child: Text(
                size,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? MyColor.white : MyColor.darkGrey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PriceBreakupCard extends StatelessWidget {
  const _PriceBreakupCard({required this.details});

  final ProductDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final breakup = details.priceBreakup;
    final product = details.product;
    return SectionCard(
      title: TextConstants.priceBreakup,
      child: Column(
        children: [
          PriceRow(
            label:
                '${product.purity} ${product.metal} (${product.netWeight} g × ${MyUtils.exactPrice(breakup.metalRate)}/g)',
            value: MyUtils.exactPrice(breakup.metalValue),
          ),
          PriceRow(
            label:
                'Making charges (${details.makingChargePercent.toStringAsFixed(0)}%)',
            value: MyUtils.exactPrice(breakup.makingCharges),
          ),
          if (breakup.makingDiscount > 0)
            PriceRow(
              label: 'Making charges discount',
              value: '- ${MyUtils.exactPrice(breakup.makingDiscount)}',
              valueColor: MyColor.success,
            ),
          if (breakup.stoneValue > 0)
            PriceRow(
              label: details.stoneType.isNotEmpty
                  ? '${details.stoneType} value'
                  : 'Stone value',
              value: MyUtils.exactPrice(breakup.stoneValue),
            ),
          const Divider(),
          PriceRow(
            label: 'Subtotal',
            value: MyUtils.exactPrice(breakup.subtotal),
          ),
          PriceRow(
            label: 'GST (${breakup.gstPercent.toStringAsFixed(0)}%)',
            value: MyUtils.exactPrice(breakup.gst),
          ),
          const Divider(),
          PriceRow(
            label: 'Total',
            value: MyUtils.exactPrice(breakup.total),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SpecsCard extends StatelessWidget {
  const _SpecsCard({required this.details});

  final ProductDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final product = details.product;
    final specs = <(String, String)>[
      ('Metal', '${product.purity} ${_capitalize(product.metal)}'),
      ('Net weight', '${product.netWeight} g'),
      ('Gross weight', '${details.grossWeight} g'),
      if (details.stoneType.isNotEmpty)
        (
          'Stone',
          [
            details.stoneType,
            if (details.stoneWeightCarat > 0) '${details.stoneWeightCarat} ct',
            details.stoneQuality,
          ].where((text) => text.isNotEmpty).join(' • '),
        ),
      if (details.gender.isNotEmpty) ('For', _capitalize(details.gender)),
      if (details.occasion.isNotEmpty)
        ('Occasion', _capitalize(details.occasion)),
      ('SKU', product.sku),
    ];
    return SectionCard(
      title: TextConstants.productSpecs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...specs.map((spec) => PriceRow(label: spec.$1, value: spec.$2)),
          if (details.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              details.description,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                height: 1.5,
                color: MyColor.hintColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

class _ReviewsCard extends StatelessWidget {
  const _ReviewsCard({required this.details, required this.reviews});

  final ProductDetailsModel details;
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    final product = details.product;
    return SectionCard(
      title: TextConstants.reviews,
      trailing: product.reviewCount > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: MyColor.gold),
                Text(
                  ' ${product.rating.toStringAsFixed(1)} / 5',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MyColor.darkGrey,
                  ),
                ),
              ],
            )
          : null,
      child: reviews.isEmpty
          ? const Text(
              TextConstants.noReviews,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: MyColor.hintColor,
              ),
            )
          : Column(
              children: reviews
                  .map((review) => _ReviewTile(review: review))
                  .toList(),
            ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  size: 14,
                  color: MyColor.gold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.userName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MyColor.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                review.comment,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: MyColor.hintColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
