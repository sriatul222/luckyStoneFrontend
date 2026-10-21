import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersCubit/my_orders_state.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersModel/my_orders_model.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(const MyOrdersState());

  static const int _pageSize = 20;

  /// Loads page 1 (newest orders first).
  Future<void> getOrders() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Orders request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(
        AppURLs.ordersApi,
        queryParams: {'page': 1, 'page_size': _pageSize},
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        final pageData = OrderPageModel.fromJson(response.data['data']);
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            orders: pageData.items,
            page: pageData.page,
            totalPages: pageData.totalPages,
          ),
        );
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status.isSubmissionInProgress) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await ApiHandler.handler.getApi(
        AppURLs.ordersApi,
        queryParams: {'page': state.page + 1, 'page_size': _pageSize},
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        final pageData = OrderPageModel.fromJson(response.data['data']);
        emit(
          state.copyWith(
            orders: [...state.orders, ...pageData.items],
            page: pageData.page,
            totalPages: pageData.totalPages,
            isLoadingMore: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoadingMore: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, exceptionError: e.toString()));
    }
  }
}
