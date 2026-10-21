import 'package:fluttertoast/fluttertoast.dart';
import 'package:luckystone/extra/colors.dart';

class FlutterToast {
  static showToast(String msg, {int? duration, int? gravity}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColor.darkGrey,
        textColor: MyColor.white,
        fontSize: 16.0);
  }
}
