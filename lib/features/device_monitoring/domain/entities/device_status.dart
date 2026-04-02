import 'sensor_data.dart';

enum RelayState { on, off }

class DeviceStatus {
  final String deviceId;
  final bool isOnline;
  final int pingLatency;
  final DateTime lastSeen;
  final Map<String, RelayState> relays;
  final SensorData? sensors;
  final String? macAddress;

  DeviceStatus({
    required this.deviceId,
    required this.isOnline,
    required this.pingLatency,
    required this.lastSeen,
    required this.relays,
    this.sensors,
    this.macAddress,
  });

  bool isRelayActive(String relayId) {
    return relays[relayId] == RelayState.on;
  }

  DeviceStatus copyWith({
    String? deviceId,
    bool? isOnline,
    int? pingLatency,
    DateTime? lastSeen,
    Map<String, RelayState>? relays,
    SensorData? sensors,
    String? macAddress,
  }) {
    return DeviceStatus(
      deviceId: deviceId ?? this.deviceId,
      isOnline: isOnline ?? this.isOnline,
      pingLatency: pingLatency ?? this.pingLatency,
      lastSeen: lastSeen ?? this.lastSeen,
      relays: relays ?? this.relays,
      sensors: sensors ?? this.sensors,
      macAddress: macAddress ?? this.macAddress,
    );
  }

  @override
  String toString() =>
      'DeviceStatus(deviceId: $deviceId, isOnline: $isOnline, pingLatency: ${pingLatency}ms)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceStatus &&
        other.deviceId == deviceId &&
        other.isOnline == isOnline &&
        other.pingLatency == pingLatency;
  }

  @override
  int get hashCode => Object.hash(deviceId, isOnline, pingLatency);
}
