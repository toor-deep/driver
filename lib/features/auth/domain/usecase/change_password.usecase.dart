
import '../repository_impl/auth_repository_impl.dart';

class ChangePasswordUseCase {
  final AuthRepositoryImpl repository;

  ChangePasswordUseCase({required this.repository});

  Future<void> call(String newPassword) async {
    await repository.changePassword(newPassword);
  }
}
