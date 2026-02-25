import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../services/question_service.dart';

/// Question Service provider
final questionServiceProvider = Provider<QuestionService>((ref) {
  return QuestionService();
});

/// Questions State
class QuestionsState {
  final List<Question> questions;
  final bool isLoading;
  final String? error;

  QuestionsState({
    this.questions = const [],
    this.isLoading = false,
    this.error,
  });

  QuestionsState copyWith({
    List<Question>? questions,
    bool? isLoading,
    String? error,
  }) {
    return QuestionsState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Questions Notifier
class QuestionsNotifier extends StateNotifier<QuestionsState> {
  final QuestionService _questionService;

  QuestionsNotifier(this._questionService) : super(QuestionsState());

  /// Load questions with optional filters
  Future<void> loadQuestions({
    String? categoryId,
    QuestionDifficulty? difficulty,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions = await _questionService.getQuestions(
        categoryId: categoryId,
        difficulty: difficulty,
      );
      state = QuestionsState(
        questions: questions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Clear questions
  void clearQuestions() {
    state = QuestionsState();
  }
}

/// Questions State Provider (with optional filters)
final questionsStateProvider = StateNotifierProvider.family<QuestionsNotifier, QuestionsState, ({
  String? categoryId,
  QuestionDifficulty? difficulty,
})?>((ref, filters) {
  final questionService = ref.watch(questionServiceProvider);
  final notifier = QuestionsNotifier(questionService);

  // Load questions when filters change
  if (filters != null) {
    notifier.loadQuestions(
      categoryId: filters.categoryId,
      difficulty: filters.difficulty,
    );
  }

  return notifier.state;
});

/// Questions list provider
final questionsProvider = Provider<List<Question>>((ref) {
  return ref.watch(questionsStateProvider(null)).questions;
});

/// Daily question provider
final dailyQuestionProvider = FutureProvider<DailyQuestion?>((ref) async {
  final questionService = ref.watch(questionServiceProvider);
  return await questionService.getDailyQuestion();
});

/// Question stats provider
final questionStatsProvider = FutureProvider<QuestionStats?>((ref) async {
  final questionService = ref.watch(questionServiceProvider);
  return await questionService.getQuestionStats();
});

/// Question by ID provider
final questionByIdProvider = FutureProvider.family<Question, String>((ref, id) async {
  final questionService = ref.watch(questionServiceProvider);
  return await questionService.getQuestionById(id);
});
