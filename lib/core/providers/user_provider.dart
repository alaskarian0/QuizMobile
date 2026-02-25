import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/user_service.dart';

/// User Service provider
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// User stats provider
final userStatsProvider = FutureProvider<UserStats?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getCurrentUserStats();
});

/// User rank provider
final userRankProvider = FutureProvider<Map<String, dynamic>?>( (ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getCurrentUserRank();
});

/// Leaderboard provider
final leaderboardProvider = FutureProvider.autoDispose<List<LeaderboardEntry>>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getLeaderboard();
});

/// Leaderboard with period provider
final leaderboardByPeriodProvider = FutureProvider.autoDispose.family<List<LeaderboardEntry>, String>((ref, period) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getLeaderboard(period: period);
});
