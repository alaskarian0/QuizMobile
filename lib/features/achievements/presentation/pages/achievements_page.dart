import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Achievements Page - Page showing completed achievements and goals
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

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
              _buildMainCard(),
              const SizedBox(height: 16),
              _buildSummaryCard(),
              const SizedBox(height: 16),
              _buildGoalsCard(),
              const SizedBox(height: 20),
              _buildCTAButton(),
              const SizedBox(height: 16),
              _buildStatsCards(),
              const SizedBox(height: 20),
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
            'الإنجازات المكتملة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to detailed achievements page
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.forestGreen,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF144E2C), // Dark green
            Color(0xFF10B981), // Lighter green
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestGreen.withValues(alpha: 0.3),
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
              Icons.emoji_events,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'أنجز أكبر عدد ممكن',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اجمع النقاط والهدايا',
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

  Widget _buildSummaryCard() {
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
      child: Column(
        children: [
          _buildSummaryItem(
            Icons.star,
            'الإنجازات المكتملة',
            '100 نقطة',
            const Color(0xFFFFD700),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            Icons.access_time,
            'الإنجازات اليومية',
            '100 نقطة (يومياً)',
            const Color(0xFF9C27B0),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            Icons.card_giftcard,
            'المكافآت',
            '1500 XP عند اكتمال الإنجازات',
            const Color(0xFFFF6B35),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            Icons.military_tech,
            'الإنجازات',
            'اجمع النقاط، اكتسب خبرة، واحصل على هدايا مميزة',
            const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsCard() {
    final goals = [
      'اكمل جميع الإنجازات اليومية',
      'سجل دخول لمدة 8 أيام متتالية',
      'اكمل 10 إنجازات لتحصل على مكافأة خاصة',
      'الكل',
    ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أهداف الإنجازات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          ...goals.map((goal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.forestGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        goal,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textDark,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCTAButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to achievements list or start achievements
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'ابدأ الإنجازات!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              Icons.emoji_events,
              'الإنجازات',
              '2,847',
              const Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              Icons.calendar_today,
              'أيام متتالية',
              '30',
              const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
