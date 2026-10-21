import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';

TextStyle textStyleBold = const TextStyle(
    decoration: TextDecoration.none,
    color: MyColor.darkGrey,
    fontWeight: FontWeight.w700,
    fontFamily: 'poppins',
    overflow: TextOverflow.ellipsis,
    fontSize: 12);

TextStyle textStyleNormal = const TextStyle(
    decoration: TextDecoration.none,
    color: MyColor.darkGrey,
    fontWeight: FontWeight.w600,
    fontFamily: 'poppins',
    overflow: TextOverflow.ellipsis,
    fontSize: 12);

TextStyle textStyleTextField = TextStyle(
    decoration: TextDecoration.none,
    color: MyColor.primaryGrey,
    fontSize: 12,
    fontFamily: 'poppins',
    overflow: TextOverflow.ellipsis,
);
TextStyle hintTextStyleTextField = TextStyle(
    decoration: TextDecoration.none,
    color: MyColor.primaryGrey,
    fontSize: 10,
    fontFamily: 'poppins',
    overflow: TextOverflow.ellipsis,
);
TextStyle textStyleTextFieldInput = const TextStyle(
    decoration: TextDecoration.none,
    color: MyColor.darkGrey,
    fontSize: 12,
    fontFamily: 'poppins',
    overflow: TextOverflow.ellipsis,
);
TextStyle pageHeadingStyle = const TextStyle(
  decoration: TextDecoration.none,
  fontFamily: 'poppins',
  fontSize: 20,
  color: MyColor.darkGrey,
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.ellipsis,
);
TextStyle cardIndexStyle = const TextStyle(
  decoration: TextDecoration.none,
  fontFamily: 'poppins',
  fontSize: 10,
  color: Colors.grey,
  fontWeight: FontWeight.w400,
  overflow: TextOverflow.ellipsis,
);

OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color: Colors.grey, width: 1),
);

OutlineInputBorder outlineInputBorderRed = const OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color: Colors.red, width: 1),
);
