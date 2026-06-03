import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_card.dart';
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
    this.heroTag,
  });

  final String workId;
  final String? fallbackTitle;
  final String? coverUrl;
  final String? authors;
  final String? primarySubject;
  final String? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final AsyncValue<BookDetails> detailsState = ref.watch(
      bookDetailsNotifierProvider(workId),
    );
    final String appBarTitle =
        detailsState.value?.title ?? fallbackTitle ?? l10n.bookDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      floatingActionButton: detailsState.hasValue
          ? FloatingActionButton.extended(
              onPressed: () {
                final BookDetails details = detailsState.value!;
                final String authorLabel = details.authorNames.isEmpty
                    ? l10n.unknownAuthor
                    : details.authorsLabel;
                showEditLibraryEntrySheet(
                  context: context,
                  ref: ref,
                  workId: workId,
                  title: details.title,
                  authors: authorLabel,
                  coverUrl: details.coverUrl ?? coverUrl,
                  primarySubject: details.subjects.isNotEmpty
                      ? details.subjects.first
                      : primarySubject,
                  numberOfPages: details.numberOfPages,
                );
              },
              icon: const Icon(Icons.library_add_outlined),
              label: Text(l10n.addToLibrary),
            )
          : null,
      body: _buildBody(context, ref, detailsState, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BookDetails> detailsState,
    AppLocalizations l10n,
  ) {
    final String effectiveHeroTag = heroTag ?? workId;

    return detailsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, _) => Center(
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
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      data: (BookDetails details) {
        final String authorLabel = details.authorNames.isEmpty
            ? l10n.unknownAuthor
            : details.authorsLabel;

        final String? effectiveCoverUrl = details.coverUrl ?? coverUrl;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          children: <Widget>[
            if (effectiveCoverUrl != null && effectiveCoverUrl.isNotEmpty) ...<Widget>[
              Hero(
                tag: effectiveHeroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    effectiveCoverUrl,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.notAvailable, // Or a specific "Image load failed" string if available
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              details.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: <Widget>[
                  _MetadataRow(
                    icon: Icons.person_outline,
                    label: l10n.author,
                    value: authorLabel,
                  ),
                  const Divider(height: 1, indent: 56),
                  _MetadataRow(
                    icon: Icons.calendar_today_outlined,
                    label: l10n.published,
                    value: details.publishYear?.toString() ?? l10n.notAvailable,
                  ),
                  const Divider(height: 1, indent: 56),
                  _MetadataRow(
                    icon: Icons.menu_book_outlined,
                    label: l10n.pages,
                    value: details.numberOfPages?.toString() ?? l10n.notAvailable,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              details.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (details.subjects.isNotEmpty) ...<Widget>[
              const SizedBox(height: 20),
              Text(
                l10n.subjects,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: details.subjects
                    .take(15)
                    .map((String subject) => Chip(label: Text(subject)))
                    .toList(),
              ),
            ],
          ],
        );
      },
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

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
