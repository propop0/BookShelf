import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/widgets/pill_segmented_bar.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/entities/library_entry.dart';
import '../domain/entities/reading_status.dart';
import 'providers/library_controller.dart';
import 'providers/library_providers.dart';
import 'widgets/edit_library_entry_sheet.dart';
import 'widgets/library_entry_tile.dart';

class MyLibraryScreen extends ConsumerStatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  ConsumerState<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends ConsumerState<MyLibraryScreen> {
  ReadingStatus _selectedStatus = ReadingStatus.reading;

  void _openBookDetails(LibraryEntry entry) {
    context.push(
      '/details?workId=${Uri.encodeQueryComponent(entry.workId)}'
      '&title=${Uri.encodeQueryComponent(entry.title)}'
      '&coverUrl=${Uri.encodeQueryComponent(entry.coverUrl ?? '')}'
      '&authors=${Uri.encodeQueryComponent(entry.authors)}'
      '${entry.primarySubject != null ? '&subject=${Uri.encodeQueryComponent(entry.primarySubject!)}' : ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stream = ref.watch(libraryRepositoryProvider).watchLibrary(
          ref.watch(currentUserProvider)!.uid,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myLibrary),
      ),
      body: StreamBuilder<List<LibraryEntry>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(l10n.libraryError('${snapshot.error}')),
            );
          }

          final List<LibraryEntry> entries = snapshot.data ?? <LibraryEntry>[];
          final List<LibraryEntry> filtered = entries
              .where((LibraryEntry entry) => entry.status == _selectedStatus)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: PillSegmentedBar<ReadingStatus>(
                  items: ReadingStatus.values,
                  selected: _selectedStatus,
                  onSelected: (ReadingStatus status) {
                    setState(() => _selectedStatus = status);
                  },
                  labelBuilder: (ReadingStatus status) =>
                      status.localizedLabel(l10n),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.libraryEmptyTab(
                            _selectedStatus.localizedLabel(l10n),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final LibraryEntry entry = filtered[index];
                          return LibraryEntryTile(
                            entry: entry,
                            onTap: () => showEditLibraryEntrySheet(
                              context: context,
                              ref: ref,
                              workId: entry.workId,
                              title: entry.title,
                              authors: entry.authors,
                              coverUrl: entry.coverUrl,
                              primarySubject: entry.primarySubject,
                              numberOfPages: entry.numberOfPages,
                              existing: entry,
                            ),
                            onViewDetails: () => _openBookDetails(entry),
                            onDelete: () => ref
                                .read(libraryControllerProvider.notifier)
                                .deleteEntry(entry.workId),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
