import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/widgets/text_widget.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: GreyText(
          text: "We couldn't find any data",
          size: 18,
          color: MyColor.darkGrey,
          font: 'poppins',
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
