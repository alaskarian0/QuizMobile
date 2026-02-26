import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Library Page - Page for accessing learning content
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildLibrarySections(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المكتبة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
          GestureDetector(
            onTap: () {
              // Search functionality
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: AppColors.forestGreen,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6), // Purple
            Color(0xFF6366F1), // Indigo
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'المكتبة الإسلامية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'استكشف موارد تعليمية متنوعة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibrarySections() {
    final sections = [
      {
        'icon': Icons.article,
        'title': 'المقالات',
        'subtitle': 'مقالات تثقفية متنوعة',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.video_library,
        'title': 'الدروس التعليمية',
        'subtitle': 'فيديوهات تعليمية',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.headphones,
        'title': 'البودكاست',
        'subtitle': 'محتوى صوتي',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.import_contacts,
        'title': 'الكتب الإلكترونية',
        'subtitle': 'مكتبة رقمية',
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Column(
      children: sections.map((section) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSectionCard(
              section['icon'] as IconData,
              section['title'] as String,
              section['subtitle'] as String,
              section['color'] as Color,
            ),
          ))
          .toList(),
    );
  }

  Widget _buildSectionCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }
}
