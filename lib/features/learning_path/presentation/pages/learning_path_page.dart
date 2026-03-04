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
            _buildStatsBar(colorScheme),
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
    // Only show categories marked for the home/path
    final pathCategories = categories.where((c) => c.showOnHome).toList();

    if (pathCategories.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مسارات تعليمية حالياً',
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: pathCategories.length,
      itemBuilder: (context, index) {
        final category = pathCategories[index];
        return Column(
          children: [
            _buildUnitHeader(
              context,
              title: category.name,
              description: category.description ?? '',
              icon: category.icon ?? '⭐',
              color: _getCategoryColor(category.color),
            ),
            _buildCategoryStages(context, category),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Color _getCategoryColor(String? colorStr) {
    if (colorStr == null) return AppColors.emeraldGreen;
    try {
      return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
    } catch (e) {
      return AppColors.emeraldGreen;
    }
  }

  Widget _buildCategoryStages(BuildContext context, Category category) {
    // In a real app, we would fetch stages for each category
    // For now, if stages are not pre-loaded, we can show a placeholder or basic levels
    final stages = category.stages ?? [];
    
    if (stages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'سيتم إضافة المستويات قريباً',
          style: GoogleFonts.cairo(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: stages.map((stage) {
        final levels = stage.levels ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                stage.name,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
            _buildPathNodes(context, levels),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPathNodes(BuildContext context, List<Level> levels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: List.generate(levels.length, (index) {
          final level = levels[index];
          final isEven = index % 2 == 0;
          final xOffset = isEven ? -40.0 : 40.0;
          
          // Using placeholder states for demonstration
          final state = index == 0 ? 'active' : 'locked';

          return Column(
            children: [
              Transform.translate(
                offset: Offset(xOffset, 0),
                child: _buildNodeItem(
                  context: context,
                  title: level.name,
                  state: state,
                  type: 'lesson',
                  xp: level.xpReward,
                ),
              ),
              if (index < levels.length - 1)
                _buildConnector(isEven: isEven, isLocked: index + 1 > 0),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatsBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildStatItem('XP 45', Icons.star, Colors.amber),
          const SizedBox(width: 16),
          _buildStatItem('7', Icons.local_fire_department, Colors.orange),
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
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.3 : 0.05),
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
              color: color.withValues(alpha: 0.1),
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
    required String title,
    required String state,
    required String type,
    required int xp,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isLocked = state == 'locked';
    final bool isActive = state == 'active';
    final bool isCompleted = state == 'completed';

    Color nodeColor = isLocked ? colorScheme.onSurface.withValues(alpha: 0.1) : colorScheme.primary;
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

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (!isLocked) {
              if (type == 'quiz') {
                context.push('/quiz');
              } else {
                context.push('/lesson', extra: {'lessonId': 1});
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
                        color: nodeColor.withValues(alpha: 0.3),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isLocked ? colorScheme.onSurface.withValues(alpha: 0.3) : colorScheme.onSurface,
          ),
        ),
        Text(
          'XP $xp',
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isLocked ? colorScheme.onSurface.withValues(alpha: 0.2) : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector({required bool isEven, required bool isLocked}) {
    return SizedBox(
      height: 60,
      width: 100,
      child: CustomPaint(
        painter: PathPainter(isEven: isEven, isLocked: isLocked),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final bool isEven;
  final bool isLocked;

  PathPainter({required this.isEven, required this.isLocked});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLocked ? Colors.grey[300]! : AppColors.forestGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isEven) {
      path.moveTo(size.width * 0.2, 0);
      path.quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.8,
        size.height,
      );
    } else {
      path.moveTo(size.width * 0.8, 0);
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.5,
        size.width * 0.2,
        size.height,
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
              color: AppColors.forestGreen.withValues(alpha: 1 - _controller.value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
