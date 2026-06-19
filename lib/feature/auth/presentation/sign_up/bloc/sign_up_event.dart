import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
    required this.email,
    required this.password,
    required this.name,
    this.department,
  });

  final String email;
  final String password;
  final String name;
  final String? department;

  @override
  List<Object?> get props => [email, password, name, department];
}
