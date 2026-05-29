import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/library_entry.dart';
import '../../domain/entities/reading_status.dart';
import '../providers/library_controller.dart';

Future<void> showEditLibraryEntrySheet({
  required BuildContext context,
  required WidgetRef ref,
  required String workId,
  required String title,
  required String authors,
  String? coverUrl,
  String? primarySubject,
  LibraryEntry? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _EditLibraryEntrySheet(
        workId: workId,
        title: title,
        authors: authors,
        coverUrl: coverUrl,
        primarySubject: primarySubject,
        existing: existing,
      );
    },
  );
}

class _EditLibraryEntrySheet extends ConsumerStatefulWidget {
  const _EditLibraryEntrySheet({
    required this.workId,
    required this.title,
    required this.authors,
    this.coverUrl,
    this.primarySubject,
    this.existing,
  });

  final String workId;
  final String title;
  final String authors;
  final String? coverUrl;
  final String? primarySubject;
  final LibraryEntry? existing;

  @override
  ConsumerState<_EditLibraryEntrySheet> createState() => _EditLibraryEntrySheetState();
}

class _EditLibraryEntrySheetState extends ConsumerState<_EditLibraryEntrySheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ReadingStatus _status;
  late final TextEditingController _reviewController;
  late final TextEditingController _pageController;
  late final TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();
    _status = widget.existing?.status ?? ReadingStatus.wantToRead;
    _reviewController = TextEditingController(text: widget.existing?.review ?? '');
    _pageController = TextEditingController(
      text: widget.existing?.currentPage?.toString() ?? '',
    );
    _ratingController = TextEditingController(
      text: widget.existing?.rating?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _pageController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int? rating = int.tryParse(_ratingController.text.trim());
    final int? page = int.tryParse(_pageController.text.trim());

    final LibraryEntry entry = LibraryEntry(
      workId: widget.workId,
      title: widget.title,
      authors: widget.authors,
      status: _status,
      coverUrl: widget.coverUrl,
      rating: rating,
      review: _reviewController.text.trim().isEmpty ? null : _reviewController.text.trim(),
      currentPage: page,
      primarySubject: widget.primarySubject ?? widget.existing?.primarySubject,
    );

    await ref.read(libraryControllerProvider.notifier).upsertEntry(entry);

    if (!mounted) {
      return;
    }

    final AsyncValue<void> state = ref.read(libraryControllerProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error.toString())),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(libraryControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.existing == null ? 'Add to library' : 'Edit library entry',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ReadingStatus>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ReadingStatus.values
                    .map(
                      (status) => DropdownMenuItem<ReadingStatus>(
                        value: status,
                        child: Text(status.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rating (1-10)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return null;
                  }
                  final int? rating = int.tryParse(text);
                  if (rating == null || rating < 1 || rating > 10) {
                    return 'Enter a rating from 1 to 10.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Current page',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: isLoading ? null : _save,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
