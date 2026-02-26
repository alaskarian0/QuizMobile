import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';

class ResultsPage extends StatelessWidget {
  final int score;
  final int total;

  const ResultsPage({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'تهانينا! 🎉',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لقد أتممت التحدي بنجاح استمر في التعلم!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.textLight, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 48),
              _buildScoreCircle(),
              const SizedBox(height: 48),
              _buildStatsRow(),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
                  onPressed: () => context.pushReplacement('/quiz'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1B4332), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('إعادة المحاولة', style: TextStyle(color: Color(0xFF1B4332), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBCA371).withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: total > 0 ? score / total : 0,
              strokeWidth: 12,
              backgroundColor: Colors.grey[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1B4332)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'من $total',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textLight,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ResultStat(label: 'إجابة صحيحة', value: '$score', color: const Color(0xFF10B981)),
        _ResultStat(label: 'إجابة خاطئة', value: '${total - score}', color: AppColors.errorRed),
        const _ResultStat(label: 'نقاط XP', value: '+150', color: Color(0xFF3B82F6)),
      ],
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textLight, fontFamily: 'Cairo'),
        ),
      ],
    );
  }
}
