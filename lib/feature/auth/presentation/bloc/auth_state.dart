import 'package:commute_calendar/feature/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user, {this.isAutoLogin = false});

  final UserEntity user;
  final bool isAutoLogin;

  @override
  List<Object?> get props => [user, isAutoLogin];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
