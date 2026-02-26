import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

/// Quiz Service provider
final quizServiceProvider = Provider<QuizService>((ref) {
  return QuizService();
});

/// Daily Quiz provider
final dailyQuizProvider = FutureProvider<Quiz?>((ref) async {
  final quizService = ref.watch(quizServiceProvider);
  return await quizService.getDailyQuiz();
});

/// Quiz by ID provider
final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, id) async {
  final quizService = ref.watch(quizServiceProvider);
  return await quizService.getQuizById(id);
});

/// Quiz session state
class QuizSessionState {
  final QuizSession? session;
  final List<int?> userAnswers;
  final int currentQuestionIndex;
  final bool isCompleted;
  final QuizResult? result;
  final bool isLoading;
  final String? error;

  QuizSessionState({
    this.session,
    this.userAnswers = const [],
    this.currentQuestionIndex = 0,
    this.isCompleted = false,
    this.result,
    this.isLoading = false,
    this.error,
  });

  QuizSessionState copyWith({
    QuizSession? session,
    List<int?>? userAnswers,
    int? currentQuestionIndex,
    bool? isCompleted,
    QuizResult? result,
    bool? isLoading,
    String? error,
  }) {
    return QuizSessionState(
      session: session ?? this.session,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Get current question
  Question? get currentQuestion {
    if (session == null) return null;
    if (currentQuestionIndex >= session!.questions.length) return null;
    return session!.questions[currentQuestionIndex];
  }

  /// Get total questions
  int get totalQuestions => session?.questions.length ?? 0;

  /// Get answered count
  int get answeredCount => userAnswers.where((a) => a != null).length;

  /// Check if all questions answered
  bool get allQuestionsAnswered {
    if (session == null) return false;
    return userAnswers.length >= totalQuestions &&
           userAnswers.every((a) => a != null);
  }
}

/// Quiz Session Notifier
class QuizSessionNotifier extends StateNotifier<QuizSessionState> {
  final QuizService _quizService;

  QuizSessionNotifier(this._quizService) : super(QuizSessionState());

  /// Start a quiz session
  Future<void> startQuiz(String quizId, {String? categoryId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _quizService.startQuiz(quizId, categoryId: categoryId);
      if (session != null) {
        state = QuizSessionState(
          session: session,
          userAnswers: List<int?>.filled(session.questions.length, null),
          currentQuestionIndex: 0,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to start quiz');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Set answer for current question
  void setAnswer(int answerIndex) {
    if (state.currentQuestionIndex >= state.userAnswers.length) return;

    final newAnswers = List<int?>.from(state.userAnswers);
    newAnswers[state.currentQuestionIndex] = answerIndex;

    state = state.copyWith(userAnswers: newAnswers);
  }

  /// Go to next question
  void nextQuestion() {
    if (state.currentQuestionIndex < state.totalQuestions - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  /// Go to previous question
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  /// Jump to specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < state.totalQuestions) {
      state = state.copyWith(currentQuestionIndex: index);
    }
  }

  /// Submit quiz
  Future<bool> submitQuiz({required int timeSpent}) async {
    if (state.session == null) return false;
    if (!state.allQuestionsAnswered) return false;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final answers = state.userAnswers.cast<int>();
      final result = await _quizService.submitQuiz(
        state.session!.quizId,
        answers: answers,
        timeSpent: timeSpent,
      );

      if (result != null) {
        state = state.copyWith(
          result: result,
          isCompleted: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to submit quiz');
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Reset quiz session
  void resetQuiz() {
    state = QuizSessionState();
  }
}

/// Quiz Session State Provider (by quiz ID)
final quizSessionProvider = StateNotifierProvider.family<QuizSessionNotifier, QuizSessionState, String>((ref, quizId) {
  final quizService = ref.watch(quizServiceProvider);
  return QuizSessionNotifier(quizService);
});

/// Quiz history provider
final quizHistoryProvider = FutureProvider.autoDispose<List<QuizHistoryItem>>((ref) async {
  final quizService = ref.watch(quizServiceProvider);
  return await quizService.getQuizHistory();
});
