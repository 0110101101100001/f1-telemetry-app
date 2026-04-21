import 'dart:async';

// Usando sealed class do Dart 3 para Pattern Matching perfeito na UI
sealed class TelemetryEvent {}

class LapStarted extends TelemetryEvent {
  final double predictedTime;
  LapStarted({required this.predictedTime});
}

class TelemetryUpdate extends TelemetryEvent {
  final String time;
  final int speed;
  final String sector;
  final int rpm;
  final int gear;
  final double tireTemp;

  TelemetryUpdate({
    required this.time,
    required this.speed,
    required this.sector,
    required this.rpm,
    required this.gear,
    required this.tireTemp,
  });
}

class LapCompleted extends TelemetryEvent {
  final Duration finalDuration;
  final int maxSpeed;
  final double avgTemp;

  LapCompleted({
    required this.finalDuration,
    required this.maxSpeed,
    required this.avgTemp,
  });
}

class ApiService {
  Stream<TelemetryEvent> startLapStream() async* {
    // 1. Fase de Aquecimento
    yield LapStarted(predictedTime: 71.250); // Interlagos pole time ~1:11s
    await Future.delayed(const Duration(seconds: 2));

    double elapsed = 0.0;
    int currentSpeed = 80;
    
    // 2. Volta Rápida (Loop a ~30 FPS para mostrar milésimos fluidos)
    while (elapsed < 71.250) {
      await Future.delayed(const Duration(milliseconds: 33));
      elapsed += 0.033;

      // Simulação simples de aceleração/frenagem
      currentSpeed = (currentSpeed + (elapsed % 3 < 1.5 ? 4 : -2)).clamp(70, 330);
      int currentGear = (currentSpeed / 42).ceil().clamp(1, 8);
      int currentRpm = 6000 + ((currentSpeed % 42) * 150).toInt();
      String currentSector = elapsed < 20 ? "S1" : (elapsed < 45 ? "S2" : "S3");

      yield TelemetryUpdate(
        time: _formatF1Time(elapsed),
        speed: currentSpeed,
        sector: currentSector,
        rpm: currentRpm,
        gear: currentGear,
        tireTemp: 90.0 + (currentSpeed / 12),
      );
    }

    // 3. Fim da volta
    yield LapCompleted(
      finalDuration: const Duration(seconds: 71, milliseconds: 250),
      maxSpeed: 330,
      avgTemp: 104.5,
    );
  }

  // Formata o double para MM:SS.mmm
  // Formata o double para MM:SS.mmm ou S.mmm (ex: 1.000)
  String _formatF1Time(double timeInSeconds) {
    int minutes = (timeInSeconds / 60).floor();
    int seconds = (timeInSeconds % 60).floor();
    // Arredondamento seguro para evitar imprecisão de ponto flutuante no Dart
    int milliseconds = ((timeInSeconds * 1000) % 1000).toInt();

    String msStr = milliseconds.toString().padLeft(3, '0');

    if (minutes > 0) {
      // Se passou de 1 minuto, mantém o padrão F1 (ex: 1:05.250)
      String sStr = seconds.toString().padLeft(2, '0');
      return "$minutes:$sStr.$msStr";
    } else {
      // Menos de 1 minuto, exibe direto sem zero à esquerda (ex: 1.000, 12.300)
      return "$seconds.$msStr";
    }
  }
}