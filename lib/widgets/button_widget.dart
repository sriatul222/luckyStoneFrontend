import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonName;
  final dynamic onTap;
  // true = solid brand button for the main action (Add to Cart, Place Order)
  final bool filled;

  const ButtonWidget({
    super.key,
    required this.buttonName,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: filled ? MyColor.primary : MyColor.primaryBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: MyColor.primary),
        ),
        child: GreyText(
          text: buttonName,
          size: 15,
          color: filled ? MyColor.white : MyColor.primary,
          font: 'Poppins',
          weight: filled ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
