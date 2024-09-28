import '../../../../core/usecases/usecase.dart';
import '../../data/repository/user_repositroy.dart';

class DeleteUserUseCase implements UseCase<void, String> {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<void> call(String userId) async {
    return await repository.deleteUser(userId);
  }
}
