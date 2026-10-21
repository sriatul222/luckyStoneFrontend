import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsCubit/product_details_state.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsModel/product_details_model.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(int productId)
    : super(ProductDetailsState(productId: productId));

  Future<void> getDetails() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Product request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      // Reviews are a separate API; load both together
      final List<dynamic> responses = await Future.wait<dynamic>([
        ApiHandler.handler.getApi(AppURLs.productDetailsApi(state.productId)),
        ApiHandler.handler.getApi(AppURLs.productReviewsApi(state.productId)),
      ]);
      final detailsResponse = responses[0];
      final reviewsResponse = responses[1];

      if (detailsResponse?.statusCode == 200 &&
          detailsResponse.data['success'] == true) {
        final details = ProductDetailsModel.fromJson(
          detailsResponse.data['data'],
        );
        final reviews = reviewsResponse?.statusCode == 200
            ? parseList(
                parseMap(reviewsResponse.data['data'])['items'],
                ReviewModel.fromJson,
              )
            : <ReviewModel>[];
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            details: details,
            reviews: reviews,
            isWishlisted: details.isWishlisted,
            // Only one size: pick it for the user
            selectedSize: details.sizes.length == 1
                ? details.sizes.first
                : null,
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

  void changeImage(int index) {
    emit(state.copyWith(imageIndex: index));
  }

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }

  /// Rings / bangles need a size before they can go in the cart.
  bool isSizeSelected() {
    final details = state.details;
    if (details != null && details.needsSize && state.selectedSize.isEmpty) {
      FlutterToast.showToast('Please select a size');
      return false;
    }
    return true;
  }

  /// Adds 1 piece in the selected size. [buyNow] opens the cart afterwards.
  Future<void> addToCart({bool buyNow = false}) async {
    if (state.details == null ||
        state.cartStatus.isSubmissionInProgress ||
        !isSizeSelected()) {
      return;
    }

    emit(
      state.copyWith(
        cartStatus: FormzStatus.submissionInProgress,
        buyNow: buyNow,
      ),
    );

    try {
      final response = await ApiHandler.handler.postApi(AppURLs.cartItemsApi, {
        'product_id': state.productId,
        'quantity': 1,
        'size': state.selectedSize,
      });

      if (response?.statusCode == 201 && response.data['success'] == true) {
        emit(state.copyWith(cartStatus: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(cartStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          cartStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }

  /// Adds or removes the product; the heart changes at once and goes back
  /// if the API fails.
  Future<void> toggleWishlist() async {
    if (state.wishlistStatus.isSubmissionInProgress) return;
    final add = !state.isWishlisted;

    emit(
      state.copyWith(
        wishlistStatus: FormzStatus.submissionInProgress,
        isWishlisted: add,
      ),
    );

    try {
      final response = add
          ? await ApiHandler.handler.postApi(AppURLs.wishlistApi, {
              'product_id': state.productId,
            })
          : await ApiHandler.handler.deleteApi(
              AppURLs.wishlistItemApi(state.productId),
            );

      if ((response?.statusCode == 200 || response?.statusCode == 201) &&
          response.data['success'] == true) {
        FlutterToast.showToast(response.data['message'].toString());
        emit(state.copyWith(wishlistStatus: FormzStatus.submissionSuccess));
      } else {
        emit(
          state.copyWith(
            wishlistStatus: FormzStatus.submissionFailure,
            isWishlisted: !add,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          wishlistStatus: FormzStatus.submissionFailure,
          isWishlisted: !add,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
