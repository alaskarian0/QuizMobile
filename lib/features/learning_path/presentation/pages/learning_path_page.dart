import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class LearningPathPage extends StatelessWidget {
  const LearningPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المسار التعليمي',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.nightlight_round, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, color: colorScheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStatsBar(colorScheme),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildUnitHeader(
                    context,
                    title: 'أصول الدين الخمسة',
                    description: 'التوحيد، العدل، النبوة، الإمامة، المعاد',
                    icon: '⭐',
                    color: AppColors.emeraldGreen,
                  ),
                  _buildPathNodes(context),
                  const SizedBox(height: 40),
                  _buildUnitHeader(
                    context,
                    title: 'الأئمة المعصومون',
                    description: 'تعرف على الأئمة الاثني عشر',
                    icon: '✨',
                    color: const Color(0xFF065F46),
                  ),
                  _buildPathNodes(context, startIndex: 7),
                ],
              ),
            ),
          ],
        ),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Cairo',
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathNodes(BuildContext context, {int startIndex = 0}) {
    final nodes = [
      {'title': 'التوحيد', 'type': 'lesson', 'state': 'completed', 'xp': 10},
      {'title': 'العدل', 'type': 'lesson', 'state': 'active', 'xp': 10},
      {'title': 'مراجعة', 'type': 'review', 'state': 'locked', 'xp': 15},
      {'title': 'النبوة', 'type': 'lesson', 'state': 'locked', 'xp': 10},
      {'title': 'الإمامة', 'type': 'lesson', 'state': 'locked', 'xp': 10},
      {'title': 'المعاد', 'type': 'lesson', 'state': 'locked', 'xp': 10},
      {'title': 'اختبار', 'type': 'quiz', 'state': 'locked', 'xp': 25},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: List.generate(nodes.length, (index) {
          final node = nodes[index];
          final isEven = index % 2 == 0;
          final xOffset = isEven ? -40.0 : 40.0;
          
          return Column(
            children: [
              Transform.translate(
                offset: Offset(xOffset, 0),
                child: _buildNodeItem(
                  context: context,
                  title: node['title'] as String,
                  state: node['state'] as String,
                  type: node['type'] as String,
                  xp: node['xp'] as int,
                ),
              ),
              if (index < nodes.length - 1)
                _buildConnector(isEven: isEven, isLocked: nodes[index + 1]['state'] == 'locked'),
            ],
          );
        }),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isLocked ? colorScheme.onSurface.withValues(alpha: 0.3) : colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          'XP $xp',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isLocked ? colorScheme.onSurface.withValues(alpha: 0.2) : colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        if (!isLocked)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => Icon(
              Icons.star,
              size: 14,
              color: i < 2 ? Colors.amber : Colors.grey[400],
            )),
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
