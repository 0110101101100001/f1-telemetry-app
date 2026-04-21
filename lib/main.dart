import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
      home: const HomeScreen(),
    );
  }
}