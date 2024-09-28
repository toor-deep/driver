
import '../repository_impl/auth_repository_impl.dart';

class DeleteAccountUseCase {
  final AuthRepositoryImpl repository;

  DeleteAccountUseCase({required this.repository});

  Future<void> call() async {
    await repository.deleteAccount();
  }
}
