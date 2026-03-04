import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [ChangeNotifier] that GoRouter listens to for auth state changes.
/// Call [notifyAuthChanged] after login/logout so the router re-evaluates
/// the redirect guard.
class AuthChangeNotifier extends ChangeNotifier {
  static final AuthChangeNotifier _instance = AuthChangeNotifier._internal();
  factory AuthChangeNotifier() => _instance;
  AuthChangeNotifier._internal();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// Must be called once at app start to load the persisted token.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }

  /// Call this after a successful login to refresh the router.
  void onLogin() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Call this after logout to redirect to the login screen.
  void onLogout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
