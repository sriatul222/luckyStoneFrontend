import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/productDetailsScreen/productDetailsModel/product_details_model.dart';

class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    required this.productId,
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.details,
    this.reviews = const [],
    this.imageIndex = 0,
    this.selectedSize = '',
    this.cartStatus = FormzStatus.pure,
    this.buyNow = false,
    this.isWishlisted = false,
    this.wishlistStatus = FormzStatus.pure,
  });

  final int productId;
  final FormzStatus status; // loading the product
  final String? exceptionError;
  final ProductDetailsModel? details;
  final List<ReviewModel> reviews;
  final int imageIndex;
  final String selectedSize;
  final FormzStatus cartStatus; // add to cart request
  final bool buyNow; // open the cart after adding
  final bool isWishlisted;
  final FormzStatus wishlistStatus;

  @override
  List<Object?> get props => [
    productId,
    status,
    exceptionError,
    details,
    reviews,
    imageIndex,
    selectedSize,
    cartStatus,
    buyNow,
    isWishlisted,
    wishlistStatus,
  ];

  ProductDetailsState copyWith({
    FormzStatus? status,
    String? exceptionError,
    ProductDetailsModel? details,
    List<ReviewModel>? reviews,
    int? imageIndex,
    String? selectedSize,
    FormzStatus? cartStatus,
    bool? buyNow,
    bool? isWishlisted,
    FormzStatus? wishlistStatus,
  }) {
    return ProductDetailsState(
      productId: productId,
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      details: details ?? this.details,
      reviews: reviews ?? this.reviews,
      imageIndex: imageIndex ?? this.imageIndex,
      selectedSize: selectedSize ?? this.selectedSize,
      cartStatus: cartStatus ?? this.cartStatus,
      buyNow: buyNow ?? this.buyNow,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
    );
  }
}
