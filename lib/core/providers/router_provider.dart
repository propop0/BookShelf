import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/details/presentation/book_details_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/library/presentation/my_library_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_results_screen.dart';
import '../presentation/main_shell.dart';
import '../router/go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      final bool isLoading = authState.isLoading;
      final bool isLoggedIn = authState.valueOrNull != null;
      final String location = state.matchedLocation;

      const Set<String> publicRoutes = <String>{
        '/login',
        '/register',
        '/forgot-password',
      };

      if (isLoading) {
        return null;
      }

      if (!isLoggedIn && !publicRoutes.contains(location)) {
        return '/login';
      }

      if (isLoggedIn && publicRoutes.contains(location)) {
        return '/';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/library',
                name: 'library',
                builder: (context, state) => const MyLibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final String query = state.uri.queryParameters['q'] ?? '';
          return SearchResultsScreen(query: query);
        },
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        builder: (context, state) {
          final String workId = state.uri.queryParameters['workId'] ?? '';
          final String? title = state.uri.queryParameters['title'];
          final String? coverUrl = state.uri.queryParameters['coverUrl'];
          final String? authors = state.uri.queryParameters['authors'];
          final String? subject = state.uri.queryParameters['subject'];
          final String? heroTag = state.uri.queryParameters['heroTag'];
          return BookDetailsScreen(
            workId: workId,
            fallbackTitle: title,
            coverUrl: coverUrl,
            authors: authors,
            primarySubject: subject,
            heroTag: heroTag,
          );
        },
      ),
    ],
  );
});
