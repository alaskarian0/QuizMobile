import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(title: const Text('المتصدرين')),
      body: const Center(child: Text('قريباً...')),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.forestGreen,
      unselectedItemColor: AppColors.textLight,
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) context.go('/');
        if (index == 1) context.go('/categories');
        if (index == 2) context.go('/leaderboard');
        if (index == 3) context.go('/profile');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'التصنيفات'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'المتصدرين'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
      ],
    );
  }
}
