import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Elevated card with layered shadow — used instead of raw [Card] for consistency.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final Widget content = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );

    final Widget decorated = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        boxShadow: AppTheme.cardShadows(brightness),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(
                alpha: brightness == Brightness.dark ? 0.12 : 0.08,
              ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: content,
      ),
    );

    if (onTap == null) {
      return decorated;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: decorated,
      ),
    );
  }
}
