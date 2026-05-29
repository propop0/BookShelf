import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/book_card.dart';
import '../../book_catalog/domain/entities/book.dart';
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

  void _openBookDetails(Book book) {
    context.push(
      '/details?workId=${Uri.encodeQueryComponent(book.workId)}'
      '&title=${Uri.encodeQueryComponent(book.title)}'
      '&coverUrl=${Uri.encodeQueryComponent(book.coverUrl ?? '')}'
      '&authors=${Uri.encodeQueryComponent(book.authorsLabel)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Book>> trendingState = ref.watch(trendingBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookShelf'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(trendingBooksProvider);
          await ref.read(trendingBooksProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: <Widget>[
            Text(
              'Search books',
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
                    decoration: const InputDecoration(
                      labelText: 'Title or author',
                      hintText: 'e.g. Harry Potter',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      final String text = (value ?? '').trim();
                      if (text.isEmpty) {
                        return 'Please enter a search query.';
                      }
                      if (text.length < 2) {
                        return 'Use at least 2 characters.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submitSearch(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _submitSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Popular categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ApiConstants.categoryGridCrossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
              ),
              itemCount: popularBookCategories.length,
              itemBuilder: (BuildContext context, int index) {
                final BookCategory category = popularBookCategories[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openCategory(category),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            category.icon,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Text(
              'Trending today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _TrendingSection(
              trendingState: trendingState,
              onBookTap: _openBookDetails,
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
    return trendingState.when(
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, _) => Card(
        child: Padding(
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
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (List<Book> books) {
        if (books.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No trending books available right now.'),
            ),
          );
        }

        return SizedBox(
          height: 196,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final Book book = books[index];
              return SizedBox(
                width: 300,
                child: BookCard(
                  book: book,
                  onTap: () => onBookTap(book),
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
