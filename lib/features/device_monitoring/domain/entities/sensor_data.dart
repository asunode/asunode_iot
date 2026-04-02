class SensorData {
  final String? motion;
  final double? temperature;
  final double? humidity;

  SensorData({
    this.motion,
    this.temperature,
    this.humidity,
  });

  bool get hasMotion => motion == 'detected';
  bool get isMotionClear => motion == 'clear';

  SensorData copyWith({
    String? motion,
    double? temperature,
    double? humidity,
  }) {
    return SensorData(
      motion: motion ?? this.motion,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }

  @override
  String toString() {
    final parts = <String>[];
    if (motion != null) parts.add('motion: $motion');
    if (temperature != null) parts.add('temp: ${temperature?.toStringAsFixed(1)}°C');
    if (humidity != null) parts.add('humidity: ${humidity?.toStringAsFixed(0)}%');
    return 'SensorData(${parts.join(', ')})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorData &&
        other.motion == motion &&
        other.temperature == temperature &&
        other.humidity == humidity;
  }

  @override
  int get hashCode => Object.hash(motion, temperature, humidity);
}
