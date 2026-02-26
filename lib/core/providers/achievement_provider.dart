import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/achievement_service.dart';

/// Achievement Service provider
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService();
});

/// All achievements provider
final allAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getAchievements();
});

/// Daily achievements provider
final dailyAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getAchievements(type: 'DAILY');
});

/// Weekly achievements provider
final weeklyAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getAchievements(type: 'WEEKLY');
});

/// Monthly achievements provider
final monthlyAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getAchievements(type: 'MONTHLY');
});

/// My achievements provider (with progress)
final myAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getMyAchievements();
});

/// Achievement stats provider
final achievementStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final achievementService = ref.watch(achievementServiceProvider);
  return await achievementService.getMyStats();
});
