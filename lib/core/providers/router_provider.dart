import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/details/presentation/book_details_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/library/presentation/my_library_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_results_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/library',
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
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
          return BookDetailsScreen(workId: workId, fallbackTitle: title);
        },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const MyLibraryScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
