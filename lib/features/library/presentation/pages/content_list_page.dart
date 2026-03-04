import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/library.dart';
import '../../../../core/widgets/app_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentListPage extends ConsumerWidget {
  final String title;
  final String category;
  final String? type;

  const ContentListPage({
    super.key,
    required this.title,
    required this.category,
    this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final contentAsync = _getContentProvider(ref);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: colorScheme.surface,
              elevation: 0,
              pinned: true,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: colorScheme.onSurface),
                onPressed: () => context.pop(),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            contentAsync.when(
              data: (items) => SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: items.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('لا يوجد محتوى حالياً', style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = items[index];
                            return _buildContentCard(context, item, isDark, colorScheme);
                          },
                          childCount: items.length,
                        ),
                      ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('خطأ في تحميل البيانات: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AsyncValue<List<dynamic>> _getContentProvider(WidgetRef ref) {
    if (type == 'articles' || category == 'articles') {
      // If category is a slug like 'usul-al-din', fetch by that
      if (category != 'articles') {
           return ref.watch(articlesByCategoryProvider(category));
      }
      return ref.watch(articlesProvider);
    } else if (category == 'lessons') {
      return ref.watch(lessonsProvider);
    } else if (category == 'ebooks') {
      return ref.watch(ebooksProvider);
    } else if (category == 'podcasts') {
      return ref.watch(podcastsProvider);
    }
    return const AsyncValue.data([]);
  }

  Widget _buildContentCard(BuildContext context, dynamic item, bool isDark, ColorScheme colorScheme) {
    String title = '';
    String desc = '';
    String? imageUrl;
    IconData defaultIcon = Icons.article_rounded;
    VoidCallback? onTap;

    if (item is Article) {
      title = item.titleAr;
      desc = item.excerpt ?? '';
      imageUrl = item.imageUrl;
      defaultIcon = Icons.article_rounded;
      onTap = () {
        // Show article detail or similar
      };
    } else if (item is Lesson) {
      title = item.titleAr;
      desc = item.description ?? '';
      imageUrl = item.thumbnailUrl;
      defaultIcon = Icons.play_circle_fill_rounded;
      onTap = () async {
        if (item.videoUrl != null) {
          final url = Uri.parse(item.videoUrl!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }
      };
    } else if (item is EBook) {
      title = item.titleAr;
      desc = item.description ?? '';
      imageUrl = item.coverUrl;
      defaultIcon = Icons.menu_book_rounded;
      onTap = () async {
          final url = Uri.parse(item.fileUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
      };
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: imageUrl != null
                      ? AppNetworkImage(url: imageUrl, fit: BoxFit.cover)
                      : Container(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(defaultIcon, color: colorScheme.primary, size: 32),
                        ),
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
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (item is Lesson) ...[
                      const SizedBox(height: 8),
                      Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                         decoration: BoxDecoration(
                           color: Colors.red.withValues(alpha: 0.1),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: const Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Icon(Icons.play_arrow_rounded, size: 14, color: Colors.red),
                             SizedBox(width: 4),
                             Text(
                               'درس مرئي',
                               style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                             ),
                           ],
                         ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

