import 'package:flutter/material.dart';

import '../../features/book_catalog/domain/entities/book.dart';
import '../l10n/l10n_extensions.dart';
import 'app_card.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.heroTag,
  });

  final Book book;
  final VoidCallback? onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String authors = book.authorNames.isEmpty
        ? l10n.unknownAuthor
        : book.authorsLabel;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: <Widget>[
          _BookCover(url: book.coverUrl, heroTag: heroTag),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  authors,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (book.firstPublishYear != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    l10n.firstPublished(book.firstPublishYear!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.url, this.heroTag});

  final String? url;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final String? coverUrl = url;
    if (coverUrl == null || coverUrl.isEmpty) {
      return _PlaceholderCover(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    }

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        coverUrl,
        width: 72,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _PlaceholderCover(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          );
        },
      ),
    );

    if (heroTag != null) {
      image = Hero(
        tag: heroTag!,
        child: image,
      );
    }

    return image;
  }
}

class _PlaceholderCover extends StatelessWidget {
  const _PlaceholderCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 96,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
