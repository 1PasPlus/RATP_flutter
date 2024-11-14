import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tableau de Bord',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Dashboard());
  }
}
