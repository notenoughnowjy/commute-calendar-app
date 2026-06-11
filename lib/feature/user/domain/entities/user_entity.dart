import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? department;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.department,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, department, createdAt];
}
