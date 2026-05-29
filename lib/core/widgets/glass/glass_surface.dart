import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = EdgeInsets.zero,
    this.blurSigma = 18,
    this.showShadow = true,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double blurSigma;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: theme.colorScheme.surface.withValues(
              alpha: AppTheme.glassFillOpacity(brightness),
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(
                alpha: AppTheme.glassBorderOpacity(brightness),
              ),
            ),
            boxShadow: showShadow ? AppTheme.cardShadows(brightness) : null,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
