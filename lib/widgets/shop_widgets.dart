import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/widgets/button_widget.dart';

/// Product photo from the backend's /media path, or the diamond placeholder
/// (seed products have no images yet).
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.imageUrl, this.iconSize = 32});

  final String imageUrl;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.diamond_outlined,
      size: iconSize,
      color: MyColor.primary,
    );
    return Container(
      width: double.infinity,
      color: MyColor.primaryBg,
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: AppURLs.mediaUrl(imageUrl),
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => placeholder,
            )
          : placeholder,
    );
  }
}

/// White rounded card with an optional heading, used for the blocks on
/// product details, cart, checkout and order details.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    required this.child,
    this.trailing,
  });

  final String? title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MyColor.primaryDark,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}

/// "Label ........ ₹value" row for price breakup and order summaries.
class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: bold ? 14 : 12,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: MyColor.darkGrey,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            value,
            style: style.copyWith(
              color: valueColor ?? (bold ? MyColor.primary : null),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered icon + message (+ optional button) for empty lists.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.buttonName,
    this.onTap,
  });

  final IconData icon;
  final String message;
  final String? buttonName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: MyColor.primaryBg,
              child: Icon(icon, size: 40, color: MyColor.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: MyColor.darkGrey,
              ),
            ),
            if (buttonName != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ButtonWidget(buttonName: buttonName!, onTap: onTap),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Coloured chip for order status (PLACED / CONFIRMED / SHIPPED / ...).
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'DELIVERED':
        return MyColor.success;
      case 'CANCELLED':
        return MyColor.discountRed;
      case 'SHIPPED':
        return MyColor.oceanBlue;
      case 'CONFIRMED':
        return MyColor.goldDark;
      default:
        return MyColor.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
