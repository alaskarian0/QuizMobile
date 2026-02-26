import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_network_image.dart';

class ContentListPage extends StatelessWidget {
  final String title;
  final String category;

  const ContentListPage({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Dummy data based on category
    final items = _getDummyItems();

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
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    return _buildContentItem(context, item, isDark, colorScheme);
                  },
                  childCount: items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getDummyItems() {
    switch (category) {
      case 'articles':
        return [
          {'title': 'فضل الصلاة ومكانتها', 'desc': 'مقال يتحدث عن أهمية الصلاة في حياة المسلم', 'date': '2024-03-20'},
          {'title': 'بر الوالدين وأثره', 'desc': 'كيف نبر والدينا في العصر الحديث؟', 'date': '2024-03-18'},
          {'title': 'أخلاق النبي الكريم', 'desc': 'دروس من حياة النبي في التعامل مع الآخرين', 'date': '2024-03-15'},
        ];
      case 'lessons':
        return [
          {'title': 'سلسلة تعلم القرآن', 'desc': 'درس مرئي لتعليم أحكام التجويد الأساسية', 'date': 'فيديو • 15:30'},
          {'title': 'قصص الأنبياء - آدم', 'desc': 'قصة الخلق بأسلوب مشوق ومبسط بالصوت والصورة', 'date': 'فيديو • 22:45'},
          {'title': 'أركان الإسلام بالتفصيل', 'desc': 'شرح مبسط للأركان الخمسة للمبتدئين', 'date': 'فيديو • 18:20'},
        ];
      case 'podcasts':
        return [
          {'title': 'حديث القلب - الحلقة 1', 'desc': 'بودكاست يسعى لراحة النفس وطمأنينة القلب', 'date': 'صوت • 45:00'},
          {'title': 'أسئلة معاصرة', 'desc': 'إجابات على أسئلة الشباب الدينية الشائعة', 'date': 'صوت • 33:15'},
          {'title': 'رحلة في السيرة', 'desc': 'تتبع لمسار الهجرة النبوية المباركة', 'date': 'صوت • 50:10'},
        ];
      case 'books':
        return [
          {'title': 'حصن المسلم', 'desc': 'كتاب الأذكار اليومية من الكتاب والسنة', 'size': '2.5 MB'},
          {'title': 'الأربعون النووية', 'desc': 'شرح مبسط لأهم الأحاديث النبوية الشاملة', 'size': '4.1 MB'},
          {'title': 'رياض الصالحين', 'desc': 'مختارات من كلام سيد المرسلين', 'size': '8.3 MB'},
        ];
      default:
        return [
          {'title': 'محتوى قادم قريباً', 'desc': 'انتظروا المزيد من المحتوى قريباً', 'date': '-'},
        ];
    }
  }

  Widget _buildContentItem(BuildContext context, Map<String, String> item, bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getIconForCategory(),
              color: colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: colorScheme.primary.withValues(alpha: 0.5)),
                    const SizedBox(width: 4),
                    Text(
                      item['date'] ?? item['size'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory() {
    switch (category) {
      case 'articles': return Icons.article_rounded;
      case 'lessons': return Icons.play_lesson_rounded;
      case 'podcasts': return Icons.headphones_rounded;
      case 'books': return Icons.import_contacts_rounded;
      default: return Icons.info_outline;
    }
  }
}
