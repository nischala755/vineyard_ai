import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/scan/presentation/camera_screen.dart';
import 'features/scan/presentation/prediction_screen.dart';
import 'features/shell/presentation/shell_screen.dart';

class VineGuardApp extends StatefulWidget {
  const VineGuardApp({super.key});
  @override
  State<VineGuardApp> createState() => _VineGuardAppState();
}

class _VineGuardAppState extends State<VineGuardApp> {
  static const _onboardedKey = 'onboarded';
  static const _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(initialLocation: '/onboarding', routes: [
      GoRoute(
          path: '/',
          builder: (_, __) => ShellScreen(
              themeMode: _themeMode, onThemeChanged: _setThemeMode)),
      GoRoute(
          path: '/onboarding',
          builder: (_, __) =>
              OnboardingScreen(onComplete: _completeOnboarding)),
      GoRoute(path: '/camera', builder: (_, __) => const CameraScreen()),
      GoRoute(
          path: '/prediction',
          builder: (_, state) =>
              PredictionScreen(imagePath: state.extra! as String)),
    ]);
    _restoreSettings();
  }

  Future<void> _restoreSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);
    if (mounted) {
      setState(() => _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == value,
          orElse: () => ThemeMode.system));
      if (prefs.getBool(_onboardedKey) ?? false) _router.go('/');
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
    if (mounted) _router.go('/');
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'VineGuard AI',
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff2E7D32)),
            useMaterial3: true),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff81C784),
                brightness: Brightness.dark),
            useMaterial3: true),
        themeMode: _themeMode,
        routerConfig: _router,
      );
}
