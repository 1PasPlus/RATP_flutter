import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tableau de Bord',
        debugShowCheckedModeBanner: false, // Désactive la bannière "Debug"

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Dashboard());
  }
}
