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
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    state = isDarkMode;
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool('isDarkMode', state);
  }

  // Set theme directly
  Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
