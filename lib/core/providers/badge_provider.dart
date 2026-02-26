import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/badge_service.dart';

/// Badge Service provider
final badgeServiceProvider = Provider<BadgeService>((ref) {
  return BadgeService();
});

/// All badges provider
final allBadgesProvider = FutureProvider.autoDispose<List<Badge>>((ref) async {
  final badgeService = ref.watch(badgeServiceProvider);
  return await badgeService.getBadges();
});
