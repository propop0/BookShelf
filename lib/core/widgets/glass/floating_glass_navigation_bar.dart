import 'package:flutter/material.dart';

import 'glass_surface.dart';

class FloatingGlassNavDestination {
  const FloatingGlassNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class FloatingGlassNavigationBar extends StatelessWidget {
  const FloatingGlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<FloatingGlassNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Brightness brightness = Theme.of(context).brightness;
    final double bubbleOpacity = brightness == Brightness.dark ? 0.22 : 0.16;

    return GlassSurface(
      borderRadius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: List<Widget>.generate(destinations.length, (int index) {
          final bool selected = index == selectedIndex;
          final FloatingGlassNavDestination destination = destinations[index];

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onDestinationSelected(index),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: selected
                        ? colors.primary.withValues(alpha: bubbleOpacity)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        selected ? destination.selectedIcon : destination.icon,
                        color: selected ? colors.primary : colors.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
