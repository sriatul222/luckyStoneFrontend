import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';
import 'package:luckystone/screens/wishlistScreen/wishlistCubit/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  Future<void> getWishlist() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Wishlist request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(AppURLs.wishlistApi);

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            products: parseList(response.data['data'], ProductModel.fromJson),
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

  /// DELETE answers with the updated wishlist.
  Future<void> remove(int productId) async {
    if (state.removeStatus.isSubmissionInProgress) return;
    emit(state.copyWith(removeStatus: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.deleteApi(
        AppURLs.wishlistItemApi(productId),
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        FlutterToast.showToast(response.data['message'].toString());
        emit(
          state.copyWith(
            removeStatus: FormzStatus.submissionSuccess,
            products: parseList(response.data['data'], ProductModel.fromJson),
          ),
        );
      } else {
        emit(state.copyWith(removeStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          removeStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
