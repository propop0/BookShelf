import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/error/failure.dart';
import '../../book_catalog/domain/entities/book_details.dart';
import '../../book_catalog/domain/usecases/get_book_details_use_case.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({
    super.key,
    required this.workId,
    this.fallbackTitle,
  });

  final String workId;
  final String? fallbackTitle;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late final GetBookDetailsUseCase _getBookDetailsUseCase;
  bool _isLoading = true;
  String? _errorMessage;
  BookDetails? _details;

  @override
  void initState() {
    super.initState();
    _getBookDetailsUseCase = AppDependencies.getBookDetailsUseCase;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final String workId = widget.workId.trim();
    if (workId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Missing work id.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ({BookDetails? data, Failure? failure}) result = await _getBookDetailsUseCase(
      workId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _details = result.data;
      _errorMessage = result.failure?.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle = _details?.title ?? widget.fallbackTitle ?? 'Book Details';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
                onPressed: _loadDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final BookDetails details = _details!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (details.coverUrl != null) ...<Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              details.coverUrl!,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          details.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          details.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (details.subjects.isNotEmpty) ...<Widget>[
          const SizedBox(height: 20),
          Text(
            'Subjects',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: details.subjects
                .take(15)
                .map((subject) => Chip(label: Text(subject)))
                .toList(),
          ),
        ],
      ],
    );
  }
}
