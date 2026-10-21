import 'package:flutter/material.dart';

import '../extra/common_style.dart';

class HintText extends StatelessWidget {
  final String hint;

  const HintText({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      style: textStyleTextField.copyWith(fontSize: 12),
    );
  }
}
