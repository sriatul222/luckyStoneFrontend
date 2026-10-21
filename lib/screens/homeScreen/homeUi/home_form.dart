import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/app_constants.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/extra/auth_guard.dart';
import 'package:luckystone/extra/biometric_auth.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/extra/shared_preferences.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/homeScreen/homeCubit/home_cubit.dart';
import 'package:luckystone/screens/homeScreen/homeCubit/home_state.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';
import 'package:luckystone/screens/loginScreen/loginModel/login_model.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/product_card.dart';
import 'package:luckystone/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: '',
        tittleSpace: 16,
        appBar: AppBar(),
        iconButton: false,
        widgets: [
          IconButton(
            key: const Key('homeSearch'),
            onPressed: () => Navigator.pushNamed(
              context,
              RoutesName.productList,
              arguments: const ProductListFilter(fromSearch: true),
            ),
            icon: const Icon(Icons.search, color: MyColor.primary),
          ),
          IconButton(
            key: const Key('homeWishlist'),
            onPressed: () =>
                AuthGuard.openWhenLoggedIn(context, RoutesName.wishlist),
            icon: const Icon(Icons.favorite_border, color: MyColor.primary),
          ),
          IconButton(
            key: const Key('homeCart'),
            onPressed: () =>
                AuthGuard.openWhenLoggedIn(context, RoutesName.cart),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: MyColor.primary,
            ),
          ),
          IconButton(
            key: const Key('homeAccount'),
            onPressed: () => _showAccountSheet(context),
            icon: const Icon(Icons.person_outline, color: MyColor.primary),
          ),
        ],
      ),
      body: SafeArea(
        child: NoNetworkWidget(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final home = state.homeData;
              return Stack(
                children: [
                  RefreshIndicator(
                    color: MyColor.primary,
                    onRefresh: () => context.read<HomeCubit>().getHomeData(),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: [
                        if (home.banners.isNotEmpty)
                          _BannerSlider(
                            banners: home.banners,
                            currentIndex: state.bannerIndex,
                          ),
                        if (home.metalRates.isNotEmpty)
                          _MetalRateStrip(rates: home.metalRates),
                        if (home.categories.isNotEmpty) ...[
                          _SectionTitle(
                            title: TextConstants.shopByCategory,
                            onViewAll: () => Navigator.pushNamed(
                              context,
                              RoutesName.productList,
                            ),
                          ),
                          _CategoryList(categories: home.categories),
                        ],
                        if (home.featured.isNotEmpty) ...[
                          _SectionTitle(
                            title: TextConstants.featured,
                            onViewAll: () => Navigator.pushNamed(
                              context,
                              RoutesName.productList,
                              arguments: const ProductListFilter(
                                title: TextConstants.featured,
                                featured: true,
                                sort: 'popular',
                              ),
                            ),
                          ),
                          _HorizontalProducts(products: home.featured),
                        ],
                        if (home.newArrivals.isNotEmpty) ...[
                          _SectionTitle(
                            title: TextConstants.newArrivals,
                            onViewAll: () => Navigator.pushNamed(
                              context,
                              RoutesName.productList,
                              arguments: const ProductListFilter(
                                title: TextConstants.newArrivals,
                              ),
                            ),
                          ),
                          _ProductGrid(products: home.newArrivals),
                        ],
                        if (state.status.isSubmissionFailure &&
                            home.categories.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: Center(
                              child: GreyText(
                                text: 'Unable to load. Pull down to retry.',
                                size: 14,
                                color: MyColor.darkGrey,
                                font: 'Poppins',
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (state.status.isSubmissionInProgress) const Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MyColor.primaryDark,
              ),
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                TextConstants.viewAll,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MyColor.gold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerSlider extends StatelessWidget {
  const _BannerSlider({required this.banners, required this.currentIndex});

  final List<BannerModel> banners;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: banners.map((banner) {
            return GestureDetector(
              onTap: () => _openBanner(context, banner),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [MyColor.primary, MyColor.roseGold],
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (banner.imageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: AppURLs.mediaUrl(banner.imageUrl),
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => const SizedBox.shrink(),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: MyColor.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (banner.subtitle.isNotEmpty)
                            Text(
                              banner.subtitle,
                              style: const TextStyle(
                                color: MyColor.goldLight,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 170,
            viewportFraction: 0.92,
            autoPlay: banners.length > 1,
            onPageChanged: (index, _) =>
                context.read<HomeCubit>().changeBanner(index),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
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
      ],
    );
  }
}

class _MetalRateStrip extends StatelessWidget {
  const _MetalRateStrip({required this.rates});

  final List<MetalRateModel> rates;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: MyColor.goldLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColor.gold.withValues(alpha: .6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            TextConstants.todayGoldRate,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: MyColor.goldDark,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: rates.map((rate) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rate.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          color: MyColor.darkGrey,
                        ),
                      ),
                      Text(
                        '${MyUtils.price(rate.ratePerGram)}/g',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: MyColor.primaryDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              RoutesName.productList,
              arguments: ProductListFilter(
                title: category.name,
                category: category.slug,
              ),
            ),
            child: SizedBox(
              width: 68,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: MyColor.primaryBg,
                    backgroundImage: category.imageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(
                            AppURLs.mediaUrl(category.imageUrl),
                          )
                        : null,
                    child: category.imageUrl.isEmpty
                        ? const Icon(
                            Icons.diamond_outlined,
                            color: MyColor.primary,
                          )
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: MyColor.darkGrey,
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

class _HorizontalProducts extends StatelessWidget {
  const _HorizontalProducts({required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            SizedBox(width: 160, child: ProductCard(product: products[index])),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}

/// Banner redirect_type: category / collection -> product list,
/// product -> product details, url -> browser, none -> nothing.
void _openBanner(BuildContext context, BannerModel banner) {
  final value = banner.redirectValue;
  if (value.isEmpty) return;
  switch (banner.redirectType) {
    case 'category':
      Navigator.pushNamed(
        context,
        RoutesName.productList,
        arguments: ProductListFilter(title: banner.title, category: value),
      );
      break;
    case 'collection':
      Navigator.pushNamed(
        context,
        RoutesName.productList,
        arguments: ProductListFilter(title: banner.title, collection: value),
      );
      break;
    case 'product':
      final productId = int.tryParse(value);
      if (productId != null) {
        Navigator.pushNamed(
          context,
          RoutesName.productDetails,
          arguments: productId,
        );
      }
      break;
    case 'url':
      launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
      break;
  }
}

/// Account menu: Login / Register for guests; orders, addresses, Face ID
/// login switch and logout for logged-in users.
Future<void> _showAccountSheet(BuildContext context) async {
  String userName = '';
  final savedUser = AppPreferences.shared.getSharedPreferences(
    AppConstants.user,
  );
  if (isLoggedIn && savedUser is String && savedUser.isNotEmpty) {
    try {
      userName = UserModel.fromJson(jsonDecode(savedUser)).name;
    } catch (_) {}
  }

  // "Face ID" / "Fingerprint" switch, only when the phone has one
  final biometric = BiometricAuth.instance;
  String biometricLabel = '';
  bool biometricOn = false;
  if (isLoggedIn) {
    biometricLabel = await biometric.availableLabel();
    if (biometricLabel.isNotEmpty) {
      final saved = await biometric.savedUser();
      biometricOn =
          saved != null && saved['email'] == biometric.currentUser()?['email'];
    }
  }
  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    backgroundColor: MyColor.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      void open(String routeName) {
        Navigator.pop(sheetContext);
        AuthGuard.openWhenLoggedIn(context, routeName);
      }

      Widget tile(IconData icon, String title, VoidCallback onTap, {Key? key}) {
        return ListTile(
          key: key,
          leading: Icon(icon, color: MyColor.primary),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: MyColor.darkGrey,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: MyColor.hintColor),
          onTap: onTap,
        );
      }

      return SafeArea(
        child: StatefulBuilder(
          builder: (sheetContext, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: MyColor.primaryBg,
                  child: Icon(Icons.person, color: MyColor.primary),
                ),
                title: Text(
                  isLoggedIn
                      ? (userName.isNotEmpty ? 'Hi, $userName' : 'Hi there')
                      : 'Welcome, Guest',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColor.primaryDark,
                  ),
                ),
                subtitle: Text(
                  isLoggedIn
                      ? TextConstants.tagLine
                      : 'Login to see your bag, wishlist and orders',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
              ),
              const Divider(height: 1),
              if (isLoggedIn) ...[
                tile(
                  Icons.receipt_long_outlined,
                  TextConstants.myOrders,
                  () => open(RoutesName.myOrders),
                  key: const Key('accountMyOrders'),
                ),
                tile(
                  Icons.favorite_border,
                  TextConstants.myWishlist,
                  () => open(RoutesName.wishlist),
                ),
                tile(
                  Icons.shopping_bag_outlined,
                  TextConstants.myCart,
                  () => open(RoutesName.cart),
                ),
                tile(
                  Icons.location_on_outlined,
                  TextConstants.myAddresses,
                  () => open(RoutesName.addressList),
                ),
                if (biometricLabel.isNotEmpty)
                  SwitchListTile(
                    key: const Key('accountBiometricSwitch'),
                    secondary: Icon(
                      BiometricAuth.iconFor(biometricLabel),
                      color: MyColor.primary,
                    ),
                    title: Text(
                      'Login with $biometricLabel',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: MyColor.darkGrey,
                      ),
                    ),
                    value: biometricOn,
                    activeTrackColor: MyColor.primary,
                    onChanged: (turnOn) async {
                      if (turnOn) {
                        if (!await biometric.turnOnForCurrentUser(
                          biometricLabel,
                        )) {
                          return;
                        }
                      } else {
                        await biometric.disable();
                      }
                      FlutterToast.showToast(
                        '$biometricLabel login turned ${turnOn ? 'on' : 'off'}',
                      );
                      if (sheetContext.mounted) {
                        setSheetState(() => biometricOn = turnOn);
                      }
                    },
                  ),
                tile(Icons.logout, TextConstants.logout, () async {
                  Navigator.pop(sheetContext);
                  await AppPreferences.shared.clearLogin();
                  FlutterToast.showToast('Logged out');
                }),
              ] else ...[
                tile(
                  Icons.login,
                  '${TextConstants.login} / ${TextConstants.register}',
                  () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(context, RoutesName.login);
                  },
                  key: const Key('accountLogin'),
                ),
                tile(
                  Icons.receipt_long_outlined,
                  TextConstants.myOrders,
                  () => open(RoutesName.myOrders),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
