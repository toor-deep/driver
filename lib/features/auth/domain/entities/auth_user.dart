import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoURL;
  final String? phone;
  final String? vehicleNumber;

  const AuthUser(
      {required this.id,
      required this.email,
      this.name,
      this.photoURL,
      this.phone,
      this.vehicleNumber});

  static const AuthUser empty = AuthUser(
      id: '', name: '', email: '', photoURL: '', phone: '', vehicleNumber: '');

  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [id, name, email, photoURL, phone];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'phone': phone,
      'vehicleNumber': vehicleNumber
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
        photoURL: data['photoURL'],
        phone: data['phone'],
        vehicleNumber: data['vehicleNumber'] ?? '');
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoURL,
    String? phone,
    String? vehicleNumber
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      phone: phone ?? this.phone,
      vehicleNumber:  vehicleNumber ?? this.vehicleNumber
    );
  }
}
