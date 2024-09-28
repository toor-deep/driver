import '../../../domain/entities/auth_user.dart';

class AuthState {
  final AuthUser? authUser;
  final bool? isLoading;

  const AuthState({this.authUser,this.isLoading});

  AuthState copyWith({
    AuthUser? authUser,
    bool? isLoading
  }) {
    return AuthState(
      authUser: authUser ?? this.authUser,
      isLoading: isLoading ?? this.isLoading
    );
  }
}
