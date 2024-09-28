

import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../data/repository/user_repositroy.dart';

class CreateUserUseCase implements UseCase<void, AuthUser> {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<void> call(AuthUser authUser) async {
    return await repository.createUser(authUser);
  }
}
