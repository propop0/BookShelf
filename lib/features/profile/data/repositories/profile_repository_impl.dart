import 'dart:typed_data';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Stream<UserProfile?> watchProfile(String userId) {
    return _dataSource.watchProfile(userId);
  }

  @override
  Future<void> ensureProfile({
    required String userId,
    required String email,
  }) {
    return _dataSource.ensureProfile(userId: userId, email: email);
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
  }) {
    return _dataSource.uploadAvatar(userId: userId, bytes: bytes);
  }
}
