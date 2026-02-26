import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Provider for managing app theme (light/dark mode)
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  // Load theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode') ?? false;
      state = isDarkMode;
    } catch (e) {
      // If loading fails, default to light mode
      state = false;
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newState = !state;
      state = newState;
      await prefs.setBool('isDarkMode', newState);
    } catch (e) {
      // If saving fails, still toggle the state
      state = !state;
    }
  }

  // Set theme directly
  Future<void> setTheme(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = isDarkMode;
      await prefs.setBool('isDarkMode', isDarkMode);
    } catch (e) {
      // If saving fails, still set the state
      state = isDarkMode;
    }
  }
}
