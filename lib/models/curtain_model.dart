class CurtainModel {
  final int actual;
  final String cmd;
  final int position;
  final String state;
  final String status;
  final int value;

  CurtainModel({
    required this.actual,
    required this.cmd,
    required this.position,
    required this.state,
    required this.status,
    required this.value,
  });

  factory CurtainModel.fromJson(Map<String, dynamic> json) {
    return CurtainModel(
      actual: json['actual'] ?? 0,
      cmd: json['cmd'] ?? '',
      position: json['position'] ?? 0,
      state: json['state'] ?? 'unknown',
      status: json['status'] ?? 'unknown',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actual': actual,
      'cmd': cmd,
      'position': position,
      'state': state,
      'status': status,
      'value': value,
    };
  }

  bool get isOpen => state == 'open';
  bool get isClosed => state == 'closed';
  bool get isMoving => status != 'stopped';
}
