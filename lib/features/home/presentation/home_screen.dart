import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/utils/search_query_display.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/category_pill.dart';
import '../../../core/widgets/fade_in_animation.dart';
import '../../book_catalog/domain/entities/book.dart';
import '../../search/presentation/providers/search_providers.dart';
import '../domain/constants/book_categories.dart';
import 'providers/trending_books_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_restoreLastSearchQuery);
  }

  Future<void> _restoreLastSearchQuery() async {
    final String? query =
        await ref.read(searchCacheRepositoryProvider).getLastSearchQuery();
    if (!mounted || query == null || SearchQueryDisplay.isSubjectQuery(query)) {
      return;
    }
    _queryController.text = query;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final String query = _queryController.text.trim();
    context.push('/search?q=${Uri.encodeQueryComponent(query)}');
  }

  void _openCategory(BookCategory category) {
    context.push('/search?q=${Uri.encodeQueryComponent(category.searchQuery)}');
  }

  void _openBookDetails(Book book, String heroTag) {
    context.push(
      '/details?workId=${Uri.encodeQueryComponent(book.workId)}'
      '&title=${Uri.encodeQueryComponent(book.title)}'
      '&coverUrl=${Uri.encodeQueryComponent(book.coverUrl ?? '')}'
      '&authors=${Uri.encodeQueryComponent(book.authorsLabel)}'
      '&heroTag=${Uri.encodeQueryComponent(heroTag)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Book>> trendingState = ref.watch(trendingBooksProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(trendingBooksProvider);
          await ref.read(trendingBooksProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
          children: <Widget>[
            Text(
              l10n.searchBooks,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _queryController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelText: l10n.searchFieldLabel,
                      hintText: l10n.searchHint,
                    ),
                    validator: (String? value) {
                      final String text = (value ?? '').trim();
                      if (text.isEmpty) {
                        return l10n.searchValidationEmpty;
                      }
                      if (text.length < 2) {
                        return l10n.searchValidationMinLength;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submitSearch(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _submitSearch,
                    icon: const Icon(Icons.search),
                    label: Text(l10n.searchButton),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Text(
              l10n.popularCategories,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ApiConstants.categoryGridCrossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              itemCount: popularBookCategories.length,
              itemBuilder: (BuildContext context, int index) {
                final BookCategory category = popularBookCategories[index];
                return FadeInAnimation(
                  delay: Duration(milliseconds: index * 40),
                  child: CategoryPill(
                    label: category.localizedLabel(l10n),
                    icon: category.icon,
                    onTap: () => _openCategory(category),
                  ),
                );
              },
            ),
            const SizedBox(height: 36),
            Text(
              l10n.trendingToday,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _TrendingSection(
              trendingState: trendingState,
              onBookTap: (book) => _openBookDetails(book, 'trending_${book.workId}'),
              onRetry: () => ref.invalidate(trendingBooksProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({
    required this.trendingState,
    required this.onBookTap,
    required this.onRetry,
  });

  final AsyncValue<List<Book>> trendingState;
  final ValueChanged<Book> onBookTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return trendingState.when(
      loading: () => const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, _) => AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _humanizeError(error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (List<Book> books) {
        if (books.isEmpty) {
          return AppCard(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.noTrendingBooks),
          );
        }

        return SizedBox(
          height: 140,
          child: ListView.separated(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(bottom: 8),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final Book book = books[index];
              final String heroTag = 'trending_${book.workId}';
              return FadeInAnimation(
                delay: Duration(milliseconds: index * 50),
                child: SizedBox(
                  width: 300,
                  child: BookCard(
                    heroTag: heroTag,
                    book: book,
                    onTap: () => onBookTap(book),
                  ),
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
