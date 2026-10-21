import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/addressScreen/addressCubit/address_state.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(const AddressState());

  Future<void> getAddresses() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Address request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.getApi(AppURLs.addressesApi);

      if (response?.statusCode == 200 && response.data['success'] == true) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            addresses: parseList(response.data['data'], AddressModel.fromJson),
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

  Future<void> deleteAddress(AddressModel address) async {
    if (state.deleteStatus.isSubmissionInProgress) return;
    emit(state.copyWith(deleteStatus: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.deleteApi(
        AppURLs.addressApi(address.id),
      );

      if (response?.statusCode == 200 && response.data['success'] == true) {
        FlutterToast.showToast(response.data['message'].toString());
        emit(
          state.copyWith(
            deleteStatus: FormzStatus.submissionSuccess,
            addresses: state.addresses
                .where((item) => item.id != address.id)
                .toList(),
          ),
        );
      } else {
        emit(state.copyWith(deleteStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          deleteStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
