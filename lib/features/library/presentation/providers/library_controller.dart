import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/library_entry.dart';
import 'library_providers.dart';

final libraryControllerProvider =
    AutoDisposeAsyncNotifierProvider<LibraryController, void>(
  LibraryController.new,
);

class LibraryController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> upsertEntry(LibraryEntry entry) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('You must be signed in.');
    }

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryRepositoryProvider).upsertEntry(
            userId: user.uid,
            entry: entry,
          );
    });
  }

  Future<void> deleteEntry(String workId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('You must be signed in.');
    }

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryRepositoryProvider).deleteEntry(
            userId: user.uid,
            workId: workId,
          );
    });
  }
}
