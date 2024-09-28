
import '../../../auth/domain/entities/auth_user.dart';

class UserState {
  final AuthUser? authUser;
  final bool? isLoading;

  UserState({ this.authUser, this.isLoading});

  // Implementing the copyWith method
  UserState copyWith({
    AuthUser? authUser,
    bool? isLoading,
  }) {
    return UserState(
        authUser: authUser ?? this.authUser,
        isLoading: isLoading ?? this.isLoading);
  }
}
