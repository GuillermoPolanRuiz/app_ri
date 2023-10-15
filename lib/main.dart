import 'package:app_ri/screens/list.dart';
import 'package:app_ri/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recreativos Irati',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mainTheme,
      home: const ListScreen(),
    );
  }
}
