import 'package:flutter/material.dart';
import '../extra/colors.dart';

class AppText extends StatelessWidget {
  final String? label, fontFamily;
  final String? isHeader;
  final bool underLine;

  const AppText(
      {Key? key,
      this.label,
      this.isHeader,
      this.fontFamily,
      required this.underLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      style: getTextStyle(isHeader.toString()),
    );
  }

  TextStyle getTextStyle(String isHeader) {
    double? size;
    FontWeight? fontWeight;
    Color? preColor;

    //Define colors for all
    switch (isHeader) {
      case "header":
        size = 20;
        preColor = MyColor.black;
        fontWeight = FontWeight.w800;
        break;
      case "subHeader":
        size = 17;
        preColor = MyColor.hintColor;
        fontWeight = FontWeight.w700;
        break;
      case "body":
        size = 15;
        preColor = MyColor.hintColor;
        fontWeight = FontWeight.w600;
        break;
      case "regular":
        size = 13;
        preColor = MyColor.black;
        fontWeight = FontWeight.w500;
        break;
      case "footer":
        size = 12;
        preColor = MyColor.black;
        fontWeight = FontWeight.w400;
        break;
    }
    return TextStyle(
      color: preColor,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: size,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
