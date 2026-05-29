import 'package:flutter/material.dart';

import '../../domain/entities/library_entry.dart';
import '../../domain/entities/reading_status.dart';
import '../../domain/utils/reading_progress.dart';
import '../../domain/utils/reading_progress_calculator.dart';

class LibraryEntryTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ReadingProgress? progress = ReadingProgressCalculator.forEntry(entry);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
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
                      entry.status.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (entry.rating != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        'Rating: ${entry.rating}/10',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (progress != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        progress.label,
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
                    ] else if (entry.currentPage != null &&
                        entry.status == ReadingStatus.reading) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        'Page ${entry.currentPage}',
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
                    tooltip: 'View details',
                    icon: const Icon(Icons.info_outline),
                    onPressed: onViewDetails,
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
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
      borderRadius: BorderRadius.circular(8),
      child: Image.network(coverUrl, width: 48, height: 64, fit: BoxFit.cover),
    );
  }
}
