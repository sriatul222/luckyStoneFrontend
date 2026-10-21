import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';
import 'package:luckystone/widgets/shop_widgets.dart';

/// Product tile used on home, product list and wishlist.
/// Tapping it opens Product Details unless [onTap] is given.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.topRight,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  // Optional action over the image, e.g. the wishlist remove button
  final Widget? topRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () => Navigator.pushNamed(
            context,
            RoutesName.productDetails,
            arguments: product.id,
          ),
      child: Container(
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColor.lightGray),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      iconSize: 48,
                    ),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      left: 0,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: MyColor.gold,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          '${product.discountPercent.toStringAsFixed(0)}% off making',
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: MyColor.white,
                          ),
                        ),
                      ),
                    ),
                  if (topRight != null)
                    Positioned(right: 4, top: 4, child: topRight!),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: MyColor.darkGrey,
                    ),
                  ),
                  Text(
                    '${product.purity} ${product.metal} • ${product.netWeight} g',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      color: MyColor.hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    MyUtils.price(product.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: MyColor.primary,
                    ),
                  ),
                  Text(
                    product.hasDiscount
                        ? MyUtils.price(product.originalPrice)
                        : (product.inStock ? '' : 'Out of stock'),
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: product.hasDiscount
                          ? MyColor.hintColor
                          : MyColor.discountRed,
                      decoration: product.hasDiscount
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
