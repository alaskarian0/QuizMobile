import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/answer_history_provider.dart';
import '../../../../core/models/answer_history.dart';
import '../../../../core/theme/app_colors.dart';

/// Page for viewing answer history and statistics
class AnswerHistoryPage extends ConsumerStatefulWidget {
  const AnswerHistoryPage({super.key});

  @override
  ConsumerState<AnswerHistoryPage> createState() => _AnswerHistoryPageState();
}

class _AnswerHistoryPageState extends ConsumerState<AnswerHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load all data when page is initialized
    Future.microtask(() => ref.read(answerHistoryStateProvider.notifier).loadAll());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(answerHistoryStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(historyState.stats),
            _buildTabBar(),
            Expanded(
              child: historyState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : historyState.error != null
                      ? _buildErrorWidget(historyState.error!)
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildStatsTab(historyState.stats),
                            _buildHistoryTab(historyState.history),
                            _buildIncorrectTab(historyState.incorrectAnswers),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AnswerStats? stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_edu,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Text(
                'سجل الإجابات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          if (stats != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('المجموع', '${stats.total}', Icons.quiz),
                  _buildStatItem('صحيحة', '${stats.correct}', Icons.check_circle, AppColors.successGreen),
                  _buildStatItem('خاطئة', '${stats.incorrect}', Icons.cancel, AppColors.errorRed),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, [Color? color]) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.forestGreen,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.forestGreen,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'الإحصائيات'),
          Tab(text: 'السجل'),
          Tab(text: 'للمراجعة'),
        ],
      ),
    );
  }

  Widget _buildStatsTab(AnswerStats? stats) {
    if (stats == null) {
      return const Center(
        child: Text(
          'لا توجد إحصائيات',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatCard(
          'نسبة الدقة',
          '${stats.accuracy.toStringAsFixed(1)}%',
          Icons.checkroom,
          AppColors.forestGreen,
          stats.accuracy / 100,
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'مجموع الخبرة',
          '${stats.totalXP} XP',
          Icons.star,
          AppColors.goldenYellow,
          stats.totalXP / 5000, // Normalize to 5000 XP
        ),
        const SizedBox(height: 16),
        _buildDetailedStats(stats),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats(AnswerStats stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل الإحصائيات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('إجمالي الأسئلة', '${stats.total}'),
          const Divider(height: 24),
          _buildDetailRow('إجابات صحيحة', '${stats.correct}', AppColors.successGreen),
          const Divider(height: 24),
          _buildDetailRow('إجابات خاطئة', '${stats.incorrect}', AppColors.errorRed),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textDark,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textDark,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(List<AnswerHistory> history) {
    if (history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.forestGreen,
            ),
            SizedBox(height: 16),
            Text(
              'لا يوجد سجل إجابات',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(history[index]);
      },
    );
  }

  Widget _buildHistoryCard(AnswerHistory item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.isCorrect ? AppColors.successGreen.withValues(alpha: 0.1) : AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.isCorrect ? Icons.check_circle : Icons.cancel,
              color: item.isCorrect ? AppColors.successGreen : AppColors.errorRed,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.question?.text ?? 'سؤال',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          if (item.xpEarned > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.goldenYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.goldenYellow),
                  const SizedBox(width: 4),
                  Text(
                    '+${item.xpEarned}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldenYellow,
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

  Widget _buildIncorrectTab(List<AnswerHistory> incorrectAnswers) {
    if (incorrectAnswers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.successGreen,
            ),
            SizedBox(height: 16),
            Text(
              'أحسنت! لا توجد إجابات خاطئة',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: incorrectAnswers.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(incorrectAnswers[index]);
      },
    );
  }

  Widget _buildReviewCard(AnswerHistory item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.errorRed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.errorRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'للمراجعة',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.question?.text ?? 'سؤال',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          if (item.question != null) ...[
            const Text(
              'الإجابة الصحيحة:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getCorrectAnswerText(item.question!),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getCorrectAnswerText(dynamic question) {
    if (question == null) return 'غير متوفر';
    final correctIndex = question.correctOption ?? 0;
    final options = question.options as List?;
    if (options != null && correctIndex >= 0 && correctIndex < options.length) {
      return options[correctIndex].toString();
    }
    return 'الخيار ${correctIndex + 1}';
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(answerHistoryStateProvider.notifier).refresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }
}
