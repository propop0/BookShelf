import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../widgets/glass/floating_glass_navigation_bar.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: FloatingGlassNavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          destinations: <FloatingGlassNavDestination>[
            FloatingGlassNavDestination(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: l10n.navHome,
            ),
            FloatingGlassNavDestination(
              icon: Icons.collections_bookmark_outlined,
              selectedIcon: Icons.collections_bookmark_rounded,
              label: l10n.navLibrary,
            ),
            FloatingGlassNavDestination(
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
