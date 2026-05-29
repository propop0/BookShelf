import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signIn(
            email: email.trim(),
            password: password,
          );
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(
            email: email.trim(),
            password: password,
          );
    });
  }

  Future<void> sendPasswordReset({required String email}) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(
            email: email.trim(),
          );
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
