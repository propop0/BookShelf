import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/firestore_library_data_source.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/entities/library_entry.dart';
import '../../domain/repositories/library_repository.dart';

final firestoreLibraryDataSourceProvider = Provider<FirestoreLibraryDataSource>((ref) {
  return FirestoreLibraryDataSource(ref.watch(firestoreProvider));
});

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl(ref.watch(firestoreLibraryDataSourceProvider));
});

final libraryStreamProvider = StreamProvider<List<LibraryEntry>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const Stream<List<LibraryEntry>>.empty();
  }
  return ref.watch(libraryRepositoryProvider).watchLibrary(user.uid);
});
