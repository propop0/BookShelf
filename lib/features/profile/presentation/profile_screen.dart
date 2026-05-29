import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers/theme_mode_notifier.dart';
import '../../auth/presentation/providers/auth_controller.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/entities/reading_stats.dart';
import '../domain/entities/user_profile.dart';
import 'providers/profile_controller.dart';
import 'providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) {
      return;
    }

    final XFile? file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file == null) {
      return;
    }

    final Uint8List bytes = await file.readAsBytes();
    await ref.read(profileControllerProvider.notifier).uploadAvatar(bytes);

    if (!context.mounted) {
      return;
    }

    final AsyncValue<void> uploadState = ref.read(profileControllerProvider);
    if (uploadState.hasError) {
      String errorMessage = uploadState.error.toString();
      if (errorMessage.contains('firebase_storage/object-not-found')) {
        errorMessage =
            'Error: Profile photo not found in storage. Please ensure Firebase Storage is enabled in the Firebase Console.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileControllerProvider);

    final user = ref.watch(currentUserProvider);
    final AsyncValue<UserProfile?> profileState = ref.watch(userProfileStreamProvider);
    final ReadingStats stats = ref.watch(readingStatsProvider);
    final ThemeMode themeMode = ref.watch(themeModeNotifierProvider);
    final bool isUploading = ref.watch(profileControllerProvider).isLoading;

    final String email = user?.email ?? '';
    final String? photoUrl = profileState.valueOrNull?.photoUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 52,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton.filled(
                    onPressed: isUploading
                        ? null
                        : () => _pickAndUploadAvatar(context, ref),
                    icon: isUploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _StatRow(label: 'Books read', value: '${stats.booksRead}'),
                  _StatRow(
                    label: 'Average rating',
                    value: stats.averageRating == null
                        ? '—'
                        : stats.averageRating!.toStringAsFixed(1),
                  ),
                  _StatRow(
                    label: 'Favorite genre',
                    value: stats.favoriteGenre ?? '—',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Settings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
              title: const Text('Theme'),
              subtitle: Text(_themeModeLabel(themeMode)),
              trailing: IconButton(
                tooltip: 'Toggle theme',
                onPressed: () =>
                    ref.read(themeModeNotifierProvider.notifier).toggleTheme(),
                icon: const Icon(Icons.swap_horiz_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
