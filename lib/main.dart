import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: EdencrewAssignmentApp()));
}

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '이든크루 평가 과제',
      theme: AppTheme.dark,
      home: const MainScreen(),
    );
  }
}
