import 'package:flutter/material.dart';

import '../../domain/entities/library_entry.dart';

class LibraryEntryTile extends StatelessWidget {
  const LibraryEntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  final LibraryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: _Cover(url: entry.coverUrl),
        title: Text(entry.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(entry.authors, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(entry.status.label),
            if (entry.rating != null) Text('Rating: ${entry.rating}/10'),
            if (entry.currentPage != null) Text('Page: ${entry.currentPage}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
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
