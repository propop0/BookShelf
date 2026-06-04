import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // Added kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_notifier.dart';
import '../../../core/providers/theme_mode_notifier.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/presentation/providers/auth_controller.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/entities/reading_stats.dart';
import '../domain/entities/user_profile.dart';
import 'providers/profile_controller.dart';
import 'providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.camera),
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
        errorMessage = l10n.storagePhotoNotFound;
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
    final Locale locale = ref.watch(localeNotifierProvider);
    final bool isUploading = ref.watch(profileControllerProvider).isLoading;
    final l10n = context.l10n;

    final String email = user?.email ?? '';
    final String? photoUrl = profileState.valueOrNull?.photoUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.signOut,
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: (photoUrl != null && photoUrl.isNotEmpty)
                      ? ClipOval(
                          child: Image.network(
                            photoUrl,
                            width: 104,
                            height: 104,
                            fit: BoxFit.cover,
                            // Use HTML renderer on web to bypass some CORS issues if enabled
                            // or just provide a fallback.
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 48);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        )
                      : const Icon(Icons.person, size: 48),
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
          Text(l10n.statistics, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                _StatRow(label: l10n.booksRead, value: '${stats.booksRead}'),
                _StatRow(
                  label: l10n.averageRating,
                  value: stats.averageRating == null
                      ? l10n.notAvailable
                      : stats.averageRating!.toStringAsFixed(1),
                ),
                _StatRow(
                  label: l10n.favoriteGenre,
                  value: _formatGenre(l10n, stats.favoriteGenre),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.settings, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(l10n.language, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                _LanguageSwitcher(
                  selected: locale,
                  onSelected: (Locale value) =>
                      ref.read(localeNotifierProvider.notifier).setLocale(value),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
                          Text(
                            _themeModeLabel(l10n, themeMode),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.toggleTheme,
                      onPressed: () => ref
                          .read(themeModeNotifierProvider.notifier)
                          .toggleTheme(),
                      icon: const Icon(Icons.swap_horiz_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatGenre(AppLocalizations l10n, String? genre) {
    if (genre == null || genre.isEmpty || genre == '—') {
      return l10n.notAvailable;
    }
    if (genre.contains(':') || genre.length > 20) {
      return l10n.genreVarious;
    }
    return genre;
  }

  String _themeModeLabel(AppLocalizations l10n, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
      ThemeMode.system => l10n.themeSystem,
    };
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher({
    required this.selected,
    required this.onSelected,
  });

  final Locale selected;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Brightness brightness = Theme.of(context).brightness;
    final double bubbleOpacity = brightness == Brightness.dark ? 0.22 : 0.18;

    final List<(Locale, String)> options = <(Locale, String)>[
      (const Locale('en'), l10n.languageEnglish),
      (const Locale('uk'), l10n.languageUkrainian),
      (const Locale('pl'), l10n.languagePolish),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map(((Locale, String) option) {
        final bool isSelected = selected.languageCode == option.$1.languageCode;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(option.$1),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isSelected
                    ? colors.primary.withValues(alpha: bubbleOpacity)
                    : colors.surfaceContainerHighest.withValues(
                        alpha: brightness == Brightness.dark ? 0.35 : 0.75,
                      ),
                border: Border.all(
                  color: colors.outline.withValues(
                    alpha: isSelected ? 0.3 : 0.12,
                  ),
                ),
              ),
              child: Text(
                option.$2,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected ? colors.primary : colors.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
