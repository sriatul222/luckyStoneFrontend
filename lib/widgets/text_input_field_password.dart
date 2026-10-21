import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/common_style.dart';

class TextInputFieldPassword extends StatelessWidget {
  final Function(String value) onChanged;
  final String? Function(String? value) validator;
  final TextInputAction textInputAction;
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);

  TextInputFieldPassword(
      {super.key,
      this.textInputAction = TextInputAction.done,
      required this.validator,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isPasswordVisible,
        builder: (BuildContext context, bool counterValue, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: MyColor.lightGray,
                selectionHandleColor: MyColor.lightGray,
              ),
            ),
            child: TextFormField(
              obscureText: isPasswordVisible.value,
              autovalidateMode: AutovalidateMode.disabled,
              style: textStyleTextFieldInput,
              cursorColor: MyColor.darkGrey,
              keyboardType: TextInputType.text,
              textInputAction: textInputAction,
              validator: validator,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                suffixIcon: GestureDetector(
                  child: Icon(
                    counterValue
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onTap: () => isPasswordVisible.value = !isPasswordVisible.value,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MyColor.primary,
                    width: 1.5,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MyColor.primary,
                    width: 1.5,
                  ),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: MyColor.primaryDark),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MyColor.primaryDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
