import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/checkNetwork/network_state.dart';
import 'package:luckystone/extra/assets_constants.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/text_constants.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final bool iconButton;
  final double? tittleSpace;
  final List<Widget>? widgets;

  const CommonAppBar(
      {super.key,
      required this.title,
      required this.appBar,
      required this.iconButton,
      this.widgets,
      required this.tittleSpace});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: tittleSpace,
        leading: iconButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: MyColor.primary),
                onPressed: () => Navigator.pop(context))
            : null,
        // Titles shrink to fit the space left by the action icons instead of
        // overflowing on narrow phones.
        title: title.isNotEmpty
            ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: MyColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ImageConstants.appLogo, width: 32, height: 32),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        TextConstants.appName,
                        maxLines: 1,
                        style: TextStyle(
                          color: MyColor.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        actions: widgets,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
