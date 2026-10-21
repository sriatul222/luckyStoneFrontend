import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/common_style.dart';

class TextInputFieldsEmail extends StatelessWidget {
  final Function(String value) onChanged;
  final dynamic onTap;
  final String? Function(String? value) validator;
  final TextInputAction textInputAction;
  final String? hintText;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final int maxLength;
  final int? maxLines;
  final bool? readOnly;
  final String? initialValue;


  const TextInputFieldsEmail(
      {super.key,
        this.textInputAction = TextInputAction.next,
        this.textInputType = TextInputType.emailAddress,
        this.textEditingController ,
        this.hintText ,
        this.readOnly ,
        this.onTap ,
        this.maxLines ,
        required this.validator,
        required this.onChanged,
        this.maxLength = 150,this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: MyColor.lightGray,
          selectionHandleColor: MyColor.lightGray,
        ),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        style: textStyleTextFieldInput,
        initialValue: initialValue,
        onTap: onTap,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        validator: validator,
        cursorColor: MyColor.darkGrey,
        onChanged: onChanged,
        maxLength: maxLength,
        readOnly: readOnly??false,
        controller: textEditingController,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          counterText: "",
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: textStyleTextField,
          alignLabelWithHint: true,
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
  }
}

class TextInputFields extends StatelessWidget {
  final Function(String value) onChanged;
  final dynamic onTap;
  final String? Function(String? value) validator;
  final TextInputAction textInputAction;
  final String? hintText;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final int maxLength;
  final int? maxLines;
  final bool? readOnly;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const TextInputFields({
    super.key,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.emailAddress,
    this.textEditingController,
    this.hintText,
    this.readOnly,
    this.onTap,
    this.maxLines,
    required this.validator,
    required this.onChanged,
    this.maxLength = 150,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: MyColor.lightGray,
          selectionHandleColor: MyColor.lightGray,
        ),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        style: textStyleTextFieldInput,
        initialValue: initialValue,
        onTap: onTap,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        validator: validator,
        cursorColor: MyColor.darkGrey,
        onChanged: onChanged,
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        controller: textEditingController,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          counterText: "",
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: hintTextStyleTextField,
          alignLabelWithHint: true,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorderRed,
          focusedErrorBorder: outlineInputBorderRed,

          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}