import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/category.dart';
import '../../../../core/models/stage.dart';

class CategoryPathPage extends ConsumerWidget {
  final String categoryId;

  const CategoryPathPage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryWithStagesProvider(categoryId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: categoryAsync.when(
        data: (category) => _buildPathView(context, category),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('حدث خطأ: $err'),
              ElevatedButton(
                onPressed: () => ref.refresh(categoryWithStagesProvider(categoryId)),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathView(BuildContext context, Category category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stages = category.stages;

    if (stages.length == 1 && stages[0].levels.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/quiz', extra: {'quizId': stages[0].levels[0].id});
      });
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: _parseColor(category.color ?? '#10B981'),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              category.name,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (category.icon != null)
                  Center(
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        category.icon!,
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category.description != null)
                  Text(
                    category.description!,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: 'Cairo',
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        if (stages.isEmpty)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('لا توجد مراحل متوفرة حالياً'),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final stage = stages[index];
                  return _buildStagePath(context, stage, index, stages.length);
                },
                childCount: stages.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStagePath(BuildContext context, Stage stage, int index, int total) {
    return Column(
      children: [
        _buildStageHeader(context, stage),
        ...List.generate(stage.levels.length, (lIndex) {
          final level = stage.levels[lIndex];
          final isEven = lIndex % 2 == 0;
          final xOffset = isEven ? -40.0 : 40.0;
          
          return Column(
            children: [
              Transform.translate(
                offset: Offset(xOffset, 0),
                child: _buildNodeItem(
                  context: context,
                  level: level,
                  isLocked: false, // For now
                ),
              ),
              if (lIndex < stage.levels.length - 1 || index < total - 1)
                _buildConnector(isEven: isEven, isLocked: false),
            ],
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStageHeader(BuildContext context, Stage stage) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Text(
        stage.name,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildNodeItem({
    required BuildContext context,
    required Level level,
    required bool isLocked,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color nodeColor = isLocked ? colorScheme.onSurface.withOpacity(0.1) : colorScheme.primary;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (!isLocked) {
              context.push('/quiz', extra: {'quizId': level.id});
            }
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: nodeColor,
              shape: BoxShape.circle,
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: nodeColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Icon(
              isLocked ? Icons.lock : Icons.emoji_events,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          level.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isLocked ? colorScheme.onSurface.withOpacity(0.3) : colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildConnector({required bool isEven, required bool isLocked}) {
    return SizedBox(
      height: 50,
      width: 100,
      child: CustomPaint(
        painter: PathPainter(isEven: isEven, isLocked: isLocked),
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
      ..strokeWidth = 4
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
