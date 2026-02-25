import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userStats = ref.watch(userStatsProvider);
    final badges = ref.watch(allBadgesProvider);
    final dailyQuiz = ref.watch(dailyQuizProvider);

    return Material(
      color: AppColors.backgroundBeige,
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.02,
              child: AppNetworkImage(
                url: 'https://www.transparenttextures.com/patterns/islamic-art.png',
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(authState.user),
                  const SizedBox(height: 24),
                  _buildGreeting(authState.user),
                  const SizedBox(height: 16),
                  _buildProgressCard(authState.user, userStats),
                  const SizedBox(height: 24),
                  _buildBadgesSection(badges),
                  const SizedBox(height: 24),
                  _buildDailyChallenge(dailyQuiz),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCircleButton(Icons.grid_view_rounded),
            const SizedBox(width: 10),
            _buildCircleButton(Icons.wb_sunny_outlined, iconColor: const Color(0xFFBCA371)),
          ],
        ),
        if (user != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF144E2C),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: const Center(child: Text('👦', style: TextStyle(fontSize: 14))),
                ),
              ],
            ),
          ),
        _buildCircleButton(Icons.add),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor ?? AppColors.textDark, size: 20),
    );
  }

  Widget _buildGreeting(user) {
    final name = user?.name.split(' ').first ?? 'أحمد';
    return Text(
      'السلام عليكم، $name! 👋',
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildProgressCard(user, userStats) {
    final xp = user?.xp ?? 0;
    final level = user?.level ?? 1;
    final streak = user?.streak ?? 0;
    final xpForNextLevel = level * 500;
    final xpProgress = user?.levelProgress ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$xp / $xpForNextLevel',
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Text(
                    'سلسلة: $streak أيام',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 22),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpProgress,
              minHeight: 12,
              backgroundColor: const Color(0xFFF1F8E9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(AsyncValue<List<Badge>> badges) {
    return badges.when(
      data: (badgeList) {
        // Show first 4 badges or default ones if empty
        final displayBadges = badgeList.isEmpty ? [
          Badge(id: '1', name: 'برق', icon: '⚡'),
          Badge(id: '2', name: 'ملك', icon: '👑'),
          Badge(id: '3', name: 'نجم', icon: '⭐'),
          Badge(id: '4', name: 'فائز', icon: '🏆'),
        ] : badgeList.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الأوسمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Cairo'),
                ),
                Text(
                  '${badgeList.length} أوسمة',
                  style: const TextStyle(fontSize: 14, color: AppColors.textLight, fontFamily: 'Cairo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: displayBadges.map((badge) {
                  return Padding(
                    padding: const EdgeInsets.only(end: 12),
                    child: _buildBadgeItem(
                      badge.icon?.codeUnitAt(0) != null
                          ? IconData(int.parse(badge.icon?.substring(1, badge.icon!.length - 1) ?? '0xE005', radix: 16))
                          : Icons.flash_on,
                      badge.name,
                      const Color(0xFFF5F5F5),
                      const Color(0xFF94A3B8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
      loading: () => _buildBadgesSectionSkeleton(),
      error: (_, __) => _buildBadgesSectionSkeleton(),
    );
  }

  Widget _buildBadgesSectionSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأوسمة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(end: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: iconColor, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallenge(AsyncValue<Quiz?> dailyQuiz) {
    return dailyQuiz.when(
      data: (quiz) {
        if (quiz == null) {
          return _buildChallengeCard(
            context,
            tag: 'التحدي اليومي',
            title: 'اختبار أركان الإسلام',
            subtitle: 'أجب على 10 أسئلة واحصل على 50 نقطة',
            icon: Icons.track_changes,
            gradient: const [Color(0xFF10B981), Color(0xFF144E2C)],
            bgImageUrl: 'https://images.unsplash.com/photo-1584258708922-def95284de07?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpc2xhbWljJTIwbW9zcXVlJTIwcGF0dGVybnxlbnwxfHx8fDE3Njg3Mzg3ODl8MA&ixlib=rb-4.1.0&q=80&w=1080',
            onTap: () => context.push('/quiz'),
          );
        }

        return _buildChallengeCard(
          context,
          tag: 'التحدي اليومي',
          title: quiz.title,
          subtitle: quiz.description ?? 'أجب على ${quiz.questions.length} أسئلة واحصل على ${quiz.xp} نقطة',
          icon: Icons.track_changes,
          gradient: const [Color(0xFF10B981), Color(0xFF144E2C)],
          bgImageUrl: 'https://images.unsplash.com/photo-1584258708922-def95284de07?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpc2xhbWljJTIwbW9zcXVlJTIwcGF0dGVybnxlbnwxfHx8fDE3Njg3Mzg3ODl8MA&ixlib=rb-4.1.0&q=80&w=1080',
          onTap: () => context.push('/quiz/${quiz.id}'),
        );
      },
      loading: () => _buildChallengeCardSkeleton(),
      error: (_, __) => _buildChallengeCardSkeleton(),
    );
  }

  Widget _buildChallengeCardSkeleton() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    String? bgImageUrl,
    String buttonText = 'ابدأ الآن',
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(28),
        image: bgImageUrl != null ? DecorationImage(
          image: NetworkImage(bgImageUrl),
          fit: BoxFit.cover,
          opacity: 0.12,
        ) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                ),
                Icon(icon, color: Colors.white, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: gradient[1],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
