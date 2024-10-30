import 'package:consys_coding_challenge/src/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'.hardcoded),
        ),
      ),
    );
  }
}
