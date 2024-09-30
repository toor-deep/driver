
import 'package:equatable/equatable.dart';

import '../../../domain/entities/auth_user.dart';
import '../sign_in/sign_in_state.dart';

class SignUpState extends Equatable {
  final String? email;
  final String? password;
  final String? userName;
  final String? vehicleNumber;
  final EmailStatus emailStatus;
  final VehicleNoStatus vehicleNoStatus;
  final String? phone;
  final PasswordStatus passwordStatus;
  final bool isInputValid;
  final bool isLoading;
  final AuthUser? authUser;

  const SignUpState({
    this.email,
    this.password,
    this.phone,
    this.userName,
    this.vehicleNumber,
    this.isLoading=false,
    this.vehicleNoStatus=VehicleNoStatus.unknown,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.isInputValid=false,
    this.authUser
  });

  SignUpState copyWith({
    String? email,
   String? password,
    String? userName,
    String? phone,
    EmailStatus? emailStatus,
    VehicleNoStatus? vehicleNoStatus,
    PasswordStatus? passwordStatus,
    bool? isInputValid,
    bool? isLoading,
    String? vehicleNumber,
    AuthUser? authUser
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      isInputValid:  isInputValid ?? this.isInputValid,
      isLoading: isLoading ?? this.isLoading,
      authUser: authUser ?? this.authUser,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleNoStatus: vehicleNoStatus ?? this.vehicleNoStatus,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    emailStatus,
    passwordStatus,
    isInputValid,
    isLoading,
    phone,
    vehicleNumber,
    vehicleNoStatus
  ];
}