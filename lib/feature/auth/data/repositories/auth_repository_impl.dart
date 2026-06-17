import 'package:commute_calendar/feature/auth/data/datasources/auth_data_source.dart';
import 'package:commute_calendar/feature/auth/domain/repositories/i_auth_repository.dart';
import 'package:commute_calendar/feature/user/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> signUp(
    String email,
    String password,
    String name,
    String? department,
  ) async {
    try {
      return await _dataSource.signUp(email, password, name, department);
    } catch (e) {
      throw Exception('회원가입 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      return await _dataSource.signIn(email, password);
    } catch (e) {
      throw Exception('로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      throw Exception('로그아웃 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _dataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<(UserEntity?, bool)> get authStateStream => _dataSource.authStateStream;
}
