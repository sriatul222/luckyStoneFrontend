import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';

class BreadcrumbWidget extends StatelessWidget {
  final List<String> items;

  const BreadcrumbWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = items.where((item) => item.trim().isNotEmpty).toList();
    final maxLabelWidth = MediaQuery.of(context).size.width * 0.5;

    if (breadcrumbs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(
        breadcrumbs.length * 2 - 1,
        (index) {
          if (index.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: MyColor.primaryGrey,
              ),
            );
          }

          final itemIndex = index ~/ 2;
          final isLast = itemIndex == breadcrumbs.length - 1;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxLabelWidth),
            child: Text(
              breadcrumbs[itemIndex],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: isLast ? MyColor.primary : MyColor.primaryGrey,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
