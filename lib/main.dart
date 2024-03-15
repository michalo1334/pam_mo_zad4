import 'package:flutter/material.dart';
import 'package:mo_zad4/view/calculator_widget.dart';

import 'model/calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,

        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zadanie 4 - Kalkulator'),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: CalculatorWidget(initCalc: Calculator()),
      ),
    );
  }
}
