import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/cartScreen/cartCubit/cart_state.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  Future<void> getCart() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Cart request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(AppURLs.cartApi);

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            cart: CartModel.fromJson(response.data['data']),
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

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    if (quantity < 1 || quantity > item.maxQuantity) return;
    await _changeCart(
      () => ApiHandler.handler.putApi(AppURLs.cartItemApi(item.id), {
        'quantity': quantity,
      }),
    );
  }

  Future<void> removeItem(CartItemModel item) async {
    await _changeCart(
      () => ApiHandler.handler.deleteApi(AppURLs.cartItemApi(item.id)),
    );
  }

  /// Update / remove both answer with the full cart.
  Future<void> _changeCart(Future<dynamic> Function() request) async {
    if (state.updateStatus.isSubmissionInProgress) return;
    emit(state.copyWith(updateStatus: FormzStatus.submissionInProgress));

    try {
      final response = await request();

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(
          state.copyWith(
            updateStatus: FormzStatus.submissionSuccess,
            cart: CartModel.fromJson(response.data['data']),
          ),
        );
      } else {
        emit(state.copyWith(updateStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          updateStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
