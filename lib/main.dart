import 'package:flutter/material.dart';
import 'package:hm_app/pages/page_meals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HM-App',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}
