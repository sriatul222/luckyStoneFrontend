import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsCubit/order_details_state.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(int orderId) : super(OrderDetailsState(orderId: orderId));

  Future<void> getOrder() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Order request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(
        AppURLs.orderDetailsApi(state.orderId),
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            details: OrderDetailsModel.fromJson(response.data['data']),
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

  /// Allowed only while PLACED / CONFIRMED; stock goes back on the backend.
  Future<void> cancelOrder() async {
    if (state.cancelStatus.isSubmissionInProgress) return;
    emit(state.copyWith(cancelStatus: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.postApi(
        AppURLs.cancelOrderApi(state.orderId),
        {},
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        FlutterToast.showToast(response.data['message'].toString());
        emit(
          state.copyWith(
            cancelStatus: FormzStatus.submissionSuccess,
            details: OrderDetailsModel.fromJson(response.data['data']),
          ),
        );
      } else {
        emit(state.copyWith(cancelStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          cancelStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
