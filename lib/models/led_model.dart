class LedModel {
  final String name;
  final int value;

  LedModel({
    required this.name,
    required this.value,
  });

  factory LedModel.fromJson(String name, dynamic json) {
    return LedModel(
      name: name,
      value: json is int ? json : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      name: value,
    };
  }

  bool get isOn => value == 1;
}
