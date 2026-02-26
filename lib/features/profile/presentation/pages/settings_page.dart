import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';

/// Settings Page - App settings including theme toggle
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Back button on LEFT
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildSectionCard(
              context,
              title: 'المظهر',
              icon: Icons.palette_outlined,
              iconColor: const Color(0xFF9C27B0),
              children: [
                _buildThemeToggle(
                  context,
                  ref,
                  isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'الحساب',
              icon: Icons.person_outline,
              iconColor: const Color(0xFF2196F3),
              children: [
                _buildSettingsItem(
                  icon: Icons.edit_outlined,
                  title: 'تعديل الملف الشخصي',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'تغيير البريد الإلكتروني',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outlined,
                  title: 'تغيير كلمة المرور',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'الإشعارات',
              icon: Icons.notifications_outlined,
              iconColor: const Color(0xFFF59E0B),
              children: [
                _buildSwitchItem(
                  icon: Icons.notifications_active,
                  title: 'إشعارات التذكير',
                  subtitle: 'تلقي تذكيرات يومية',
                  value: true,
                  onChanged: (value) {},
                ),
                _buildSwitchItem(
                  icon: Icons.campaign,
                  title: 'العرض والعروض',
                  subtitle: 'إشعارات العروض الخاصة',
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'الدعم',
              icon: Icons.support_agent_outlined,
              iconColor: const Color(0xFF10B981),
              children: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'مركز المساعدة',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.contact_support_outlined,
                  title: 'اتصل بنا',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1B5E20).withValues(alpha: 0.15)
                  : const Color(0xFFFFB74D).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: isDarkMode ? const Color(0xFF1B5E20) : const Color(0xFFF57C00),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع المظلم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'تفعيل المظهر الداكن للتطبيق',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          // Theme toggle button on the RIGHT
          SizedBox(
            width: 60,
            height: 32,
            child: Transform.scale(
              scale: 0.85,
              child: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                activeColor: const Color(0xFF1B5E20),
                activeTrackColor: const Color(0xFF1B5E20).withValues(alpha: 0.5),
                inactiveThumbColor: const Color(0xFFF57C00),
                inactiveTrackColor: const Color(0xFFFFB74D).withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.forestGreen, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[400],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.forestGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.forestGreen,
              activeTrackColor: AppColors.forestGreen.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5252),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF5252).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle logout
          },
          borderRadius: BorderRadius.circular(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
