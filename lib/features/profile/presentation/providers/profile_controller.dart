import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import 'profile_providers.dart';

final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>(
  ProfileController.new,
);

class ProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    final user = ref.watch(currentUserProvider);
    if (user != null) {
      await ref.read(profileRepositoryProvider).ensureProfile(
            userId: user.uid,
            email: user.email ?? '',
          );
    }
  }

  Future<void> uploadAvatar(Uint8List bytes) async {
    if (bytes.isEmpty) {
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('You must be signed in.');
    }

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).uploadAvatar(
            userId: user.uid,
            bytes: bytes,
          );
    });
  }
}
