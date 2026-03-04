import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/category.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final List<List<Color>> _categoryGradients = [
    [const Color(0xFF10B981), const Color(0xFF0F4C36)], // Deep Emerald
    [const Color(0xFF7C3AED), const Color(0xFF4C1D95)], // Deep Purple
    [const Color(0xFFF59E0B), const Color(0xFF92400E)], // Deep Amber
    [const Color(0xFF2563EB), const Color(0xFF1E3A8A)], // Deep Blue
    [const Color(0xFFDB2777), const Color(0xFF831843)], // Deep Pink
    [const Color(0xFF0D9488), const Color(0xFF134E4A)], // Deep Teal
  ];

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('المعارف الإسلامية'),
                    const SizedBox(height: 16),
                    _buildKnowledgeSubsections(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('أقسام المكتبة'),
                    const SizedBox(height: 16),
                    _buildLibrarySections(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeSubsections() {
    final subsections = [
      {
        'title': 'أصول الدين',
        'subtitle': 'العقيدة والتوحيد',
        'icon': '🕌',
        'category': 'usul-al-din',
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'الأحكام الشرعية',
        'subtitle': 'الفقه والعبادات',
        'icon': '⚖️',
        'category': 'ahkam-shariyya',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'الأخلاق الإسلامية',
        'subtitle': 'تزكية النفس',
        'icon': '💎',
        'category': 'islamic-ethics',
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subsections.length,
        itemBuilder: (context, index) {
          final sub = subsections[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: () {
                context.push('/library/content', extra: {
                  'title': sub['title'],
                  'category': sub['category'],
                  'type': 'articles',
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (sub['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: (sub['color'] as Color).withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sub['icon'] as String, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 12),
                    Text(
                      sub['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      sub['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SliverAppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      title: const Text(
        'المكتبة الإسلامية',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'نهل العلم النافع',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'مرجعك الشامل للمعرفة الإسلامية الموثقة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
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
        'icon': Icons.article_rounded,
        'title': 'المقالات',
        'subtitle': 'تثقف بوعي',
        'color': const Color(0xFF10B981),
        'slug': 'articles',
      },
      {
        'icon': Icons.video_library_rounded,
        'title': 'الدروس',
        'subtitle': 'مرئيات تعليمية',
        'color': const Color(0xFFF59E0B),
        'slug': 'lessons',
      },
      {
        'icon': Icons.import_contacts_rounded,
        'title': 'الكتب',
        'subtitle': 'مطالعة قيمة',
        'color': const Color(0xFF8B5CF6),
        'slug': 'ebooks',
      },
      {
        'icon': Icons.headphones_rounded,
        'title': 'البودكاست',
        'subtitle': 'استماع ممتع',
        'color': const Color(0xFF3B82F6),
        'slug': 'podcasts',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return _buildSectionCard(
          section['icon'] as IconData,
          section['title'] as String,
          section['subtitle'] as String,
          section['color'] as Color,
          section['slug'] as String,
        );
      },
    );
  }

  Widget _buildSectionCard(IconData icon, String title, String subtitle, Color color, String slug) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/library/content', extra: {
          'title': title,
          'category': slug,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.5),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

