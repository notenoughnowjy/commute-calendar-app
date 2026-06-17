import 'package:commute_calendar/feature/user/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity> signUp(
    String email,
    String password,
    String name,
    String? department,
  );
  Future<UserEntity> signIn(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<(UserEntity?, bool)> get authStateStream;
}
