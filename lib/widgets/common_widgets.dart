import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/size_constants.dart';

import '../extra/common_style.dart';

class ListingCards extends StatelessWidget {
  final int? count;
  final String title;
  final int? colorIndex;
  final Color? themeColor;
  final bool isNotificationList;

  static final List<Color> _themeColors = [
    MyColor.orange,
    MyColor.mintGreen,
    MyColor.richRed,
    MyColor.blue,
    MyColor.primary,
    MyColor.darkMaroon
  ];
  static final List<Color> _notificationThemeColors = [
    MyColor.mintGreen,
    MyColor.darkMaroon,
    MyColor.oceanBlue,
    MyColor.orange,
  ];

  const ListingCards(
      {super.key,
      this.count,
      required this.title,
      this.colorIndex,
      this.themeColor,
      this.isNotificationList = false});

  @override
  Widget build(BuildContext context) {
    final Color appliedThemeColor = isNotificationList
        ? themeColor ??
            _notificationThemeColors[
                (colorIndex ?? 0) % _notificationThemeColors.length]
        : themeColor ?? _themeColors[(colorIndex ?? 0) % _themeColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(width: 5, color: appliedThemeColor)),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.0))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (count != null)
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appliedThemeColor.withValues(
                            alpha: SizeConstants.opacity,
                          ),
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 1.5, color: appliedThemeColor),
                          // boxShadow: [
                          // BoxShadow(
                          //     color: Colors.grey.withOpacity(0.7),
                          //     blurRadius: 20.0,
                          //     spreadRadius: 0.0,
                          //     offset: Offset(0.0, 10.0)
                          // )
                          // ],
                        ),
                        padding: const EdgeInsets.all(7),
                        child: Text(
                          count.toString(),
                          style: textStyleNormal.copyWith(
                            color: appliedThemeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: textStyleNormal.copyWith(
                      color: appliedThemeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConstants.listItemText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios,
            color: MyColor.darkGrey.withValues(alpha: .5),
            size: 15,
          )
        ],
      ),
    );
  }
}

class ExpandableListSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  const ExpandableListSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,

  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(left: BorderSide(width: 5, color: MyColor.primary)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.0))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent, // optional
          ),
          child: ExpansionTile(
            splashColor: MyColor.primary.withValues(alpha: .1),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: EdgeInsets.zero,
            initiallyExpanded: initiallyExpanded,
            iconColor: MyColor.darkGrey,
            collapsedIconColor: MyColor.darkGrey,
            title: Text(
              title,
              style: textStyleNormal.copyWith(
                color: MyColor.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'poppins',
              ),
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}

class ListingCardsPdf extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;

  const ListingCardsPdf({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 12,top: 5),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            left: BorderSide(
              width: 5,
              color: MyColor.gold,
            ),
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 1.0))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTextPdf(text: title, color: MyColor.darkGrey),
            ),
            const Icon(
              Icons.picture_as_pdf_outlined,
              color: MyColor.gold,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ListText extends StatelessWidget {
  final String text;
  final Color color;

  const ListText({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.start,
        style: textStyleNormal.copyWith(
            overflow: TextOverflow.visible,
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: SizeConstants.listItemText));
  }
}

class ListTextPdf extends StatelessWidget {
  final String text;
  final Color color;

  const ListTextPdf({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.start,
        style: textStyleNormal.copyWith(
            overflow: TextOverflow.fade,
            color: MyColor.darkGrey,
            fontWeight: FontWeight.w500,
            fontSize: SizeConstants.PdflistItemText));
  }
}

class CardChipText extends StatelessWidget {
  final String text;
  final Color color;

  const CardChipText({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .2),
            borderRadius: const BorderRadius.only(
                topRight:Radius.circular(20),
                bottomRight:Radius.circular(20)
            ),
            border: Border(
                top: BorderSide(width: 1, color: color),
                right: BorderSide(width: 1, color: color),
                bottom: BorderSide(width: 1, color: color)
            )
        ),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),),
      ),
    );
  }
}
