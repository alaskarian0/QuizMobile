import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/reel_provider.dart';
import '../../../../core/models/reel.dart';
import '../../../../core/theme/app_colors.dart';

/// Page for viewing user reels (stories/content)
class ReelsPage extends ConsumerStatefulWidget {
  const ReelsPage({super.key});

  @override
  ConsumerState<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends ConsumerState<ReelsPage> {
  @override
  void initState() {
    super.initState();
    // Load active reels when page is initialized
    Future.microtask(() => ref.read(reelsStateProvider.notifier).loadActiveReels());
  }

  @override
  Widget build(BuildContext context) {
    final reelsState = ref.watch(reelsStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: reelsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : reelsState.error != null
                      ? _buildErrorWidget(reelsState.error!)
                      : reelsState.activeReels.isEmpty
                          ? _buildEmptyState()
                          : _buildReelsList(reelsState.activeReels),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          const Text(
            'القصص والمحتوى',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
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
            onPressed: () => ref.read(reelsStateProvider.notifier).refresh(),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: AppColors.forestGreen.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد قصص حالياً',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelsList(List<Reel> reels) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reels.length,
      itemBuilder: (context, index) {
        return _buildReelCard(reels[index]);
      },
    );
  }

  Widget _buildReelCard(Reel reel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Media or placeholder
          if (reel.mediaUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                reel.mediaUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.forestGreen,
                          AppColors.goldenYellow,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 64,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.forestGreen,
                    AppColors.goldenYellow,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white54,
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reel.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${reel.views}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (reel.xpReward > 0) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.star,
                        size: 18,
                        color: AppColors.goldenYellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${reel.xpReward} XP',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.goldenYellow,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
                if (reel.expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getExpirationColor(reel.expiresAt!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getExpirationText(reel.expiresAt!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getExpirationColor(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative) {
      return Colors.grey;
    } else if (difference.inHours < 1) {
      return AppColors.errorRed;
    } else if (difference.inHours < 24) {
      return AppColors.goldenYellow;
    } else {
      return AppColors.forestGreen;
    }
  }

  String _getExpirationText(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative) {
      return 'منتهي الصلاحية';
    } else if (difference.inMinutes < 60) {
      return 'ينتهي خلال ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'ينتهي خلال ${difference.inHours} ساعة';
    } else {
      return 'ينتهي خلال ${difference.inDays} يوم';
    }
  }
}
