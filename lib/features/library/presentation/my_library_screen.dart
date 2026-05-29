import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class _MyLibraryScreenState extends ConsumerState<MyLibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ReadingStatus.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    final stream = ref.watch(libraryRepositoryProvider).watchLibrary(
          ref.watch(currentUserProvider)!.uid,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: ReadingStatus.values
              .map((status) => Tab(text: status.label))
              .toList(),
        ),
      ),
      body: StreamBuilder<List<LibraryEntry>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<LibraryEntry> entries = snapshot.data ?? <LibraryEntry>[];

          return TabBarView(
            controller: _tabController,
            children: ReadingStatus.values.map((status) {
              final List<LibraryEntry> filtered = entries
                  .where((entry) => entry.status == status)
                  .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text('No books in "${status.label}".'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
