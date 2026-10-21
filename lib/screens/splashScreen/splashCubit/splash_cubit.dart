import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/screens/splashScreen/splashCubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initializeApp() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashCompleted());
  }
}
