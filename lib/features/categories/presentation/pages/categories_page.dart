import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/providers.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        title: const Text('المسار التعليمي'), // Educational Path
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(categoriesStateProvider.notifier).refresh(),
        child: categoriesState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : categoriesState.error != null
                ? _buildErrorWidget(categoriesState.error!, () {
                    ref.read(categoriesStateProvider.notifier).refresh();
                  })
                : categoriesState.categories.isEmpty
                    ? _buildEmptyWidget()
                    : _buildCategoriesList(context, categoriesState.categories),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, List categories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final alignment = (index % 3 - 1) * 0.6; // Alternating positions
        return Column(
          children: [
            if (index > 0) _buildPathConnector(alignment: (index % 2 == 0) ? 0.3 : -0.3),
            _buildCategoryCard(
              context,
              category: category,
              alignment: alignment,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required dynamic category,
    required double alignment,
  }) {
    final String name = category.name ?? '';
    final String? icon = category.icon;
    final int questionCount = category.questionCount ?? 0;
    final String color = category.color ?? '#10B981';

    return Align(
      alignment: Alignment(alignment, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push('/categories/${category.id}'),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _parseColor(color),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _parseColor(color).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (icon != null && icon.isNotEmpty)
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 40),
                    )
                  else
                    const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                      size: 40,
                    ),
                  if (questionCount > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$questionCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathConnector({required double alignment}) {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment(alignment, 0),
      child: Container(
        width: 3,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد فئات حالياً',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textLight,
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
      return AppColors.forestGreen;
    }
  }
}
