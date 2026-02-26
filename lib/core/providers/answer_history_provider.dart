import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/answer_history.dart';
import '../services/answer_history_service.dart';

/// Answer History Service provider
final answerHistoryServiceProvider = Provider<AnswerHistoryService>((ref) {
  return AnswerHistoryService();
});

/// Answer History State
class AnswerHistoryState {
  final List<AnswerHistory> history;
  final List<AnswerHistory> incorrectAnswers;
  final AnswerStats? stats;
  final bool isLoading;
  final String? error;

  AnswerHistoryState({
    this.history = const [],
    this.incorrectAnswers = const [],
    this.stats,
    this.isLoading = false,
    this.error,
  });

  AnswerHistoryState copyWith({
    List<AnswerHistory>? history,
    List<AnswerHistory>? incorrectAnswers,
    AnswerStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return AnswerHistoryState(
      history: history ?? this.history,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Answer History Notifier
class AnswerHistoryNotifier extends StateNotifier<AnswerHistoryState> {
  final AnswerHistoryService _answerHistoryService;

  AnswerHistoryNotifier(this._answerHistoryService) : super(AnswerHistoryState());

  /// Load my answer history
  Future<void> loadMyHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final history = await _answerHistoryService.getMyHistory();
      state = state.copyWith(
        history: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load my stats
  Future<void> loadMyStats() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stats = await _answerHistoryService.getMyStats();
      state = state.copyWith(
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load incorrect answers
  Future<void> loadIncorrectAnswers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final incorrectAnswers = await _answerHistoryService.getIncorrectAnswers();
      state = state.copyWith(
        incorrectAnswers: incorrectAnswers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Get question stats
  Future<QuestionStats?> getQuestionStats(String questionId) async {
    try {
      return await _answerHistoryService.getQuestionStats(questionId);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  /// Record an answer
  Future<bool> recordAnswer(RecordAnswerDto dto) async {
    try {
      await _answerHistoryService.recordAnswer(dto);
      // Refresh stats after recording
      await loadMyStats();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Load all data (history + stats + incorrect)
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _answerHistoryService.getMyHistory(),
        _answerHistoryService.getMyStats(),
        _answerHistoryService.getIncorrectAnswers(),
      ]);
      state = AnswerHistoryState(
        history: results[0] as List<AnswerHistory>,
        stats: results[1] as AnswerStats,
        incorrectAnswers: results[2] as List<AnswerHistory>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Refresh
  Future<void> refresh() => loadAll();
}

/// Answer History State Provider
final answerHistoryStateProvider = StateNotifierProvider<AnswerHistoryNotifier, AnswerHistoryState>((ref) {
  final answerHistoryService = ref.watch(answerHistoryServiceProvider);
  return AnswerHistoryNotifier(answerHistoryService);
});

/// Answer history provider
final answerHistoryProvider = Provider<List<AnswerHistory>>((ref) {
  return ref.watch(answerHistoryStateProvider).history;
});

/// Incorrect answers provider
final incorrectAnswersProvider = Provider<List<AnswerHistory>>((ref) {
  return ref.watch(answerHistoryStateProvider).incorrectAnswers;
});

/// Answer stats provider
final answerStatsProvider = Provider<AnswerStats?>((ref) {
  return ref.watch(answerHistoryStateProvider).stats;
});
