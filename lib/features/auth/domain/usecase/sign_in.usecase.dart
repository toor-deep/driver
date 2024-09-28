
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';


class SignInUseCase {

  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<AuthUser> call(SignInParams params) async {
    try {
      return await authRepository.signIn(
        email: params.email,
        password: params.password
      );
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
