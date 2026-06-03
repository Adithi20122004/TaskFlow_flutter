import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
  });

  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, displayName, createdAt];
}