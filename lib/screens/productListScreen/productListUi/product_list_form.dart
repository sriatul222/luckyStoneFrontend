import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/extra/auth_guard.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/common_style.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/productListScreen/productListCubit/product_list_cubit.dart';
import 'package:luckystone/screens/productListScreen/productListCubit/product_list_state.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';
import 'package:luckystone/widgets/button_widget.dart';
import 'package:luckystone/widgets/common_appbar_widget.dart';
import 'package:luckystone/widgets/loading.dart';
import 'package:luckystone/widgets/no_network_widget.dart';
import 'package:luckystone/widgets/product_card.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

class ProductListForm extends StatefulWidget {
  const ProductListForm({super.key});

  @override
  State<ProductListForm> createState() => _ProductListFormState();
}

class _ProductListFormState extends State<ProductListForm> {
  late final TextEditingController _searchController = TextEditingController(
    text: context.read<ProductListCubit>().state.filter.q,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = context.read<ProductListCubit>().state.filter;
    return Scaffold(
      backgroundColor: MyColor.homeBackgroundColor,
      appBar: CommonAppBar(
        title: filter.title.isNotEmpty
            ? filter.title
            : (filter.fromSearch
                  ? TextConstants.search
                  : TextConstants.allJewellery),
        tittleSpace: 0,
        appBar: AppBar(),
        iconButton: true,
        widgets: [
          IconButton(
            onPressed: () =>
                AuthGuard.openWhenLoggedIn(context, RoutesName.wishlist),
            icon: const Icon(Icons.favorite_border, color: MyColor.primary),
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
          child: Column(
            children: [
              _SearchBox(
                controller: _searchController,
                autofocus: filter.fromSearch,
              ),
              const _Toolbar(),
              const Expanded(child: _ProductGridBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.autofocus});

  final TextEditingController controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        key: const Key('productSearch'),
        controller: controller,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        style: textStyleTextFieldInput,
        cursorColor: MyColor.darkGrey,
        onSubmitted: context.read<ProductListCubit>().search,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: MyColor.primaryBg,
          hintText: TextConstants.searchHint,
          hintStyle: textStyleTextField,
          prefixIcon: const Icon(Icons.search, color: MyColor.primary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 18, color: MyColor.hintColor),
            onPressed: () {
              controller.clear();
              context.read<ProductListCubit>().search('');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      buildWhen: (previous, current) =>
          previous.total != current.total ||
          previous.filter != current.filter ||
          previous.status != current.status,
      builder: (context, state) {
        final filterCount = state.filter.appliedFilterCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.status.isSubmissionSuccess
                      ? '${state.total} ${state.total == 1 ? 'design' : 'designs'}'
                      : '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: MyColor.hintColor,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showSortSheet(context, state.filter.sort),
                icon: const Icon(Icons.swap_vert, color: MyColor.primary),
                label: const Text(
                  TextConstants.sortBy,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: MyColor.primary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showFilterSheet(context, state.filter),
                icon: Badge(
                  isLabelVisible: filterCount > 0,
                  label: Text('$filterCount'),
                  backgroundColor: MyColor.gold,
                  child: const Icon(Icons.tune, color: MyColor.primary),
                ),
                label: const Text(
                  TextConstants.filter,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: MyColor.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortSheet(BuildContext context, String selected) {
    final cubit = context.read<ProductListCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetTitle(title: TextConstants.sortBy),
            ...ProductListFilter.sortOptions.entries.map((entry) {
              final isSelected = entry.key == selected;
              return ListTile(
                title: Text(
                  entry.value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? MyColor.primary : MyColor.darkGrey,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: MyColor.primary)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  cubit.changeSort(entry.key);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, ProductListFilter filter) {
    final cubit = context.read<ProductListCubit>();
    String? metal = filter.metal;
    String? purity = filter.purity;
    int priceIndex = ProductListFilter.priceRanges.indexWhere(
      (range) => range.$2 == filter.minPrice && range.$3 == filter.maxPrice,
    );
    if (filter.minPrice == null && filter.maxPrice == null) priceIndex = -1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SheetTitle(title: TextConstants.filter),
                const _FilterLabel(text: 'Metal'),
                Wrap(
                  spacing: 8,
                  children: ProductListFilter.metals
                      .map(
                        (value) => _FilterChip(
                          label: value[0].toUpperCase() + value.substring(1),
                          selected: metal == value,
                          onTap: () => setSheetState(
                            () => metal = metal == value ? null : value,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const _FilterLabel(text: 'Purity'),
                Wrap(
                  spacing: 8,
                  children: ProductListFilter.purities
                      .map(
                        (value) => _FilterChip(
                          label: value,
                          selected: purity == value,
                          onTap: () => setSheetState(
                            () => purity = purity == value ? null : value,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const _FilterLabel(text: 'Price'),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    ProductListFilter.priceRanges.length,
                    (index) => _FilterChip(
                      label: ProductListFilter.priceRanges[index].$1,
                      selected: priceIndex == index,
                      onTap: () => setSheetState(
                        () => priceIndex = priceIndex == index ? -1 : index,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        buttonName: 'Clear All',
                        onTap: () {
                          Navigator.pop(sheetContext);
                          cubit.applyFilter(filter.withFilters());
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ButtonWidget(
                        buttonName: 'Apply',
                        filled: true,
                        onTap: () {
                          final range = priceIndex >= 0
                              ? ProductListFilter.priceRanges[priceIndex]
                              : null;
                          Navigator.pop(sheetContext);
                          cubit.applyFilter(
                            filter.withFilters(
                              metal: metal,
                              purity: purity,
                              minPrice: range?.$2,
                              maxPrice: range?.$3,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MyColor.primaryDark,
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: MyColor.darkGrey,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: MyColor.primary,
      backgroundColor: MyColor.primaryBg,
      side: BorderSide(color: selected ? MyColor.primary : MyColor.lightGray),
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        color: selected ? MyColor.white : MyColor.primary,
      ),
    );
  }
}

class _ProductGridBody extends StatelessWidget {
  const _ProductGridBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress && state.products.isEmpty) {
          return const Loading();
        }
        if (state.products.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.search_off,
            message: state.status.isSubmissionFailure
                ? 'Unable to load. Please try again.'
                : TextConstants.noProducts,
            buttonName: state.status.isSubmissionFailure ? 'Retry' : null,
            onTap: () => context.read<ProductListCubit>().getProducts(),
          );
        }
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.extentAfter < 400) {
                  context.read<ProductListCubit>().loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                color: MyColor.primary,
                onRefresh: () => context.read<ProductListCubit>().getProducts(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      sliver: SliverGrid.builder(
                        itemCount: state.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.64,
                            ),
                        itemBuilder: (context, index) =>
                            ProductCard(product: state.products[index]),
                      ),
                    ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyColor.gold,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Re-loading page 1 after a sort / filter change
            if (state.status.isSubmissionInProgress) const Loading(),
          ],
        );
      },
    );
  }
}
