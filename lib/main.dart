import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MaterialColor primaryColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tableau de Bord',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor).copyWith(
          secondary: Colors.tealAccent,
        ),
        fontFamily: 'Roboto',
      ),
      home: Dashboard(),
    );
  }
}
