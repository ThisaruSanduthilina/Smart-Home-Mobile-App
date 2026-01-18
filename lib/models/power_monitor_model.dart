class PowerMonitorModel {
  final double currentAmps;
  final int lastUpdated;
  final double previousAmps;
  final List<PowerReading> historicalData;
  final double voltage;
  final double powerWatts;
  final double energyKwh;

  PowerMonitorModel({
    required this.currentAmps,
    required this.lastUpdated,
    required this.previousAmps,
    this.historicalData = const [],
    this.voltage = 230.0,
    this.powerWatts = 0.0,
    this.energyKwh = 0.0,
  });

  factory PowerMonitorModel.fromJson(Map<String, dynamic> json) {
    List<PowerReading> readings = [];

    // Parse historical data if available
    if (json['history'] != null) {
      final historyData = json['history'] as Map<dynamic, dynamic>;
      readings = historyData.entries.map((entry) {
        final data = entry.value as Map<dynamic, dynamic>;
        return PowerReading(
          timestamp: int.tryParse(entry.key.toString()) ?? 0,
          amps: (data['amps'] ?? 0).toDouble(),
          voltage: (data['voltage'] ?? 230.0).toDouble(),
          watts: (data['watts'] ?? 0).toDouble(),
        );
      }).toList();

      // Sort by timestamp
      readings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    final currentAmps = (json['current_amps'] ?? 0).toDouble();
    final voltage = (json['voltage'] ?? 230.0).toDouble();

    return PowerMonitorModel(
      currentAmps: currentAmps,
      lastUpdated: json['last_updated'] ?? 0,
      previousAmps: (json['previous_amps'] ?? 0).toDouble(),
      historicalData: readings,
      voltage: voltage,
      powerWatts: (json['power_watts'] ?? currentAmps * voltage),
      energyKwh: (json['energy_kwh'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_amps': currentAmps,
      'last_updated': lastUpdated,
      'previous_amps': previousAmps,
      'voltage': voltage,
      'power_watts': powerWatts,
      'energy_kwh': energyKwh,
    };
  }

  bool get hasPowerOutage => currentAmps < 0.001;

  String get lastUpdatedTime {
    if (lastUpdated == 0) return 'Never';
    final date = DateTime.fromMillisecondsSinceEpoch(lastUpdated * 1000);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}

class PowerReading {
  final int timestamp;
  final double amps;
  final double voltage;
  final double watts;

  PowerReading({
    required this.timestamp,
    required this.amps,
    required this.voltage,
    required this.watts,
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  String get timeString {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
