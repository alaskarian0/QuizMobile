import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        title: const Text('المسار التعليمي'), // Educational Path
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          _buildPathNode(
            title: 'أركان الإسلام', // Pillars of Islam
            stars: 3,
            isActive: true,
            isCompleted: true,
            alignment: 0,
          ),
          _buildPathConnector(alignment: 0.3),
          _buildPathNode(
            title: 'التوحيد', // Monotheism
            stars: 2,
            isActive: true,
            isCompleted: false,
            alignment: 0.6,
          ),
          _buildPathConnector(alignment: 0.3),
          _buildPathNode(
            title: 'الصلاة', // Prayer
            stars: 0,
            isActive: false,
            isCompleted: false,
            alignment: -0.2,
          ),
          _buildPathConnector(alignment: -0.5),
          _buildPathNode(
            title: 'السيرة النبوية', // Prophetic Biography
            stars: 0,
            isActive: false,
            isCompleted: false,
            alignment: -0.6,
          ),
        ],
      ),
    );
  }

  Widget _buildPathNode({
    required String title,
    required int stars,
    required bool isActive,
    required bool isCompleted,
    required double alignment, // -1 to 1
  }) {
    return Align(
      alignment: Alignment(alignment, 0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Icon(
                Icons.star,
                size: 16,
                color: index < stars ? AppColors.goldenYellow : Colors.grey[300],
              );
            }),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: isActive ? () {} : null,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isActive ? AppColors.forestGreen : Colors.grey[300],
                shape: BoxShape.circle,
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: AppColors.forestGreen.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Icon(
                    isActive ? Icons.menu_book : Icons.lock,
                    color: Colors.white,
                    size: 40,
                  ),
                  if (isCompleted)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.goldenYellow,
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathConnector({required double alignment}) {
    return Container(
      height: 60,
      width: double.infinity,
      alignment: Alignment(alignment, 0),
      child: Container(
        width: 4,
        color: Colors.grey[300],
      ),
    );
  }
}
