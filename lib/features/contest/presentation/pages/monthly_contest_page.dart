import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MonthlyContestPage extends StatefulWidget {
  const MonthlyContestPage({super.key});

  @override
  State<MonthlyContestPage> createState() => _MonthlyContestPageState();
}

class _MonthlyContestPageState extends State<MonthlyContestPage> {
  bool _isIntro = true;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  final Set<int> _answeredIndices = {};
  final Set<int> _correctIndices = {};
  int _secondsRemaining = 6000; // 100 minutes
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'من هو الإمام الأول للشيعة الإمامية؟',
      'options': ['الإمام علي بن أبي طالب (ع)', 'الإمام الحسن (ع)', 'الإمام الحسين (ع)', 'الإمام زين العابدين (ع)'],
      'correctIndex': 0,
    },
    {
      'question': 'كم عدد الأئمة المعصومين عليهم السلام؟',
      'options': ['10', '11', '12', '13'],
      'correctIndex': 2,
    },
    {
      'question': 'في أي مدينة استشهد الإمام علي (ع)؟',
      'options': ['الكوفة', 'المدينة', 'مكة', 'بغداد'],
      'correctIndex': 0,
    },
    {
      'question': 'ما هو لقب الإمام الحسن (ع)؟',
      'options': ['الباقر', 'المجتبى', 'الصادق', 'الكاظم'],
      'correctIndex': 1,
    },
  ];

  void _startContest() {
    setState(() {
      _isIntro = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer?.cancel();
        _endContest();
      }
    });
  }

  void _handleAnswer(int index) {
    if (_answeredIndices.contains(_currentQuestionIndex)) return;

    setState(() {
      _selectedAnswerIndex = index;
      _answeredIndices.add(_currentQuestionIndex);
      if (index == _questions[_currentQuestionIndex]['correctIndex']) {
        _correctIndices.add(_currentQuestionIndex);
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
      });
    } else {
      _endContest();
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswerIndex = null;
      });
    }
  }

  void _endContest() {
    _timer?.cancel();
    context.pushReplacement('/results', extra: {
      'score': _correctIndices.length,
      'total': _questions.length,
      'xp': _correctIndices.length * 15,
    });
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isIntro) return _buildIntro();
    return _buildActiveContest();
  }

  Widget _buildIntro() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المسابقة الشهرية',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [const Color(0xFF10B981), const Color(0xFF0F4C36)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sapphireBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'مسابقة شهر رمضان',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اختبر معلوماتك الشيعية الكبرى',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Cairo'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildIntroInfoItem(Icons.auto_awesome_outlined, 'عدد الأسئلة', '100 سؤال شامل', const Color(0xFFE3F2FD), AppColors.sapphireBlue),
            const SizedBox(height: 16),
            _buildIntroInfoItem(Icons.access_time, 'الوقت المتاح', '100 دقيقة (دقيقة لكل سؤال)', const Color(0xFFF3E5F5), AppColors.deepPurple),
            const SizedBox(height: 16),
            _buildIntroInfoItem(Icons.workspace_premium_outlined, 'الجائزة', 'عند إكمال المسابقة 1500 XP', const Color(0xFFFFF8E1), AppColors.goldenYellow),
            const SizedBox(height: 16),
            _buildIntroInfoItem(Icons.star_outline, 'المواضيع', 'الأئمة، أصول الدين، كربلاء، المراقد', const Color(0xFFE8F5E9), AppColors.emeraldGreen),
            
            const SizedBox(height: 32),
            Text(
              'تعليمات المسابقة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 16),
            _buildInstructionItem('اقرأ كل سؤال بتمعن قبل الإجابة'),
            _buildInstructionItem('يمكنك الانتقال بين الأسئلة'),
            _buildInstructionItem('راقب الوقت المتبقي في أعلى الشاشة'),
            _buildInstructionItem('لا يمكن تغيير الإجابة بعد اختيارها'),
            _buildInstructionItem('أكمل جميع الأسئلة للحصول على الجائزة الكاملة'),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startContest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sapphireBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'ابدأ المسابقة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildFooterStat(Icons.calendar_today_outlined, 'تنتهي في', '30 رجب')),
                const SizedBox(width: 16),
                Expanded(child: _buildFooterStat(Icons.emoji_events_outlined, 'المشاركون', '2,847')),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroInfoItem(IconData icon, String label, String value, Color bgColor, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, fontFamily: 'Cairo')),
               Text(value, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, fontFamily: 'Cairo')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.sapphireBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface, fontFamily: 'Cairo'))),
        ],
      ),
    );
  }

  Widget _buildFooterStat(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.sapphireBlue, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, fontFamily: 'Cairo')),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildActiveContest() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final question = _questions[_currentQuestionIndex];
    final bool isAnswered = _answeredIndices.contains(_currentQuestionIndex);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_formatTime(_secondsRemaining), style: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurface)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: _endContest,
            child: const Text('إنهاء', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _answeredIndices.length / _questions.length,
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                minHeight: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('سؤال ${_currentQuestionIndex + 1} من ${_questions.length}', style: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurface)),
                    Text('تمت الإجابة: ${_answeredIndices.length}', style: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurface)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
              ),
              child: Text(
                question['question'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: question['options'].length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildOption(index, question);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentQuestionIndex > 0 ? _prevQuestion : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('السابق', style: TextStyle(fontFamily: 'Cairo')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAnswered ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: isAnswered ? AppColors.sapphireBlue : Colors.grey,
                    ),
                    child: Text(_currentQuestionIndex < _questions.length - 1 ? 'التالي' : 'النهائي', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, Map<String, dynamic> question) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isAnswered = _answeredIndices.contains(_currentQuestionIndex);
    final bool isCorrect = index == question['correctIndex'];
    final bool isSelected = _selectedAnswerIndex == index;

    Color borderColor = colorScheme.onSurface.withValues(alpha: 0.1);
    Color bgColor = colorScheme.surface;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.emeraldGreen;
        bgColor = AppColors.emeraldGreen.withValues(alpha: 0.1);
      } else if (isSelected) {
        borderColor = AppColors.errorRed;
        bgColor = AppColors.errorRed.withValues(alpha: 0.1);
      }
    }

    return InkWell(
      onTap: () => _handleAnswer(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                question['options'][index],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
              ),
            ),
            if (isAnswered && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.emeraldGreen)
            else if (isAnswered && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.errorRed),
          ],
        ),
      ),
    );
  }
}
