import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/common_style.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>>? items;

  const CustomDropdownWidget(
      {super.key,
      required this.onChanged,
      this.validator,
      required this.value,
      required this.hint,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: MyColor.lightGray,
          selectionHandleColor: MyColor.lightGray,
        ),
      ),
      child: DropdownButtonFormField<T>(
        style: textStyleTextFieldInput,
        dropdownColor: MyColor.white,
        elevation: 2,
        menuMaxHeight: 400,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        iconSize: 20,
        hint: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$hint',
            style: hintTextStyleTextField,
          ),
        ),
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          labelStyle: textStyleTextFieldInput,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          filled: true,
          counterText: "",
          fillColor: Colors.white,
          alignLabelWithHint: true,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorderRed,
          focusedErrorBorder: outlineInputBorderRed,
        ),
        value: value,
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: MyColor.primaryGrey,
        ),
        items: items,
        /*selectedItemBuilder: (_) {
          return items!.map((item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.child is Text
                    ? (item.child as Text).data ?? ""
                    : item.value.toString(),
                style: textStyleTextFieldInput,
              ),
            );
          }).toList();
        },
        items: items!.map((item) {
          return DropdownMenuItem<Object>(
            value: item.value,
            child: DefaultTextStyle(
              style: textStyleTextFieldInput,
              child: item.child,
            ),
          );
        }).toList(),*/
      ),
    );
  }
}
