import 'package:flutter/material.dart';
import 'package:luckystone/extra/colors.dart';

void popupDialog(BuildContext con, stringText) {
  showDialog(
      context: con,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text(stringText,
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
            actions: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: MyColor.black)),
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(con);
                },
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: MyColor.black)),
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.pop(con);
                  }),
            ],
          ));
}
