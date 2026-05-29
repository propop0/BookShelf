import 'dart:typed_data';

import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Stream<UserProfile?> watchProfile(String userId);

  Future<void> ensureProfile({
    required String userId,
    required String email,
  });

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
  });
}
