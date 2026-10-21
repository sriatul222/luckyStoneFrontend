import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:luckystone/extra/common_style.dart';

class RichTextWidget extends StatelessWidget {
  final String text1, text2;
  final Function() onTap;

  const RichTextWidget(
      {super.key,
      required this.text1,
      required this.text2,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: textStyleNormal,
        children: <TextSpan>[
          TextSpan(text: text1),
          TextSpan(
              text: text2,
              style: textStyleBold,
              recognizer: TapGestureRecognizer()..onTap = onTap),
        ],
      ),
    );
  }
}
