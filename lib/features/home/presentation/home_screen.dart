import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookShelf'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Search books',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _queryController,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  labelText: 'Title or author',
                  hintText: 'e.g. Harry Potter',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
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
              const SizedBox(height: 20),
              Text(
                'This screen currently covers Phase 2 requirements: form validation and API search entry point.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
