import 'package:flutter/material.dart';
// 1. Troque a importação para a nova tela do seminário
import 'screens/seminar_screen.dart'; 

void main() {
  runApp(const F1TelemetryApp());
}

class F1TelemetryApp extends StatelessWidget {
  const F1TelemetryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Telemetry Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      // 2. Mude a rota inicial de HomeScreen para SeminarScreen
      home: const SeminarScreen(),
    );
  }
}