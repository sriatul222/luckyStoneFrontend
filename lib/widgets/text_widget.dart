import 'package:flutter/material.dart';
import 'package:luckystone/extra/common_style.dart';


class GreyText extends StatelessWidget {
  final String text;
  final String font;
  final double size;
  final Color color;
  final FontWeight weight;
  // null keeps textStyleNormal's ellipsis (single line); pass
  // TextOverflow.visible to let long text wrap onto more lines.
  final TextOverflow? overflow;

  const GreyText(
      {super.key,
      required this.text,
      required this.font,
      required this.size,
      required this.color,
      required this.weight,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.start,
        style: textStyleNormal.copyWith(
            color: color,
            fontFamily: font,
            fontWeight: weight,
            fontSize: size,
            overflow: overflow));
  }
}
class PageHeadingText extends StatelessWidget {
  final String text;
  const PageHeadingText(
      {super.key,
        required this.text,
        });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.start,
        style: pageHeadingStyle);
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color textColor;
  final Color color;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.textColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
