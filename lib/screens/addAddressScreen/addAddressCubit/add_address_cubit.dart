import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/common_validator.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/addAddressScreen/addAddressCubit/add_address_state.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  /// Pass [address] to edit it, or null to add a new one.
  AddAddressCubit(AddressModel? address)
    : super(
        address == null
            ? const AddAddressState()
            : AddAddressState(
                addressId: address.id,
                fullName: address.fullName,
                mobile: address.mobile,
                line1: address.line1,
                line2: address.line2,
                landmark: address.landmark,
                city: address.city,
                stateName: address.state,
                pincode: address.pincode,
                addressType: address.addressType,
                isDefault: address.isDefault,
              ),
      );

  String? fullNameChanged(String? value) {
    final fullName = (value ?? '').trim();
    emit(state.copyWith(fullName: fullName));
    return InputValidation.validateUserName(
      fullName,
      'Please enter a valid name',
    );
  }

  String? mobileChanged(String? value) {
    final mobile = (value ?? '').trim();
    emit(state.copyWith(mobile: mobile));
    return InputValidation.validateMobileNumber(
      mobile,
      'Please enter a valid 10 digit mobile number',
    );
  }

  String? line1Changed(String? value) {
    final line1 = (value ?? '').trim();
    emit(state.copyWith(line1: line1));
    return line1.length < 3
        ? 'Please enter house no. / building / street'
        : null;
  }

  // Optional fields
  void line2Changed(String value) => emit(state.copyWith(line2: value.trim()));

  void landmarkChanged(String value) =>
      emit(state.copyWith(landmark: value.trim()));

  String? cityChanged(String? value) {
    final city = (value ?? '').trim();
    emit(state.copyWith(city: city));
    return InputValidation.validateEmptyString(city, 'Please enter city');
  }

  String? stateNameChanged(String? value) {
    final stateName = (value ?? '').trim();
    emit(state.copyWith(stateName: stateName));
    return InputValidation.validateEmptyString(stateName, 'Please enter state');
  }

  String? pincodeChanged(String? value) {
    final pincode = (value ?? '').trim();
    emit(state.copyWith(pincode: pincode));
    return InputValidation.validatePincode(
      pincode,
      'Please enter a valid 6 digit pincode',
    );
  }

  void addressTypeChanged(String addressType) =>
      emit(state.copyWith(addressType: addressType));

  void isDefaultChanged(bool isDefault) =>
      emit(state.copyWith(isDefault: isDefault));

  Future<void> saveAddress() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Save address already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final body = AddressModel(
        id: state.addressId ?? 0,
        fullName: state.fullName,
        mobile: state.mobile,
        line1: state.line1,
        line2: state.line2,
        landmark: state.landmark,
        city: state.city,
        state: state.stateName,
        pincode: state.pincode,
        addressType: state.addressType,
        isDefault: state.isDefault,
      ).toJson();

      final response = state.isEdit
          ? await ApiHandler.handler.putApi(
              AppURLs.addressApi(state.addressId!),
              body,
            )
          : await ApiHandler.handler.postApi(AppURLs.addressesApi, body);

      if ((response?.statusCode == 200 || response?.statusCode == 201) &&
          response.data['success'] == true) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            savedAddress: AddressModel.fromJson(response.data['data']),
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
}
