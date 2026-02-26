import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/quiz.dart';
import '../../../../core/models/user.dart' as user_models;
import '../../../../core/models/category.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Gradient colors for different categories
  final List<List<Color>> _categoryGradients = [
    [const Color(0xFF10B981), const Color(0xFF144E2C)], // Green
    [const Color(0xFF8B5CF6), const Color(0xFF6366F1)], // Purple
    [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Orange
    [const Color(0xFF2196F3), const Color(0xFF1E40AF)], // Blue
    [const Color(0xFFEC4899), const Color(0xFFBE185D)], // Pink
    [const Color(0xFF14B8A6), const Color(0xFF0F766E)], // Teal
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userStats = ref.watch(userStatsProvider);
    final badges = ref.watch(allBadgesProvider);
    final dailyQuiz = ref.watch(dailyQuizProvider);
    final categoriesState = ref.watch(categoriesStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
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
                  _buildCategoriesSection(categoriesState),
                  const SizedBox(height: 24),
                  _buildDailyChallenge(dailyQuiz),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = ref.watch(themeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCircleButton(Icons.grid_view_rounded),
            const SizedBox(width: 10),
            _buildCircleButton(
              isDarkMode ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined,
              iconColor: isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFFBCA371),
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
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

  Widget _buildCircleButton(IconData icon, {Color? iconColor, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? colorScheme.onSurface, size: 20),
      ),
    );
  }

  Widget _buildGreeting(user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final name = user?.name.split(' ').first ?? 'أحمد';
    return Text(
      'السلام عليكم، $name! 👋',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildProgressCard(user, userStats) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final xp = user?.xp ?? 0;
    final level = user?.level ?? 1;
    final streak = user?.streak ?? 0;
    final xpForNextLevel = level * 500;
    final xpProgress = user?.levelProgress ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
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

  Widget _buildBadgesSection(AsyncValue<List<user_models.Badge>> badges) {
    final theme = Theme.of(context);

    return badges.when(
      data: (badgeList) {
        final displayBadges = badgeList.isEmpty ? [
          user_models.Badge(id: '1', name: 'برق', icon: '⚡'),
          user_models.Badge(id: '2', name: 'ملك', icon: '👑'),
          user_models.Badge(id: '3', name: 'نجم', icon: '⭐'),
          user_models.Badge(id: '4', name: 'فائز', icon: '🏆'),
        ] : badgeList.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الأوسمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontFamily: 'Cairo'),
                ),
                Text(
                  '${badgeList.length} أوسمة',
                  style: TextStyle(fontSize: 14, color: AppColors.textLight, fontFamily: 'Cairo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: displayBadges.map((badge) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildBadgeItem(
                      badge.icon != null && badge.icon!.isNotEmpty
                          ? Icons.emoji_emotions
                          : Icons.flash_on,
                      badge.name,
                      const Color(0xFFF5F5F5),
                      const Color(0xFF94A3B8),
                      badge.icon ?? '',
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأوسمة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontFamily: 'Cairo'),
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
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, Color bgColor, Color iconColor, [String? iconEmoji]) {
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
            child: iconEmoji != null && iconEmoji.isNotEmpty
                ? Text(
                    iconEmoji,
                    style: const TextStyle(fontSize: 24),
                  )
                : Icon(icon, color: iconColor, size: 24),
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

  Widget _buildCategoriesSection(CategoriesState categoriesState) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الدورات التعليمية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 16),
        categoriesState.isLoading
            ? _buildCategoriesSkeleton()
            : categoriesState.error != null
                ? _buildCategoriesError(categoriesState.error!)
                : categoriesState.categories.isEmpty
                    ? _buildEmptyCategories()
                    : _buildCategoriesList(categoriesState.categories),
      ],
    );
  }

  Widget _buildCategoriesList(List<Category> categories) {
    // Show all categories as large cards like the daily challenge
    return Column(
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final gradient = _categoryGradients[index % _categoryGradients.length];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCategoryChallengeCard(
            context,
            category: category,
            tag: 'الدورة',
            title: category.name,
            subtitle: '${category.questionCount} سؤال • اختبر معلوماتك',
            icon: category.icon != null && category.icon!.isNotEmpty
                ? Icons.emoji_events
                : Icons.menu_book,
            gradient: gradient,
            iconEmoji: category.icon,
            onTap: () => context.push('/categories/${category.id}'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChallengeCard(
    BuildContext context, {
    required Category category,
    required String tag,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    String? iconEmoji,
    required VoidCallback onTap,
  }) {
    final color = _parseColor(category.color ?? '#10B981');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon/Emoji on the left
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: iconEmoji != null && iconEmoji.isNotEmpty
                      ? Text(
                          iconEmoji,
                          style: const TextStyle(fontSize: 40),
                        )
                      : Icon(icon, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(width: 20),
              // Content in the middle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              // Play button on the right
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: gradient[1],
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSkeleton() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }

  Widget _buildCategoriesError(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(categoriesStateProvider.notifier).refresh(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategories() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد دورات حالياً',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF10B981);
    }
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
