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
    [const Color(0xFF10B981), const Color(0xFF0F4C36)], // Deep Emerald
    [const Color(0xFF7C3AED), const Color(0xFF4C1D95)], // Deep Purple
    [const Color(0xFFF59E0B), const Color(0xFF92400E)], // Deep Amber
    [const Color(0xFF2563EB), const Color(0xFF1E3A8A)], // Deep Blue
    [const Color(0xFFDB2777), const Color(0xFF831843)], // Deep Pink
    [const Color(0xFF0D9488), const Color(0xFF134E4A)], // Deep Teal
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
      child: SafeArea(
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
              const SizedBox(height: 32),
              _buildDailyChallenge(dailyQuiz, categoriesState),
              const SizedBox(height: 32),
              _buildCategoriesSection(categoriesState),
              const SizedBox(height: 120),
            ],
          ),
        ),
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
            _buildCircleButton(
              isDarkMode ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
              iconColor: isDarkMode ? const Color(0xFF10B981) : const Color(0xFFBCA371),
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
        if (user != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Text(
                  user.name,
                  style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Center(child: Text('👦', style: TextStyle(fontSize: 14))),
                ),
              ],
            ),
          ),
        _buildCircleButton(Icons.notifications_none_rounded),
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
          color: theme.brightness == Brightness.dark
              ? colorScheme.surface
              : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? colorScheme.onSurface, size: 20),
      ),
    );
  Widget _buildProgressCard(user, userStats) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final xp = user?.xp ?? 3000;
    final level = user?.level ?? 1;
    final streak = user?.streak ?? 7;
    final xpForNextLevel = 2450; // Match mockup
    final xpProgress = 0.3; // Match mockup visual

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.04),
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
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 24),
                  const SizedBox(width: 4),
                  Text(
                    'سلسلة: $streak أيام',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              Text(
                '$xp / $xpForNextLevel',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpProgress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE8F5E9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoriesSection(CategoriesState categoriesState) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories_outlined, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'التحديات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'Cairo'),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.go('/library'),
              child: Row(
                children: [
                   Text(
                    'عرض الكل',
                    style: TextStyle(color: colorScheme.primary, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: colorScheme.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        categoriesState.isLoading
            ? _buildCategoriesSkeleton()
            : categoriesState.error != null
                ? _buildCategoriesError(categoriesState.error!)
                : _buildCategoriesList(
                    categoriesState.categories.toList(),
                  ),
      ],
    );
  }

  Widget _buildCategoriesList(List<Category> categories) {
    if (categories.isEmpty) {
      return _buildEmptyCategories();
    }
    return Column(
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final gradient = _categoryGradients[index % _categoryGradients.length];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildChallengeCard(
            context,
            tag: 'تحدي',
            title: category.name,
            subtitle: '${category.questionCount} سؤال • اختبر معلوماتك الآن',
            icon: category.icon != null && category.icon!.isNotEmpty
                ? Icons.emoji_events_outlined
                : Icons.menu_book_outlined,
            gradient: gradient,
            iconEmoji: category.icon,
            bgImageUrl: _getCategoryBgImage(category.name),
            onTap: () => context.go('/path'),
          ),
        );
      }).toList(),
    );
  }

  String? _getCategoryBgImage(String name) {
    if (name.contains('قرآن')) {
      return 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?auto=format&fit=crop&q=80&w=1080';
    } else if (name.contains('عبادات') || name.contains('صلاة')) {
      return 'https://images.unsplash.com/photo-1597933534024-161830623681?auto=format&fit=crop&q=80&w=1080';
    } else if (name.contains('سيرة')) {
      return 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?auto=format&fit=crop&q=80&w=1080';
    } else if (name.contains('أصول') || name.contains('دين')) {
      return 'https://images.unsplash.com/photo-1518933221971-337351630121?auto=format&fit=crop&q=80&w=1080';
    } else if (name.contains('أخلاق')) {
      return 'https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&q=80&w=1080';
    }
    return 'https://images.unsplash.com/photo-1580974852861-591583008985?auto=format&fit=crop&q=80&w=1080';
  }


  Widget _buildCategoriesSkeleton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 110,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }

  Widget _buildCategoriesError(String error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
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
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.primary.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              size: 32,
              color: colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'استكشف مكتبتنا الإسلامية الشاملة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط على عرض الكل لتصفح جميع الدورات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withOpacity(0.5),
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

  Widget _buildDailyChallenge(AsyncValue<Quiz?> dailyQuiz, CategoriesState categoriesState) {
    // Extract categories to avoid closure issues
    final categories = categoriesState.categories;

    return dailyQuiz.when(
      data: (quiz) {
        if (quiz == null) {
          return _buildChallengeCard(
            context,
            tag: 'التحدي اليومي',
            title: 'اختبار أركان الإسلام',
            subtitle: 'أجب على 10 أسئلة واحصل على 50 نقطة',
            icon: Icons.track_changes_outlined,
            gradient: const [Color(0xFF10B981), Color(0xFF144E2C)],
            bgImageUrl: 'https://images.unsplash.com/photo-1580974852861-591583008985?auto=format&fit=crop&q=80&w=1080',
            onTap: () {
              final aqeedah = categories.firstWhere(
                (c) => c.slug == 'aqeedah-islamiyyah' || c.name.contains('أركان'),
                orElse: () => categories.isNotEmpty ? categories.first : Category(id: '', name: '', slug: ''),
              );
              if (aqeedah.id.isNotEmpty) {
                context.push('/categories/path/${aqeedah.id}');
              }
            },
          );
        }

        return _buildChallengeCard(
          context,
          tag: 'التحدي اليومي',
          title: quiz.title,
          subtitle: quiz.description ?? 'أجب على ${quiz.questions.length} أسئلة واحصل على ${quiz.xp} نقطة',
          icon: Icons.track_changes_outlined,
          gradient: const [Color(0xFF10B981), Color(0xFF144E2C)],
          bgImageUrl: 'https://images.unsplash.com/photo-1580974852861-591583008985?auto=format&fit=crop&q=80&w=1080',
          onTap: () => context.push('/quiz/${quiz.id}'),
        );
      },
      loading: () => _buildChallengeCardSkeleton(),
      error: (_, __) => _buildChallengeCardSkeleton(),
    );
  }

  Widget _buildChallengeCardSkeleton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
    String? iconEmoji,
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            if (bgImageUrl != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: AppNetworkImage(
                    url: bgImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
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
                      _buildLineIcon(iconEmoji, icon),
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
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: gradient[1],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLineIcon(String? emoji, IconData fallbackIcon) {
    if (emoji == null || emoji.isEmpty) {
      return Icon(fallbackIcon, color: Colors.white, size: 32);
    }

    final IconData? lineIcon = _emojiToLineIcon(emoji);
    if (lineIcon != null) {
      return Icon(lineIcon, color: Colors.white, size: 32);
    }

    // If no mapping found, return emoji as fallback but styled nicely
    return Text(emoji, style: const TextStyle(fontSize: 32));
  }

  IconData? _emojiToLineIcon(String emoji) {
    switch (emoji) {
      case '🕌':
        return Icons.mosque_outlined;
      case '⚖️':
        return Icons.gavel_outlined;
      case '📜':
        return Icons.history_edu_outlined;
      case '💎':
        return Icons.diamond_outlined;
      case '📖':
        return Icons.menu_book_outlined;
      case '☀️':
        return Icons.wb_sunny_outlined;
      case '⚫':
        return Icons.event_note_outlined;
      case '⌛':
        return Icons.hourglass_empty_outlined;
      case '🛡️':
        return Icons.shield_outlined;
      case '🕋':
        return Icons.temple_hindu_outlined; // Closest line icon for Kaaba
      default:
        return null;
    }
  }
}
