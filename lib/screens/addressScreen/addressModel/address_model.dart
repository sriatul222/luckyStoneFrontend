// Model for GET /api/v1/addresses. The order's shipping_address uses the
// same keys (without id), so order details parse it with this model too.

import 'package:equatable/equatable.dart';
import 'package:luckystone/extra/json_parser.dart';

class AddressModel extends Equatable {
  final int id;
  final String fullName;
  final String mobile;
  final String line1;
  final String line2;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String addressType; // home / work / other
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.line1,
    this.line2 = '',
    this.landmark = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.addressType = 'home',
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: parseInt(json['id']),
      fullName: parseString(json['full_name']),
      mobile: parseString(json['mobile']),
      line1: parseString(json['line1']),
      line2: parseString(json['line2']),
      landmark: parseString(json['landmark']),
      city: parseString(json['city']),
      state: parseString(json['state']),
      pincode: parseString(json['pincode']),
      addressType: parseString(json['address_type'], defaultValue: 'home'),
      isDefault: json['is_default'] == true,
    );
  }

  /// Body for POST / PUT /api/v1/addresses.
  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'mobile': mobile,
    'line1': line1,
    'line2': line2,
    'landmark': landmark,
    'city': city,
    'state': state,
    'pincode': pincode,
    'address_type': addressType,
    'is_default': isDefault,
  };

  String get fullAddress => [
    line1,
    line2,
    if (landmark.isNotEmpty) 'Near $landmark',
    '$city, $state - $pincode',
  ].where((part) => part.trim().isNotEmpty).join(', ');

  @override
  List<Object?> get props => [
    id,
    fullName,
    mobile,
    line1,
    line2,
    landmark,
    city,
    state,
    pincode,
    addressType,
    isDefault,
  ];
}
