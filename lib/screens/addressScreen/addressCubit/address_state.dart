import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';

class AddressState extends Equatable {
  const AddressState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.addresses = const [],
    this.deleteStatus = FormzStatus.pure,
  });

  final FormzStatus status;
  final String? exceptionError;
  final List<AddressModel> addresses;
  final FormzStatus deleteStatus;

  @override
  List<Object?> get props => [status, exceptionError, addresses, deleteStatus];

  AddressState copyWith({
    FormzStatus? status,
    String? exceptionError,
    List<AddressModel>? addresses,
    FormzStatus? deleteStatus,
  }) {
    return AddressState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      addresses: addresses ?? this.addresses,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }
}
