import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../book_catalog/domain/entities/book_details.dart';
import '../../library/presentation/widgets/edit_library_entry_sheet.dart';
import 'providers/book_details_notifier.dart';

class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({
    super.key,
    required this.workId,
    this.fallbackTitle,
    this.coverUrl,
    this.authors,
    this.primarySubject,
  });

  final String workId;
  final String? fallbackTitle;
  final String? coverUrl;
  final String? authors;
  final String? primarySubject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookDetails> detailsState = ref.watch(
      bookDetailsNotifierProvider(workId),
    );
    final String appBarTitle =
        detailsState.value?.title ?? fallbackTitle ?? 'Book Details';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      floatingActionButton: detailsState.hasValue
          ? FloatingActionButton.extended(
              onPressed: () {
                final BookDetails details = detailsState.value!;
                showEditLibraryEntrySheet(
                  context: context,
                  ref: ref,
                  workId: workId,
                  title: details.title,
                  authors: authors ?? 'Unknown author',
                  coverUrl: details.coverUrl ?? coverUrl,
                  primarySubject: details.subjects.isNotEmpty
                      ? details.subjects.first
                      : primarySubject,
                );
              },
              icon: const Icon(Icons.library_add_outlined),
              label: const Text('Add to library'),
            )
          : null,
      body: _buildBody(context, ref, detailsState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BookDetails> detailsState,
  ) {
    return detailsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _humanizeError(error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref
                    .read(bookDetailsNotifierProvider(workId).notifier)
                    .reload(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (details) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        children: <Widget>[
          if (details.coverUrl != null && details.coverUrl!.isNotEmpty) ...<Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                details.coverUrl!,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            details.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            details.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (details.subjects.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            Text(
              'Subjects',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: details.subjects
                  .take(15)
                  .map((subject) => Chip(label: Text(subject)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _humanizeError(Object error) {
    final String value = error.toString();
    if (value.startsWith('Exception: ')) {
      return value.replaceFirst('Exception: ', '');
    }
    return value;
  }
}
