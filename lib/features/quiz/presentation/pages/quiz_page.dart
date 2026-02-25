import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'كم عدد الأئمة المعصومين عليهم السلام؟',
      'image': 'https://images.unsplash.com/photo-1724051526928-ae6f5d53bead?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpbWFtJTIwYWxpJTIwc2hyaW5lJTIwbmFqYWZ8ZW58MXx8fHwxNzY4ODIwMDg3fDA&ixlib=rb-4.1.0&q=80&w=1080',
      'options': ['عشرة أئمة', 'أحد عشر إماماً', 'اثنا عشر إماماً معصوماً', 'ثلاثة عشر إماماً'],
      'correctIndex': 2,
    },
    {
      'question': 'من هو الإمام المدفون في مدينة مشهد؟',
      'image': 'https://images.unsplash.com/photo-1591604466107-ec97de577aff?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpc2xhbWljJTIwY2FsZW5kYXJ8ZW58MXx8fHwxNzY4NzM4Nzg5fDA&ixlib=rb-4.1.0&q=80&w=1080',
      'options': ['الإمام الكاظم (ع)', 'الإمام الرضا (ع)', 'الإمام الجواد (ع)', 'الإمام الهادي (ع)'],
      'correctIndex': 1,
    }
  ];

  void _handleAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
      });
    } else {
      context.pushReplacement('/results', extra: {
        'score': _selectedAnswerIndex == _questions[_currentQuestionIndex]['correctIndex'] ? 1 : 0, 
        'total': _questions.length
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: AppNetworkImage(
                url: 'https://www.transparenttextures.com/patterns/islamic-art.png',
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildQuizCard(question),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        _buildFinishButton(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleIcon(Icons.add, AppColors.textDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3928),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Text(
                  'تحدي اليوم',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.flash_on, color: Colors.white, size: 14)),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCircleIcon(Icons.wb_sunny_outlined, const Color(0xFFBCA371)),
              const SizedBox(width: 10),
              _buildCircleIcon(Icons.close, AppColors.textDark, onTap: () => context.pop()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> question) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.history_toggle_off, color: Colors.grey, size: 20),
                Text(
                  'السؤال ${_currentQuestionIndex + 1} من ${_questions.length}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppNetworkImage(
              url: question['image'],
              height: 180,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24),
              shimmerBaseColor: const Color(0xFFE8F4EC),
              shimmerHighlightColor: const Color(0xFFF5FBF7),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(question['options'].length, (index) {
            return _buildOption(index, question['options'][index], question['correctIndex']);
          }),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _hasAnswered ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBCA371),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_currentQuestionIndex < _questions.length - 1 ? 'السؤال التالي' : 'عرض النتائج', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text, int correctIndex) {
    final isSelected = _selectedAnswerIndex == index;
    final isCorrect = index == correctIndex;
    
    Color bgColor = Colors.white;
    Color textColor = AppColors.textDark;
    Border? border = Border.all(color: Colors.grey.withValues(alpha: 0.2));

    if (_hasAnswered) {
      if (isCorrect) {
        bgColor = const Color(0xFF1B4332);
        textColor = Colors.white;
        border = null;
      } else if (isSelected) {
        bgColor = const Color(0xFFD32D2D);
        textColor = Colors.white;
        border = null;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: InkWell(
        onTap: () => _handleAnswer(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionIcon(Icons.bookmark_border),
        const SizedBox(width: 16),
        _buildActionIcon(Icons.share_outlined),
        const SizedBox(width: 16),
        _buildActionIcon(Icons.chat_bubble_outline),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.grey.withValues(alpha: 0.6), size: 22),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () => context.pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4332),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text('نهاية المحاولة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ),
    );
  }
}
