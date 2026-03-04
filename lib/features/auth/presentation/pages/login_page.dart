import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/providers/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ref.read(authStateProvider.notifier).login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (mounted) setState(() => _isLoading = false);

    // On success: GoRouter's refreshListenable fires automatically → redirect to /
    if (!success && mounted) {
      final error = ref.read(authStateProvider).error ?? 'فشل تسجيل الدخول. تحقق من بياناتك.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Colors that adapt to theme
    final bgColor = isDark ? const Color(0xFF0D1F17) : AppColors.backgroundBeige;
    final cardColor = isDark ? const Color(0xFF1A2E20) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final subtitleColor = isDark ? Colors.white60 : AppColors.textLight;
    final fieldFillColor = isDark ? const Color(0xFF243B2B) : Colors.white;
    final fieldTextColor = isDark ? Colors.white : AppColors.textDark;
    final labelColor = isDark ? Colors.white54 : AppColors.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // ─── Top Bar: theme toggle ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Theme toggle button
                  GestureDetector(
                    onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                        color: isDark ? const Color(0xFFFFD700) : const Color(0xFFBCA371),
                        size: 24,
                      ),
                    ),
                  ),
                  // App name
                  Text(
                    'QuizeMobile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: subtitleColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ─── Logo ────────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B5E20).withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: AppNetworkImage(
                    url:
                        'https://images.unsplash.com/photo-1720549973451-018d3623b55a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxrYWFiYSUyMG1lY2NhfGVufDF8fHx8MTc2ODY1OTIzM3ww&ixlib=rb-4.1.0&q=80&w=1080',
                    width: 120,
                    height: 120,
                    borderRadius: BorderRadius.circular(36),
                    shimmerBaseColor: const Color(0xFF2E7D32),
                    shimmerHighlightColor: const Color(0xFF4CAF50),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─── Title ───────────────────────────────────────────────────
              Text(
                'مرحباً بك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ابدأ رحلتك في تعلم المعارف الإسلامية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: subtitleColor,
                  height: 1.5,
                  fontFamily: 'Cairo',
                ),
              ),

              const SizedBox(height: 32),

              // ─── Username / Password Form ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: fieldTextColor, fontFamily: 'Cairo'),
                        decoration: InputDecoration(
                          labelText: 'اسم المستخدم أو البريد الإلكتروني',
                          labelStyle: TextStyle(color: labelColor, fontFamily: 'Cairo'),
                          prefixIcon: Icon(Icons.person_outline_rounded, color: labelColor),
                          filled: true,
                          fillColor: fieldFillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'الرجاء إدخال اسم المستخدم' : null,
                      ),
                      const SizedBox(height: 14),
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: fieldTextColor, fontFamily: 'Cairo'),
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          labelStyle: TextStyle(color: labelColor, fontFamily: 'Cairo'),
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: labelColor),
                          filled: true,
                          fillColor: fieldFillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: labelColor,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: 20),
                      // Login button
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B4332),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1B4332).withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Divider ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: subtitleColor.withValues(alpha: 0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('أو', style: TextStyle(color: subtitleColor, fontSize: 14, fontFamily: 'Cairo')),
                  ),
                  Expanded(child: Divider(color: subtitleColor.withValues(alpha: 0.3))),
                ],
              ),

              const SizedBox(height: 20),

              // ─── Social Login ────────────────────────────────────────────
              _buildSocialButton(
                customIcon: SvgPicture.string(
                  '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="24" height="24">
                    <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                    <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
                    <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
                    <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
                  </svg>''',
                ),
                label: 'Google',
                bgColor: cardColor,
                textColor: textColor,
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _buildSocialButton(
                icon: Icons.apple,
                label: 'Apple',
                bgColor: isDark ? Colors.white12 : const Color(0xFF1A1A1A),
                textColor: isDark ? Colors.white : Colors.white,
                onTap: () {},
              ),

              const SizedBox(height: 12),

              // ─── Guest Button ─────────────────────────────────────────────
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await ref.read(authStateProvider.notifier).guestLogin();
                    if (mounted) setState(() => _isLoading = false);
                  },
                  icon: Icon(Icons.explore_outlined, color: isDark ? Colors.white70 : const Color(0xFF1B4332)),
                  label: Text(
                    'متابعة كضيف',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF1B4332),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white30 : const Color(0xFF1B4332).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ─── Footer ───────────────────────────────────────────────────
              Text(
                'بالمتابعة، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: subtitleColor, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    Widget? customIcon,
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (customIcon != null) customIcon,
            if (icon != null) Icon(icon, color: textColor, size: 26),
            const SizedBox(width: 10),
            Text(
              'تسجيل الدخول عبر $label',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
