import 'package:flutter/material.dart';
import 'package:test_web/presentation/test_web/pages/test_web.dart';

final class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black87,
      ),
      home: const TestWeb(),
    );
  }
}
