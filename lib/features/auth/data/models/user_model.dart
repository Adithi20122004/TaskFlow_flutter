import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:gig_tasks/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    required super.createdAt,
  });

  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        createdAt: createdAt,
      );
}