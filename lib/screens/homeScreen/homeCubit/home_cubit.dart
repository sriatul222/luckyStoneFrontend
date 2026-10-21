import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/homeScreen/homeCubit/home_state.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> getHomeData() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Home request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(AppURLs.homeApi);

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          homeData: HomeModel.fromJson(response.data['data']),
        ));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        exceptionError: e.toString(),
      ));
    }
  }

  void changeBanner(int index) {
    emit(state.copyWith(bannerIndex: index));
  }
}
