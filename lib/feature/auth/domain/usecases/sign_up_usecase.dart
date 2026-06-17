import 'package:commute_calendar/feature/auth/domain/repositories/i_auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final IAuthRepository _repository;

  Future<void> call(
    String email,
    String password,
    String name,
    String? department,
  ) {
    return _repository.signUp(email, password, name, department);
  }
}
