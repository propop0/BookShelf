import 'package:flutter/material.dart';

class PillSegmentedBar<T> extends StatelessWidget {
  const PillSegmentedBar({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  final List<T> items;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T item) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Brightness brightness = Theme.of(context).brightness;
    final double bubbleOpacity = brightness == Brightness.dark ? 0.22 : 0.18;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: items.map((T item) {
          final bool isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(item),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isSelected
                        ? colors.primary.withValues(alpha: bubbleOpacity)
                        : colors.surfaceContainerHighest.withValues(
                            alpha: brightness == Brightness.dark ? 0.35 : 0.7,
                          ),
                    border: Border.all(
                      color: colors.outline.withValues(
                        alpha: isSelected ? 0.28 : 0.12,
                      ),
                    ),
                  ),
                  child: Text(
                    labelBuilder(item),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected ? colors.primary : colors.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
