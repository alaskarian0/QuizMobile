import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/learning_path/presentation/pages/learning_path_page.dart';
import '../../features/quiz/presentation/pages/lesson_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/results_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/contest/presentation/pages/monthly_contest_page.dart';
import 'scaffold_with_nav.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _pathNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'path');
  static final _contestNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'contest');
  static final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
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
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
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
                    builder: (context, state) => const QuizPage(),
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
            navigatorKey: _pathNavigatorKey,
            routes: [
              GoRoute(
                path: '/learning-path',
                builder: (context, state) => const LearningPathPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _contestNavigatorKey,
            routes: [
              GoRoute(
                path: '/monthly-contest',
                builder: (context, state) => const MonthlyContestPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
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
