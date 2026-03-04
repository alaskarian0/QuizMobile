import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/learning_path/presentation/pages/learning_path_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/quiz/presentation/pages/lesson_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/results_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/categories/presentation/pages/category_path_page.dart';
import '../../features/reels/presentation/pages/reels_page.dart';
import '../../features/answer_history/presentation/pages/answer_history_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/library/presentation/pages/content_list_page.dart';
import 'scaffold_with_nav.dart';
import 'auth_notifier.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _pathNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'path');
  static final _libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
  static final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  /// The singleton auth notifier that the router listens to.
  static final authNotifier = AuthChangeNotifier();

  static final router = GoRouter(
    initialLocation: '/path',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isAuthenticated = authNotifier.isAuthenticated;
      final isOnLoginPage = state.matchedLocation == '/login';

      if (!isAuthenticated && !isOnLoginPage) {
        return '/login';
      }
      if (isAuthenticated && isOnLoginPage) {
        return '/path';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _pathNavigatorKey,
            routes: [
              GoRoute(
                path: '/path',
                builder: (context, state) => const LearningPathPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'home',
                    builder: (context, state) => const HomePage(),
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) => const CategoriesPage(),
                    routes: [
                      GoRoute(
                        path: 'path/:id',
                        builder: (context, state) {
                          final categoryId = state.pathParameters['id'] ?? '';
                          return CategoryPathPage(categoryId: categoryId);
                        },
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final categoryId = state.pathParameters['id'] ?? '';
                          return CategoriesPage();
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'lesson',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final lessonId = extra?['lessonId'] ?? 1;
                      return LessonPage(lessonId: lessonId);
                    },
                  ),
                  GoRoute(
                    path: 'quiz',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final quizId = extra?['quizId'] as String?;
                      return QuizPage(quizId: quizId);
                    },
                  ),
                  GoRoute(
                    path: 'results',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return ResultsPage(
                        score: extra?['score'] ?? 0,
                        total: extra?['total'] ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _libraryNavigatorKey,
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryPage(),
                routes: [
                  GoRoute(
                    path: 'content',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return ContentListPage(
                        title: extra?['title'] ?? 'المحتوى',
                        category: extra?['category'] ?? 'articles',
                        type: extra?['type'] as String?,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'reels',
                    builder: (context, state) => const ReelsPage(),
                  ),
                  GoRoute(
                    path: 'answer-history',
                    builder: (context, state) => const AnswerHistoryPage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'edit-profile',
                        builder: (context, state) => const EditProfilePage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
    ],
  );
}
