import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/models.dart';

class LearningPathPage extends ConsumerStatefulWidget {
  const LearningPathPage({super.key});

  @override
  ConsumerState<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends ConsumerState<LearningPathPage> {
  @override
  void initState() {
    super.initState();
    // Refresh categories to ensure we have the latest data
    Future.microtask(() => ref.read(categoriesStateProvider.notifier).loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesState = ref.watch(categoriesStateProvider);
    final userStats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المسار التعليمي',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: () => ref.read(categoriesStateProvider.notifier).loadCategories(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(userStats.asData?.value),
            Expanded(
              child: categoriesState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categoriesState.error != null
                      ? Center(child: Text('خطأ: ${categoriesState.error}'))
                      : _buildMainPath(categoriesState.categories),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPath(List<Category> categories) {
    // Collect all levels from all categories and all stages into one list
    final allLevels = <Level>[];
    for (var cat in categories.where((c) => c.showOnHome)) {
      for (var stage in cat.stages) {
        allLevels.addAll(stage.levels);
      }
    }

    if (allLevels.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مستويات حالياً',
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    // We reverse the list for the "bottom-up" view
    // Level 1 will be at index 0 (bottom of the scroll)
    final reversedLevels = allLevels.toList();

    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 0),
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60), // Increased horizontal padding
      child: Column(
        children: List.generate(reversedLevels.length, (index) {
          final levelIndex = reversedLevels.length - 1 - index;
          final level = reversedLevels[levelIndex];
          final globalLevelNumber = levelIndex + 1;
          
          // Zig-zag pattern
          final isLeft = globalLevelNumber % 2 != 0;
          
          // Logic for unlocking (dummy for now)
          final isUnlocked = levelIndex <= 1;
          final isActive = levelIndex == 1;
          final isCompleted = levelIndex < 1;
          final state = isCompleted ? 'completed' : (isActive ? 'active' : (isUnlocked ? 'active' : 'locked'));

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (index > 0)
                Positioned(
                  bottom: 120, // Adjusted vertical spacing
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 120, // Respect new padding
                    height: 120,
                    child: CustomPaint(
                      painter: PathPainter(
                        isFromLeft: (globalLevelNumber - 1) % 2 != 0,
                        isLocked: !isUnlocked,
                      ),
                    ),
                  ),
                ),
                
              _buildNodeItem(
                context: context,
                id: level.id,
                title: 'المستوى $globalLevelNumber',
                state: state,
                type: 'quiz',
                xp: level.xpReward,
                alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              ),
              
              const SizedBox(height: 150), // Standardized spacing
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(UserStats? stats) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('${stats?.streak ?? 0}', Icons.local_fire_department, Colors.orange),
          Text(
            'المسار التعليمي',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          _buildStatItem('${stats?.totalXP ?? 0}', Icons.stars, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, IconData icon, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 4),
        Icon(icon, color: color, size: 24),
      ],
    );
  }

  Widget _buildUnitHeader(
    BuildContext context, {
    required String title,
    required String description,
    required String icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeItem({
    required BuildContext context,
    required String id,
    required String title,
    required String state,
    required String type,
    required int xp,
    required Alignment alignment,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isLocked = state == 'locked';
    final bool isActive = state == 'active';
    final bool isCompleted = state == 'completed';

    Color nodeColor = isLocked ? colorScheme.onSurface.withOpacity(0.1) : colorScheme.primary;
    if (isCompleted) nodeColor = AppColors.emeraldGreen;
    if (isActive) nodeColor = AppColors.emeraldGreen;

    IconData icon;
    switch (type) {
      case 'review':
        icon = Icons.refresh;
        break;
      case 'quiz':
        icon = Icons.emoji_events;
        break;
      default:
        icon = Icons.book;
    }

    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (!isLocked) {
                if (type == 'quiz') {
                  context.push('/quiz', extra: {'quizId': id});
                } else {
                  context.push('/lesson', extra: {'lessonId': id});
                }
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isActive)
                  const _PulseRing(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!isLocked)
                        BoxShadow(
                          color: nodeColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                    ],
                    border: isActive
                        ? Border.all(color: AppColors.goldenYellow, width: 4)
                        : null,
                  ),
                  child: Icon(
                    isLocked ? Icons.lock : (isCompleted ? Icons.check : icon),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isLocked ? colorScheme.onSurface.withOpacity(0.3) : colorScheme.onSurface,
            ),
          ),
          Text(
            'XP $xp',
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isLocked ? colorScheme.onSurface.withOpacity(0.2) : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector({required bool isEven, required bool isLocked}) {
    return const SizedBox.shrink(); // Not used anymore as we use Stack positioning
  }
}

class PathPainter extends CustomPainter {
  final bool isFromLeft;
  final bool isLocked;

  PathPainter({required this.isFromLeft, required this.isLocked});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLocked ? Colors.grey[300]! : AppColors.forestGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Width is constrained to node center-to-center
    // Start at bottom center of the current alignment, end at top center of target
    if (isFromLeft) {
      // From Left node (bottom) to Right node (top)
      path.moveTo(0, size.height);
      path.cubicTo(
        0, size.height * 0.5,
        size.width, size.height * 0.5,
        size.width, 0,
      );
    } else {
      // From Right node (bottom) to Left node (top)
      path.moveTo(size.width, size.height);
      path.cubicTo(
        size.width, size.height * 0.5,
        0, size.height * 0.5,
        0, 0,
      );
    }

    if (isLocked) {
      final dashPath = Path();
      const dashWidth = 8.0;
      const dashSpace = 6.0;
      double distance = 0.0;
      for (final ui.PathMetric metric in path.computeMetrics()) {
        while (distance < metric.length) {
          dashPath.addPath(
            metric.extractPath(distance, distance + dashWidth),
            Offset.zero,
          );
          distance += dashWidth + dashSpace;
        }
      }
      canvas.drawPath(dashPath, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PulseRing extends StatefulWidget {
  const _PulseRing();

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 80 + (40 * _controller.value),
          height: 80 + (40 * _controller.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.forestGreen.withOpacity(1 - _controller.value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
