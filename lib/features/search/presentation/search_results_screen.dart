import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/error/failure.dart';
import '../../../core/widgets/book_card.dart';
import '../../book_catalog/domain/entities/book.dart';
import '../../book_catalog/domain/usecases/search_books_use_case.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  final String query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final SearchBooksUseCase _searchBooksUseCase;
  bool _isLoading = true;
  String? _errorMessage;
  List<Book> _books = <Book>[];

  @override
  void initState() {
    super.initState();
    _searchBooksUseCase = AppDependencies.searchBooksUseCase;
    _loadResults();
  }

  Future<void> _loadResults() async {
    final String query = widget.query.trim();
    if (query.isEmpty) {
      setState(() {
        _books = <Book>[];
        _isLoading = false;
        _errorMessage = 'Search query is empty.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ({List<Book>? data, Failure? failure}) result = await _searchBooksUseCase(
      query,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _books = result.data ?? <Book>[];
      _errorMessage = result.failure?.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results: "${widget.query}"'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loadResults,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_books.isEmpty) {
      return const Center(
        child: Text('No books found for this query.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _books.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final Book book = _books[index];
          return BookCard(
            book: book,
            onTap: () {
              context.push(
                '/details?workId=${Uri.encodeQueryComponent(book.workId)}&title=${Uri.encodeQueryComponent(book.title)}',
              );
            },
          );
        },
      ),
    );
  }
}
