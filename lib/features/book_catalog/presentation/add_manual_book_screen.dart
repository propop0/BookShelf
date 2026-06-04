import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../library/domain/entities/library_entry.dart';
import '../../library/domain/entities/reading_status.dart';
import '../../library/presentation/providers/library_controller.dart';
import '../../library/presentation/providers/library_providers.dart';

class AddManualBookScreen extends ConsumerStatefulWidget {
  const AddManualBookScreen({super.key, this.initialTitle});

  final String? initialTitle;

  @override
  ConsumerState<AddManualBookScreen> createState() => _AddManualBookScreenState();
}

class _AddManualBookScreenState extends ConsumerState<AddManualBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final _authorsController = TextEditingController();
  final _pagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final userId = ref.read(currentUserProvider)?.uid;
    if (userId == null) return;

    final title = _titleController.text.trim();
    final authors = _authorsController.text.trim();
    final pages = int.tryParse(_pagesController.text.trim());

    final workId = 'manual_${const Uuid().v4()}';

    final entry = LibraryEntry(
      workId: workId,
      title: title,
      authors: authors,
      status: ReadingStatus.wantToRead,
      updatedAt: DateTime.now(),
      numberOfPages: pages,
    );

    await ref.read(libraryControllerProvider.notifier).upsertEntry(entry);

    if (mounted) {
      context.go('/library');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.addToLibrary)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = ref.watch(libraryControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addBookManuallyTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.titleLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? l10n.searchValidationEmpty : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorsController,
                decoration: InputDecoration(
                  labelText: l10n.authorsLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? l10n.searchValidationEmpty : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pagesController,
                decoration: InputDecoration(
                  labelText: l10n.pagesLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(l10n.addBookButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
