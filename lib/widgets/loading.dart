import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luckystone/extra/assets_constants.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/widgets/size_utils.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 102.fSize,
            width: 102.fSize,
            child: const CircularProgressIndicator(
              strokeWidth: 2.8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(MyColor.gold),
            ),
          ),
          SizedBox(
            height: 70.fSize,
            width: 70.fSize,
            child: SvgPicture.asset(ImageConstants.appLogo, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
