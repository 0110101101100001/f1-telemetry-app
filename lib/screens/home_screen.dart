import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Stream<TelemetryEvent>? _telemetryStream;

  static const Color f1Red = Color(0xFFE10600);
  static const Color f1Dark = Color(0xFF15151E);
  static const Color f1Surface = Color(0xFF1F1F27);

  void _startSimulation() {
    setState(() {
      _telemetryStream = _apiService.startLapStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "F1 LIVE TELEMETRY",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: f1Dark,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: f1Red, height: 2),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [f1Dark, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_telemetryStream == null)
                Column(
                  children: [
                    const Icon(Icons.speed, color: f1Red, size: 80),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: "INICIAR VOLTA RÁPIDA", 
                      onPressed: _startSimulation
                    ),
                  ],
                )
              else
                StreamBuilder<TelemetryEvent>(
                  stream: _telemetryStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(color: f1Red);
                    }

                    return switch (snapshot.data!) {
                      LapStarted(:var predictedTime) => 
                        _buildStatusCard("AQUECENDO PNEUS", "TARGET: ${predictedTime.toStringAsFixed(3)}s", isWarning: true),
                      
                      TelemetryUpdate(:var time, :var speed, :var sector, :var rpm, :var gear, :var tireTemp) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildTelemetryHUD(time, sector, speed, rpm, gear, tireTemp),
                              const SizedBox(height: 40),
                              TextButton.icon(
                                icon: const Icon(Icons.close, color: Colors.white54),
                                label: const Text("ABORTAR VOLTA", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                                onPressed: () => setState(() => _telemetryStream = null),
                              ),
                            ],
                          ),
                        ),
                      
                      LapCompleted(:var finalDuration, :var maxSpeed, :var avgTemp) => 
                        Column(
                          children: [
                            _buildStatusCard(
                              "SESSÃO FINALIZADA", 
                              "TEMPO: 1:${finalDuration.inSeconds % 60}.${(finalDuration.inMilliseconds % 1000).toString().padLeft(3, '0')}\nTOP SPEED: $maxSpeed km/h\nTIRE AVG: ${avgTemp.toStringAsFixed(1)}°C"
                            ),
                            const SizedBox(height: 30),
                            CustomButton(label: "NOVA TENTATIVA", onPressed: _startSimulation),
                          ],
                        ),
                    };
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String subtitle, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: f1Surface,
        border: Border(left: BorderSide(color: isWarning ? Colors.amber : f1Red, width: 6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            subtitle, 
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1.3)
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryHUD(String time, String sector, int speed, int rpm, int gear, double temp) {
    // Separa os segundos dos milésimos para estilização
    final parts = time.split('.');
    final mainTime = parts[0];
    final millis = parts.length > 1 ? parts[1] : "000";

    return Column(
      children: [
        // Relógio principal On-Board
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: const BoxDecoration(
            color: f1Red,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(mainTime, style: const TextStyle(fontSize: 56, color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
              Text(".$millis", style: TextStyle(fontSize: 32, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Grid de telemetria
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: f1Surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _hudItem("SPEED", "$speed", "km/h"),
                  _hudItem("GEAR", "$gear", ""),
                  _hudItem("RPM", "$rpm", ""),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white10, thickness: 1, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _hudItem("SECTOR", sector, ""),
                  _hudItem("TIRE", temp.toStringAsFixed(1), "°C"),
                  _hudItem("DRIVER", "MAX 33", ""),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hudItem(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit, style: const TextStyle(color: f1Red, fontSize: 12, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        ],
      ),
    );
  }
}