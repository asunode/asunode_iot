import '../../domain/entities/device_status.dart';
import '../../domain/entities/sensor_data.dart';

class StatusDTO {
  final String deviceId;
  final String deviceIp;
  final String status;
  final Map<String, String>? relays;
  final Map<String, dynamic>? sensors;
  final String? deviceName;
  final String? mac;

  StatusDTO({
    required this.deviceId,
    required this.deviceIp,
    required this.status,
    this.relays,
    this.sensors,
    this.deviceName,
    this.mac,
  });

  factory StatusDTO.fromJson(Map<String, dynamic> json) {
    return StatusDTO(
      deviceId: json['deviceIp'] as String,
      deviceIp: json['deviceIp'] as String,
      status: json['status'] as String,
      relays: json['relays'] != null
          ? Map<String, String>.from(json['relays'] as Map)
          : null,
      sensors: json['sensors'] as Map<String, dynamic>?,
      deviceName: json['deviceName'] as String?,
      mac: json['mac'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceIp': deviceIp,
      'status': status,
      if (relays != null) 'relays': relays,
      if (sensors != null) 'sensors': sensors,
      if (deviceName != null) 'deviceName': deviceName,
      if (mac != null) 'mac': mac,
    };
  }

  DeviceStatus toEntity({required int pingLatency}) {
    final relayMap = <String, RelayState>{};
    if (relays != null) {
      relays!.forEach((key, value) {
        relayMap[key] = value == 'on' ? RelayState.on : RelayState.off;
      });
    }

    SensorData? sensorData;
    if (sensors != null) {
      sensorData = SensorData(
        motion: sensors!['motion'] as String?,
        temperature: sensors!['temperature'] != null
            ? (sensors!['temperature'] as num).toDouble()
            : null,
        humidity: sensors!['humidity'] != null
            ? (sensors!['humidity'] as num).toDouble()
            : null,
      );
    }

    return DeviceStatus(
      deviceId: deviceId,
      isOnline: status == 'online',
      pingLatency: pingLatency,
      lastSeen: DateTime.now(),
      relays: relayMap,
      sensors: sensorData,
      macAddress: mac,
    );
  }
}
