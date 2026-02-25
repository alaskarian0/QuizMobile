import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundBeige,
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.02,
              child: AppNetworkImage(
                url: 'https://www.transparenttextures.com/patterns/islamic-art.png',
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 24),
                  _buildGreeting(),
                  const SizedBox(height: 16),
                  _buildProgressCard(),
                  const SizedBox(height: 24),
                  _buildBadgesSection(),
                  const SizedBox(height: 24),
                  _buildChallengeCard(
                    context,
                    tag: 'التحدي اليومي',
                    title: 'اختبار أركان الإسلام',
                    subtitle: 'أجب على 10 أسئلة واحصل على 50 نقطة',
                    icon: Icons.track_changes,
                    gradient: const [Color(0xFF10B981), Color(0xFF144E2C)],
                    bgImageUrl: 'https://images.unsplash.com/photo-1584258708922-def95284de07?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpc2xhbWljJTIwbW9zcXVlJTIwcGF0dGVybnxlbnwxfHx8fDE3Njg3Mzg3ODl8MA&ixlib=rb-4.1.0&q=80&w=1080',
                    onTap: () => context.push('/quiz'),
                  ),
                  const SizedBox(height: 16),
                  _buildChallengeCard(
                    context,
                    tag: 'اختبار موسمي',
                    title: 'تحدي شهر رمضان المبارك',
                    subtitle: 'اختبار خاص بأحكام الصيام والقيام',
                    icon: Icons.star_outline,
                    gradient: const [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
                    bgImageUrl: 'https://images.unsplash.com/photo-1612176894219-8493bf9b9b1c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyYW1hZGFuJTIwbGFudGVybnxlbnwxfHx8fDE3Njg3Mzg3ODl8MA&ixlib=rb-4.1.0&q=80&w=1080',
                    buttonText: 'ابدأ التحدي',
                    onTap: () => context.push('/monthly-contest'),
                  ),
```dart
                  const SizedBox(height: 16),
                  _buildChallengeCard(
                    context,
                    tag: 'شهر محرم 1447 هـ',
                    title: 'المسابقة الشهرية',
                    subtitle: '100 سؤال • 45 مُجاب • المرتبة #3',
                    icon: Icons.calendar_month_outlined,
                    gradient: const [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                    bgImageUrl: 'assets/images/background.jpg',
                    buttonText: 'متابعة المسابقة',
                    onTap: () => context.push('/monthly-contest'),
                  ),
                  const SizedBox(height:
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCircleButton(Icons.grid_view_rounded),
            const SizedBox(width: 10),
            _buildCircleButton(Icons.wb_sunny_outlined, iconColor: const Color(0xFFBCA371)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF144E2C),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Text(
                'أحمد خالد',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Center(child: Text('👦', style: TextStyle(fontSize: 14))),
              ),
            ],
          ),
        ),
        _buildCircleButton(Icons.add),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor ?? AppColors.textDark, size: 20),
    );
  }

  Widget _buildGreeting() {
    return const Text(
      'السلام عليكم، أحمد! 👋',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '3000 / 2450',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  const Text(
                    'سلسلة: 7 أيام',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 22),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.8,
              minHeight: 12,
              backgroundColor: Color(0xFFF1F8E9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأوسمة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Cairo'),
            ),
            Text(
              '12 أوسمة',
              style: TextStyle(fontSize: 14, color: AppColors.textLight, fontFamily: 'Cairo'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBadgeItem(Icons.flash_on, 'برق', const Color(0xFFF5F5F5), const Color(0xFF94A3B8)),
              const SizedBox(width: 12),
              _buildBadgeItem(Icons.workspace_premium, 'ملك', const Color(0xFFF3E5F5), const Color(0xFF8B5CF6)),
              const SizedBox(width: 12),
              _buildBadgeItem(Icons.star_outline, 'نجم', const Color(0xFFE8F5E9), const Color(0xFF10B981)),
              const SizedBox(width: 12),
              _buildBadgeItem(Icons.emoji_events_outlined, 'فائز', const Color(0xFFE3F2FD), const Color(0xFF3B82F6)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: iconColor, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    String? bgImageUrl,
    String buttonText = 'ابدأ الآن',
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(28),
        image: bgImageUrl != null ? DecorationImage(
          image: NetworkImage(bgImageUrl),
          fit: BoxFit.cover,
          opacity: 0.12,
        ) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                ),
                Icon(icon, color: Colors.white, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: gradient[1],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
