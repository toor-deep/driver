import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class UserUseCase {
  final AuthRepository authRepository;

  UserUseCase({required this.authRepository});

  Stream<AuthUser> call() {
    return authRepository.authUser;
  }
}
