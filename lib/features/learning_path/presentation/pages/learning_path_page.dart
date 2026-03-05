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
      backgroundColor: const Color(0xFFFDFBF7), // Premium cream background
      body: SafeArea(
        child: Stack(
          children: [
            // Main Path Content
            Positioned.fill(
              child: categoriesState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categoriesState.error != null
                      ? Center(child: Text('خطأ: ${categoriesState.error}'))
                      : _buildMainPath(categoriesState.categories),
            ),
            
            // Floating Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(userStats.asData?.value),
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
    final reversedLevels = allLevels.toList();

    return ListView.builder(
      itemCount: reversedLevels.length,
      padding: const EdgeInsets.only(top: 100, bottom: 80, left: 30, right: 30),
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final levelIndex = index;
        final level = reversedLevels[levelIndex];
        final globalLevelNumber = levelIndex + 1;
        
        final isLeft = globalLevelNumber % 2 != 0;
        
        final isUnlocked = levelIndex <= 1;
        final isActive = levelIndex == 1;
        final isCompleted = levelIndex < 1;
        final state = isCompleted ? 'completed' : (isActive ? 'active' : (isUnlocked ? 'active' : 'locked'));

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Connector: Draws from the PREVIOUS level (below) to THIS level
            if (index > 0)
              Positioned(
                bottom:-20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 120,
                  child: CustomPaint(
                    painter: PathPainter(
                      isFromLeft: !isLeft,
                      isLocked: !isUnlocked,
                    ),
                  ),
                ),
              ),
              
            // The Level Ball: Always on top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildNodeItem(
                context: context,
                id: level.id,
                title: 'المستوى $globalLevelNumber',
                state: state,
                type: 'quiz',
                xp: level.xpReward,
                alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(UserStats? stats) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4332).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1B4332),
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
                context.push('/quiz', extra: {'quizId': id});
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isActive) 
                  const SizedBox(
                    width: 65,
                    height: 65,
                    child: Center(child: _PulseRing()), // Force center without affecting stack size
                  ),
                Container(
                  width: 65, 
                  height: 65,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                    gradient: !isLocked ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isCompleted 
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [const Color(0xFF1B4332), const Color(0xFF2D6A4F)],
                    ) : null,
                    boxShadow: [
                      BoxShadow(
                        color: nodeColor.withOpacity(isLocked ? 0 : 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: isActive
                        ? Border.all(color: const Color(0xFFBCA371), width: 4)
                        : (isCompleted ? null : Border.all(color: Colors.white, width: 3)),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock_outline : (isCompleted ? Icons.check : icon),
                    color: isLocked ? Colors.grey[400] : Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isLocked ? Colors.transparent : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isLocked ? Colors.grey[400] : const Color(0xFF1B4332),
                  ),
                ),
                Text(
                  'XP $xp',
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey[300] : const Color(0xFFBCA371),
                  ),
                ),
              ],
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
      ..color = isLocked ? Colors.grey[200]! : const Color(0xFFBCA371).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    final startX = isFromLeft ? size.width * 0.15 : size.width * 0.85;
    final endX = isFromLeft ? size.width * 0.85 : size.width * 0.15;
    
    path.moveTo(startX, size.height);
    path.cubicTo(
      startX, size.height * 0.3,
      endX, size.height * 0.7,
      endX, 0,
    );

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
