class PowerMonitorModel {
  final double currentAmps;
  final int lastUpdated;
  final double previousAmps;

  PowerMonitorModel({
    required this.currentAmps,
    required this.lastUpdated,
    required this.previousAmps,
  });

  factory PowerMonitorModel.fromJson(Map<String, dynamic> json) {
    return PowerMonitorModel(
      currentAmps: (json['current_amps'] ?? 0).toDouble(),
      lastUpdated: json['last_updated'] ?? 0,
      previousAmps: (json['previous_amps'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_amps': currentAmps,
      'last_updated': lastUpdated,
      'previous_amps': previousAmps,
    };
  }

  bool get hasPowerOutage => currentAmps < 0.001;

  String get lastUpdatedTime {
    if (lastUpdated == 0) return 'Never';
    final date = DateTime.fromMillisecondsSinceEpoch(lastUpdated * 1000);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
