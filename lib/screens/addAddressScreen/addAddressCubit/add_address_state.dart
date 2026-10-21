import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';

class AddAddressState extends Equatable {
  const AddAddressState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.addressId,
    this.fullName = '',
    this.mobile = '',
    this.line1 = '',
    this.line2 = '',
    this.landmark = '',
    this.city = '',
    this.stateName = '',
    this.pincode = '',
    this.addressType = 'home',
    this.isDefault = false,
    this.savedAddress,
  });

  final FormzStatus status;
  final String? exceptionError;
  final int? addressId; // set when editing
  final String fullName;
  final String mobile;
  final String line1;
  final String line2;
  final String landmark;
  final String city;
  final String stateName;
  final String pincode;
  final String addressType;
  final bool isDefault;
  final AddressModel? savedAddress; // API response after save

  bool get isEdit => addressId != null;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    addressId,
    fullName,
    mobile,
    line1,
    line2,
    landmark,
    city,
    stateName,
    pincode,
    addressType,
    isDefault,
    savedAddress,
  ];

  AddAddressState copyWith({
    FormzStatus? status,
    String? exceptionError,
    String? fullName,
    String? mobile,
    String? line1,
    String? line2,
    String? landmark,
    String? city,
    String? stateName,
    String? pincode,
    String? addressType,
    bool? isDefault,
    AddressModel? savedAddress,
  }) {
    return AddAddressState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      addressId: addressId,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      stateName: stateName ?? this.stateName,
      pincode: pincode ?? this.pincode,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      savedAddress: savedAddress ?? this.savedAddress,
    );
  }
}
