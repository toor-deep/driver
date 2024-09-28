import '../../../auth/domain/entities/auth_user.dart';

abstract class UserRepository {
  Future<void> createUser(AuthUser authUser);
  Future<AuthUser?> getUserByEmail(String email);
  Future<void> updateUser(AuthUser authUser);
  Future<void> deleteUser(String userId);
}
