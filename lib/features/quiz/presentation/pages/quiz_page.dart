import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/models.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String? quizId;
  const QuizPage({super.key, this.quizId});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int _startTime = 0;
  String? _activeQuizId;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _activeQuizId = widget.quizId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_activeQuizId != null) {
        ref.read(quizSessionProvider(_activeQuizId!).notifier).startQuiz(_activeQuizId!);
      } else {
        // Load daily quiz
        final dailyQuiz = await ref.read(dailyQuizProvider.future);
        if (dailyQuiz != null && mounted) {
          setState(() {
            _activeQuizId = dailyQuiz.id;
          });
          ref.read(quizSessionProvider(_activeQuizId!).notifier).startQuiz(_activeQuizId!);
        }
      }
    });
  }

  void _handleAnswer(int index, String quizId) {
    ref.read(quizSessionProvider(quizId).notifier).setAnswer(index);
  }

  void _nextQuestion(String quizId, QuizSessionState sessionState) {
    if (sessionState.currentQuestionIndex < sessionState.totalQuestions - 1) {
      ref.read(quizSessionProvider(quizId).notifier).nextQuestion();
    } else {
      final timeSpent = (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;
      ref.read(quizSessionProvider(quizId).notifier).submitQuiz(timeSpent: timeSpent).then((success) {
        if (success) {
          final result = ref.read(quizSessionProvider(quizId)).result;
          context.pushReplacement('/results', extra: {
            'score': result?.correctAnswers ?? 0,
            'total': result?.total ?? sessionState.totalQuestions,
            'xp': result?.xpEarned ?? 0,
            'quizId': quizId,
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeQuizId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final sessionState = ref.watch(quizSessionProvider(_activeQuizId!));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (sessionState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (sessionState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('خطأ: ${sessionState.error}'),
              ElevatedButton(
                onPressed: () => ref.read(quizSessionProvider(_activeQuizId!).notifier).startQuiz(_activeQuizId!),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    final question = sessionState.currentQuestion;
    if (question == null) {
      return const Scaffold(body: Center(child: Text('لا يوجد أسئلة')));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, sessionState),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildQuizCard(_activeQuizId!, sessionState, question),
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
    );
  }

  Widget _buildHeader(BuildContext context, QuizSessionState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Text(
                  state.session?.quizId != null ? 'تحدي' : 'اختبار',
                  style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'),
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
              _buildCircleIcon(context, Icons.close_rounded, colorScheme.onSurface, onTap: () => context.pop()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(BuildContext context, IconData icon, Color color, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: theme.colorScheme.surface, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildQuizCard(String quizId, QuizSessionState sessionState, Question question) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.05),
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
                  'السؤال ${sessionState.currentQuestionIndex + 1} من ${sessionState.totalQuestions}',
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (question.imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppNetworkImage(
                url: question.imageUrl!,
                height: 180,
                width: double.infinity,
                borderRadius: BorderRadius.circular(24),
                shimmerBaseColor: const Color(0xFFE8F4EC),
                shimmerHighlightColor: const Color(0xFFF5FBF7),
              ),
            ),
          const SizedBox(height: 24),
          ...List.generate(question.options.length, (index) {
            return _buildOption(quizId, sessionState, index, question.options[index]);
          }),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: sessionState.userAnswers[sessionState.currentQuestionIndex] != null 
                    ? () => _nextQuestion(quizId, sessionState) 
                    : null,
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
                    Text(sessionState.currentQuestionIndex < sessionState.totalQuestions - 1 ? 'السؤال التالي' : 'عرض النتائج', 
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

  Widget _buildOption(String quizId, QuizSessionState state, int index, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = state.userAnswers[state.currentQuestionIndex] == index;
    
    Color bgColor = colorScheme.surface;
    Color textColor = colorScheme.onSurface;
    Border? border = Border.all(color: colorScheme.onSurface.withOpacity(0.1));

    if (isSelected) {
      bgColor = colorScheme.primary;
      textColor = Colors.white;
      border = null;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: InkWell(
        onTap: () => _handleAnswer(index, quizId),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.colorScheme.surface, shape: BoxShape.circle),
      child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 22),
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
