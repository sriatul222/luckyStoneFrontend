import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/extra/flutter_toast.dart';

abstract class NetworkState {}
// atul asl boolean check internet connection
bool checkInternetClick(context) {
  NetworkState stateOfNetwork = BlocProvider.of<NetworkBloc>(context).state;
  if (stateOfNetwork is ConnectionFailure) {
    FlutterToast.showToast("Please check internet connection");
    return false;
  }
  return true;
}

class ConnectionInitial extends NetworkState {}

class ConnectionSuccess extends NetworkState {}

class ConnectionFailure extends NetworkState {}
