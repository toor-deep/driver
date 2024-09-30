import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photoURL;
  final String? phone;
  final String? vehicleNumber;
  final bool? isOnline;
  final String? role;

  const AuthUser(
      {required this.id,
      this.email,
      this.name,
      this.photoURL,
      this.phone,
      this.isOnline,
      this.role,
      this.vehicleNumber});

  static const AuthUser empty = AuthUser(
      id: '',
      name: '',
      email: '',
      photoURL: '',
      phone: '',
      role: '',
      vehicleNumber: '',
      isOnline: false);

  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [id, name, email, photoURL, phone, isOnline, role];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'phone': phone,
      'vehicleNumber': vehicleNumber,
      'isOnline': isOnline,
      'role': role
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception('Data is null');
    }
    return AuthUser(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        role: data['role'],
        photoURL: data['photoURL'],
        phone: data['phone'],
        isOnline: data['isOnline'],
        vehicleNumber: data['vehicleNumber'] ?? '');
  }

  AuthUser copyWith(
      {String? id,
      String? email,
      String? name,
      String? photoURL,
      String? phone,
      String? vehicleNumber,
      String? role,
      bool? isOnline}) {
    return AuthUser(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        photoURL: photoURL ?? this.photoURL,
        phone: phone ?? this.phone,
        isOnline: isOnline ?? this.isOnline,
        role: role ?? this.role,
        vehicleNumber: vehicleNumber ?? this.vehicleNumber);
  }
}
