import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../book_catalog/domain/entities/book_details.dart';
import '../../domain/entities/library_entry.dart';
import '../../domain/entities/reading_status.dart';
import '../../domain/utils/reading_progress.dart';
import '../../domain/utils/reading_progress_calculator.dart';
import '../providers/library_book_details_provider.dart';

class LibraryEntryTile extends ConsumerWidget {
  const LibraryEntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onViewDetails,
    required this.onDelete,
  });

  final LibraryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bool needsApiPageCount =
        entry.numberOfPages == null && entry.status == ReadingStatus.reading;

    final AsyncValue<BookDetails?> detailsState = needsApiPageCount
        ? ref.watch(libraryBookDetailsProvider(entry.workId))
        : const AsyncData<BookDetails?>(null);

    final int? resolvedTotalPages =
        entry.numberOfPages ?? detailsState.valueOrNull?.numberOfPages;

    final ReadingProgress? progress = ReadingProgressCalculator.forEntry(
      entry,
      resolvedTotalPages: resolvedTotalPages,
    );

    final bool isLoadingPageCount =
        needsApiPageCount && detailsState.isLoading && resolvedTotalPages == null;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Cover(url: entry.coverUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.authors,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.status.localizedLabel(l10n),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (entry.rating != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    l10n.ratingOutOfTen(entry.rating!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (progress != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    progress.localizedLabel(l10n),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: progress.value,
                    ),
                  ),
                ] else if (isLoadingPageCount &&
                    entry.currentPage != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    l10n.pageNumber(entry.currentPage!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  const LinearProgressIndicator(minHeight: 4),
                ] else if (entry.currentPage != null &&
                    entry.status == ReadingStatus.reading) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    l10n.pageNumber(entry.currentPage!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                tooltip: l10n.viewDetails,
                icon: const Icon(Icons.info_outline),
                onPressed: onViewDetails,
              ),
              IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final String? coverUrl = url;
    if (coverUrl == null || coverUrl.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.menu_book));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(coverUrl, width: 48, height: 64, fit: BoxFit.cover),
    );
  }
}
