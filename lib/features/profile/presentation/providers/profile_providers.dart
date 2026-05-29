import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../library/domain/entities/library_entry.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/utils/reading_stats_calculator.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(
    firestore: ref.watch(firestoreProvider),
    storage: ref.watch(firebaseStorageProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});

final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const Stream<UserProfile?>.empty();
  }
  return ref.watch(profileRepositoryProvider).watchProfile(user.uid);
});

final readingStatsProvider = Provider<ReadingStats>((ref) {
  final AsyncValue<List<LibraryEntry>> library = ref.watch(libraryStreamProvider);
  return library.maybeWhen(
    data: ReadingStatsCalculator.fromEntries,
    orElse: () => const ReadingStats(booksRead: 0),
  );
});
