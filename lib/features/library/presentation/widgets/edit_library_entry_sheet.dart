import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/entities/library_entry.dart';
import '../../domain/entities/reading_status.dart';
import '../../domain/utils/reading_page_validator.dart';
import '../providers/library_controller.dart';

Future<void> showEditLibraryEntrySheet({
  required BuildContext context,
  required WidgetRef ref,
  required String workId,
  required String title,
  required String authors,
  String? coverUrl,
  String? primarySubject,
  int? numberOfPages,
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
        numberOfPages: numberOfPages,
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
    this.numberOfPages,
    this.existing,
  });

  final String workId;
  final String title;
  final String authors;
  final String? coverUrl;
  final String? primarySubject;
  final int? numberOfPages;
  final LibraryEntry? existing;

  @override
  ConsumerState<_EditLibraryEntrySheet> createState() => _EditLibraryEntrySheetState();
}

class _EditLibraryEntrySheetState extends ConsumerState<_EditLibraryEntrySheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ReadingStatus _status;
  late final TextEditingController _reviewController;
  late final TextEditingController _pageController;
  late final TextEditingController _totalPagesController;
  late final TextEditingController _ratingController;
  int? _fetchedTotalPages;

  @override
  void initState() {
    super.initState();
    _status = widget.existing?.status ?? ReadingStatus.wantToRead;
    _reviewController = TextEditingController(text: widget.existing?.review ?? '');
    _pageController = TextEditingController(
      text: widget.existing?.currentPage?.toString() ?? '',
    );
    _totalPagesController = TextEditingController(
      text: (widget.existing?.numberOfPages ?? widget.numberOfPages)?.toString() ?? '',
    );
    _ratingController = TextEditingController(
      text: widget.existing?.rating?.toString() ?? '',
    );

    _pageController.addListener(_revalidatePageFields);
    _totalPagesController.addListener(_revalidatePageFields);

    if (_totalPagesController.text.trim().isEmpty) {
      Future<void>.microtask(_prefillTotalPagesFromApi);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_revalidatePageFields);
    _totalPagesController.removeListener(_revalidatePageFields);
    _reviewController.dispose();
    _pageController.dispose();
    _totalPagesController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _revalidatePageFields() {
    _formKey.currentState?.validate();
  }

  Future<void> _prefillTotalPagesFromApi() async {
    final result = await ref.read(getBookDetailsUseCaseProvider)(widget.workId);
    final int? pages = result.data?.numberOfPages;
    if (!mounted || pages == null || pages <= 0) {
      return;
    }

    _fetchedTotalPages = pages;
    if (_totalPagesController.text.trim().isEmpty) {
      setState(() {
        _totalPagesController.text = pages.toString();
      });
    }
  }

  int? _effectiveCurrentPage() {
    final String text = _pageController.text.trim();
    if (text.isEmpty) {
      return null;
    }
    return int.tryParse(text);
  }

  int? _effectiveTotalPages() {
    final String text = _totalPagesController.text.trim();
    if (text.isNotEmpty) {
      return int.tryParse(text);
    }
    return widget.existing?.numberOfPages ??
        widget.numberOfPages ??
        _fetchedTotalPages;
  }

  int? _resolveTotalPagesForSave() {
    final String text = _totalPagesController.text.trim();
    if (text.isNotEmpty) {
      return int.tryParse(text);
    }
    return widget.existing?.numberOfPages ??
        widget.numberOfPages ??
        _fetchedTotalPages;
  }

  void _openBookDetails() {
    Navigator.of(context).pop();
    context.push(
      '/details?workId=${Uri.encodeQueryComponent(widget.workId)}'
      '&title=${Uri.encodeQueryComponent(widget.title)}'
      '&coverUrl=${Uri.encodeQueryComponent(widget.coverUrl ?? '')}'
      '&authors=${Uri.encodeQueryComponent(widget.authors)}'
      '${widget.primarySubject != null ? '&subject=${Uri.encodeQueryComponent(widget.primarySubject!)}' : ''}',
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int? rating = int.tryParse(_ratingController.text.trim());
    final int? page = int.tryParse(_pageController.text.trim());
    final int? totalPages = _resolveTotalPagesForSave();

    final LibraryEntry entry = LibraryEntry(
      workId: widget.workId,
      title: widget.title,
      authors: widget.authors,
      status: _status,
      coverUrl: widget.coverUrl,
      rating: rating,
      review: _reviewController.text.trim().isEmpty ? null : _reviewController.text.trim(),
      currentPage: page,
      numberOfPages: totalPages,
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
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 110,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.existing == null ? l10n.addToLibrarySheet : l10n.editLibraryEntry,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _openBookDetails,
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.viewDetails),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ReadingStatus>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: l10n.statusLabel,
                ),
                items: ReadingStatus.values
                    .map(
                      (status) => DropdownMenuItem<ReadingStatus>(
                        value: status,
                        child: Text(status.localizedLabel(l10n)),
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
                decoration: InputDecoration(
                  labelText: l10n.ratingLabel,
                ),
                validator: (String? value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return null;
                  }
                  final int? rating = int.tryParse(text);
                  if (rating == null || rating < 1 || rating > 10) {
                    return l10n.validationRating;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.currentPageLabel,
                ),
                validator: (String? value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return null;
                  }
                  final int? page = int.tryParse(text);
                  if (page == null || page < 1) {
                    return l10n.validationPage;
                  }
                  final int? total = _effectiveTotalPages();
                  if (ReadingPageValidator.currentExceedsTotal(
                    currentPage: page,
                    totalPages: total,
                  )) {
                    return l10n.validationCurrentExceedsTotal(total!);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalPagesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.totalPagesLabel,
                ),
                validator: (String? value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return null;
                  }
                  final int? pages = int.tryParse(text);
                  if (pages == null || pages < 1) {
                    return l10n.validationTotalPages;
                  }
                  final int? current = _effectiveCurrentPage();
                  if (ReadingPageValidator.totalBelowCurrent(
                    currentPage: current,
                    totalPages: pages,
                  )) {
                    return l10n.validationTotalBelowCurrent(current!);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.reviewLabel,
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
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
