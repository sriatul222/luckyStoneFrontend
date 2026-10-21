import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/checkNetwork/network_state.dart';
import 'package:luckystone/widgets/app_text.dart';
import '../extra/colors.dart';

class NoNetworkWidget extends StatelessWidget {
  final dynamic child;

  const NoNetworkWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) => Visibility(
                  visible: state is ConnectionFailure,
                  child: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: MyColor.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width / 1.3,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/no_internet_image.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const AppText(
                            label: "No Internet Connection",
                            isHeader: 'header',
                            underLine: false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const AppText(
                            // label: "You are not connected to the internet. Make sure Wi-Fi is on, Airplane Mode is Off and try again.",
                            label:
                                "You are not connected to Wi-Fi or your cellular network.",
                            isHeader: 'regular',
                            underLine: false,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
      ],
    );
  }
}
