import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class LessonPage extends StatefulWidget {
  final int lessonId;
  const LessonPage({super.key, required this.lessonId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'ما معنى التوحيد في المذهب الشيعي؟',
      'explanation': 'التوحيد هو الإيمان بوحدانية الله تعالى في ذاته وصفاته وأفعاله، وهو الأصل الأول من أصول الدين الخمسة',
      'options': ['الإيمان بالله فقط', 'وحدانية الله في ذاته وصفاته وأفعاله', 'عبادة الله', 'طاعة الله'],
      'correctIndex': 1
    },
    {
      'question': 'كم إله في الوجود؟',
      'explanation': 'الله واحد أحد لا شريك له، قال تعالى: "قُلْ هُوَ اللَّهُ أَحَدٌ"',
      'options': ['واحد', 'اثنان', 'ثلاثة', 'كثير'],
      'correctIndex': 0
    },
    {
      'question': 'ما هو أول أصول الدين الخمسة؟',
      'explanation': 'التوحيد هو الأصل الأول من أصول الدين الخمسة في المذهب الشيعي',
      'options': ['العدل', 'التوحيد', 'النبوة', 'الإمامة'],
      'correctIndex': 1
    },
  ];

  void _handleAnswer(int index) {
    if (_selectedAnswerIndex != null) return;

    setState(() {
      _selectedAnswerIndex = index;
      _showExplanation = true;
      if (index == _questions[_currentQuestionIndex]['correctIndex']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showExplanation = false;
      });
    } else {
      context.pushReplacement('/results', extra: {
        'score': _score,
        'total': _questions.length,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        title: const Text('أصول الدين: التوحيد'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.forestGreen),
            minHeight: 6,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: question['options'].length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildOption(index, question);
                  },
                ),
              ),
              if (_showExplanation) _buildExplanation(question),
              const SizedBox(height: 20),
              if (_selectedAnswerIndex != null)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _currentQuestionIndex < _questions.length - 1 ? 'السؤال التالي' : 'عرض النتيجة',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int index, Map<String, dynamic> question) {
    bool isSelected = _selectedAnswerIndex == index;
    bool isCorrect = index == question['correctIndex'];
    bool showResult = _selectedAnswerIndex != null;

    Color borderColor = Colors.grey[300]!;
    Color bgColor = Colors.white;
    Color textColor = AppColors.textDark;

    if (showResult) {
      if (isCorrect) {
        borderColor = AppColors.successGreen;
        bgColor = AppColors.successGreen.withValues(alpha: 0.1);
      } else if (isSelected) {
        borderColor = AppColors.errorRed;
        bgColor = AppColors.errorRed.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = AppColors.forestGreen;
    }

    return GestureDetector(
      onTap: () => _handleAnswer(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                question['options'][index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (showResult && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.successGreen)
            else if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.errorRed),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(Map<String, dynamic> question) {
    bool isCorrect = _selectedAnswerIndex == question['correctIndex'];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect 
            ? AppColors.successGreen.withValues(alpha: 0.1) 
            : AppColors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.error_outline,
                color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'إجابة صحيحة!' : 'إجابة خاطئة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question['explanation'],
            style: TextStyle(
              fontSize: 15,
              color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
