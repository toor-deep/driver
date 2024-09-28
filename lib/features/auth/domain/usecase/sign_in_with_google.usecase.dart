import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class SignInWithGoogleUseCase {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase({required this.authRepository});

  Future<AuthUser> call() async {
    try {
      return await authRepository.signInWithGoogle();
    } on ArgumentError catch (error) {
      throw Exception('Invalid arguments: $error');
    } catch (error) {
      throw Exception('Sign-in with Google failed: $error');
    }
  }
}
