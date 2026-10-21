import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/screens/productListScreen/productListCubit/product_list_state.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(ProductListFilter filter)
    : super(ProductListState(filter: filter));

  /// Loads page 1 for the current filter (also used by pull-to-refresh).
  Future<void> getProducts() async {
    final filter = state.filter;
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        isLoadingMore: false,
      ),
    );

    try {
      final response = await ApiHandler.handler.getApi(
        AppURLs.productsApi,
        queryParams: filter.toQuery(page: 1),
      );
      // The user changed sort / filter / search while this was loading
      if (filter != state.filter) return;

      if (response?.statusCode == 200 && response.data['success'] == true) {
        final pageData = ProductPageModel.fromJson(response.data['data']);
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            products: pageData.items,
            page: pageData.page,
            totalPages: pageData.totalPages,
            total: pageData.total,
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

  /// Next page, called when the grid is scrolled near the end.
  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status.isSubmissionInProgress) {
      return;
    }

    final filter = state.filter;
    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await ApiHandler.handler.getApi(
        AppURLs.productsApi,
        queryParams: filter.toQuery(page: state.page + 1),
      );
      if (filter != state.filter) return;

      if (response?.statusCode == 200 && response.data['success'] == true) {
        final pageData = ProductPageModel.fromJson(response.data['data']);
        emit(
          state.copyWith(
            products: [...state.products, ...pageData.items],
            page: pageData.page,
            totalPages: pageData.totalPages,
            total: pageData.total,
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

  void search(String q) {
    if (q.trim() == state.filter.q) return;
    emit(state.copyWith(filter: state.filter.copyWith(q: q.trim())));
    getProducts();
  }

  void changeSort(String sort) {
    if (sort == state.filter.sort) return;
    emit(state.copyWith(filter: state.filter.copyWith(sort: sort)));
    getProducts();
  }

  void applyFilter(ProductListFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
    getProducts();
  }
}
