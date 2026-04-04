import '../../../../core/enums/device_type.dart';

enum DeviceType {
  esp8266,
  esp32c6,
}

class Device {
  final String id;
  final String ip;
  final String name;
  final DeviceType type;
  final List<String> capabilities;
  final bool isActive;
  final DeviceCategory deviceCategory;

  Device({
    required this.id,
    required this.ip,
    required this.name,
    required this.type,
    required this.capabilities,
    this.isActive = true,
    this.deviceCategory = DeviceCategory.other,
  });

  Device copyWith({
    String? id,
    String? ip,
    String? name,
    DeviceType? type,
    List<String>? capabilities,
    bool? isActive,
    DeviceCategory? deviceCategory,
  }) {
    return Device(
      id: id ?? this.id,
      ip: ip ?? this.ip,
      name: name ?? this.name,
      type: type ?? this.type,
      capabilities: capabilities ?? this.capabilities,
      isActive: isActive ?? this.isActive,
      deviceCategory: deviceCategory ?? this.deviceCategory,
    );
  }

  @override
  String toString() =>
      'Device(id: $id, name: $name, ip: $ip, type: $type, category: $deviceCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Device &&
        other.id == id &&
        other.ip == ip &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, ip, name, type);
}
