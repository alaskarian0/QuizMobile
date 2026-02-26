import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reel.dart';
import '../services/reel_service.dart';

/// Reel Service provider
final reelServiceProvider = Provider<ReelService>((ref) {
  return ReelService();
});

/// Reels State
class ReelsState {
  final List<Reel> reels;
  final List<Reel> activeReels;
  final bool isLoading;
  final String? error;

  ReelsState({
    this.reels = const [],
    this.activeReels = const [],
    this.isLoading = false,
    this.error,
  });

  ReelsState copyWith({
    List<Reel>? reels,
    List<Reel>? activeReels,
    bool? isLoading,
    String? error,
  }) {
    return ReelsState(
      reels: reels ?? this.reels,
      activeReels: activeReels ?? this.activeReels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Reels Notifier
class ReelsNotifier extends StateNotifier<ReelsState> {
  final ReelService _reelService;

  ReelsNotifier(this._reelService) : super(ReelsState()) {
    loadActiveReels();
  }

  /// Load all reels
  Future<void> loadAllReels() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reels = await _reelService.getAllReels();
      state = state.copyWith(
        reels: reels,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load active reels
  Future<void> loadActiveReels() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final activeReels = await _reelService.getActiveReels();
      state = state.copyWith(
        activeReels: activeReels,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load reels by user
  Future<void> loadReelsByUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reels = await _reelService.getReelsByUser(userId);
      state = state.copyWith(
        reels: reels,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load my reels
  Future<void> loadMyReels() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reels = await _reelService.getMyReels();
      state = state.copyWith(
        reels: reels,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Create a new reel
  Future<bool> createReel(CreateReelDto dto) async {
    try {
      await _reelService.createReel(dto);
      await loadMyReels();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Update a reel
  Future<bool> updateReel(String id, UpdateReelDto dto) async {
    try {
      await _reelService.updateReel(id, dto);
      await loadMyReels();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Increment reel views
  Future<void> incrementViews(String id) async {
    try {
      await _reelService.incrementViews(id);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Delete a reel
  Future<bool> deleteReel(String id) async {
    try {
      await _reelService.deleteReel(id);
      await loadMyReels();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Refresh
  Future<void> refresh() => loadActiveReels();
}

/// Reels State Provider
final reelsStateProvider = StateNotifierProvider<ReelsNotifier, ReelsState>((ref) {
  final reelService = ref.watch(reelServiceProvider);
  return ReelsNotifier(reelService);
});

/// Active reels provider
final activeReelsProvider = Provider<List<Reel>>((ref) {
  return ref.watch(reelsStateProvider).activeReels;
});

/// My reels provider
final myReelsProvider = Provider<List<Reel>>((ref) {
  return ref.watch(reelsStateProvider).reels;
});
