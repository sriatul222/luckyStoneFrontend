import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.homeData = const HomeModel(),
    this.bannerIndex = 0,
  });

  final FormzStatus status;
  final String? exceptionError;
  final HomeModel homeData;
  final int bannerIndex;

  @override
  List<Object?> get props => [status, exceptionError, homeData, bannerIndex];

  HomeState copyWith({
    FormzStatus? status,
    String? exceptionError,
    HomeModel? homeData,
    int? bannerIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      homeData: homeData ?? this.homeData,
      bannerIndex: bannerIndex ?? this.bannerIndex,
    );
  }
}
