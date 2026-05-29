import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/book_card.dart';
import '../../book_catalog/domain/entities/book.dart';
import 'providers/search_books_notifier.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  final String query;

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(searchBooksNotifierProvider.notifier).search(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Book>> state = ref.watch(searchBooksNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Results: "${widget.query}"'),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, AsyncValue<List<Book>> state) {
    return state.when(
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
                onPressed: () => ref.read(searchBooksNotifierProvider.notifier).retry(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (books) {
        if (books.isEmpty) {
          return const Center(
            child: Text('No books found for this query.'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(searchBooksNotifierProvider.notifier).retry(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final Book book = books[index];
              return BookCard(
                book: book,
                onTap: () {
                  final String cover = book.coverUrl ?? '';
                  final String authors = book.authorsLabel;
                  context.push(
                    '/details?workId=${Uri.encodeQueryComponent(book.workId)}'
                    '&title=${Uri.encodeQueryComponent(book.title)}'
                    '&coverUrl=${Uri.encodeQueryComponent(cover)}'
                    '&authors=${Uri.encodeQueryComponent(authors)}',
                  );
                },
              );
            },
          ),
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
