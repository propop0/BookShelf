import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/search_query_display.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/fade_in_animation.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(SearchQueryDisplay.appBarTitle(l10n, widget.query)),
      ),
      body: _buildBody(context, state, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<List<Book>> state,
    AppLocalizations l10n,
  ) {
    return state.when(
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
                onPressed: () => ref.read(searchBooksNotifierProvider.notifier).retry(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      data: (List<Book> books) {
        if (books.isEmpty) {
          return Center(child: Text(l10n.noSearchResults));
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(searchBooksNotifierProvider.notifier).retry(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final Book book = books[index];
              final String heroTag = 'search_${book.workId}';
              return FadeInAnimation(
                delay: Duration(milliseconds: index * 50),
                child: BookCard(
                  heroTag: heroTag,
                  book: book,
                  onTap: () {
                    final String cover = book.coverUrl ?? '';
                    final String authors = book.authorNames.isEmpty
                        ? l10n.unknownAuthor
                        : book.authorsLabel;
                    context.push(
                      '/details?workId=${Uri.encodeQueryComponent(book.workId)}'
                      '&title=${Uri.encodeQueryComponent(book.title)}'
                      '&coverUrl=${Uri.encodeQueryComponent(cover)}'
                      '&authors=${Uri.encodeQueryComponent(authors)}'
                      '&heroTag=${Uri.encodeQueryComponent(heroTag)}',
                    );
                  },
                ),
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
