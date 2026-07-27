import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/scan/presentation/camera_screen.dart';
import 'features/scan/presentation/prediction_screen.dart';
import 'features/shell/presentation/shell_screen.dart';

class VineGuardApp extends StatelessWidget {
  const VineGuardApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'VineGuard AI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2E7D32)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff81C784), brightness: Brightness.dark),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        routerConfig: GoRouter(routes: [
          GoRoute(path: '/', builder: (_, __) => const ShellScreen()),
          GoRoute(path: '/camera', builder: (_, __) => const CameraScreen()),
          GoRoute(path: '/prediction', builder: (_, state) => PredictionScreen(imagePath: state.extra! as String)),
        ]),
      );
}
