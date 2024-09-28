
import '../../../auth/domain/entities/auth_user.dart';
import '../../data/data_source/user_data_source.dart';
import '../../data/repository/user_repositroy.dart';

class UserRepositoryImpl extends UserRepository {
  // Create a new user in Firestore
  Future<void> createUser(AuthUser authUser) async {
    try {
      await FireStoreUser.createUser(authUser);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Fetch user information from Firestore
  Future<AuthUser> getUserByEmail(String email) async {
    try {
      AuthUser user = await FireStoreUser.getUserByEmail(email);
      return user;
    } catch (e) {
      throw Exception('Failed to retrieve user: $e');
    }
  }

  // Update user information in Firestore
  Future<void> updateUser(AuthUser authUser) async {
    try {
      await FireStoreUser.updateUser(authUser);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  //delete user
  Future<void> deleteUser(String userId) async {
    try {
      await FireStoreUser.deleteUser(userId);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
