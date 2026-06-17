import 'package:commute_calendar/feature/user/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {
  final SupabaseClient _supabase;

  const AuthDataSource(this._supabase);

  Future<UserModel> signUp(
    String email,
    String password,
    String name,
    String? department,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null) {
      throw Exception('회원가입에 실패했습니다. 잠시 후 다시 시도해주세요.');
    }

    final data = await _supabase
        .from('users')
        .insert({
          'id': userId,
          'email': email,
          'name': name,
          'department': ?department,
        })
        .select()
        .single();

    return UserModel.fromJson(data);
  }

  Future<UserModel> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null) {
      throw Exception('로그인에 실패했습니다. 이메일 또는 비밀번호를 확인해주세요.');
    }

    final data = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(data);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return null;

    final data = await _supabase
        .from('users')
        .select()
        .eq('id', currentUser.id)
        .single();
    return UserModel.fromJson(data);
  }

  Stream<(UserModel?, bool)> get authStateStream {
    return _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final isAutoLogin = data.event == AuthChangeEvent.initialSession;

      if ((data.event == AuthChangeEvent.signedIn || isAutoLogin) &&
          data.session?.user != null) {
        final user = await getCurrentUser();
        if (user == null) throw Exception('사용자 정보를 불러올 수 없습니다.');
        return (user, isAutoLogin);
      }
      return (null, false);
    });
  }
}
