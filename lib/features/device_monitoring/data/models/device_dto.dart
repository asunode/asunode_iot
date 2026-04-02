import '../../domain/entities/device.dart';

class DeviceDTO {
  final String id;
  final String ip;
  final String name;
  final String type;
  final List<String> capabilities;
  final bool isActive;

  DeviceDTO({
    required this.id,
    required this.ip,
    required this.name,
    required this.type,
    required this.capabilities,
    required this.isActive,
  });

  factory DeviceDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDTO(
      id: json['id'] as String,
      ip: json['ip'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      capabilities: (json['capabilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip': ip,
      'name': name,
      'type': type,
      'capabilities': capabilities,
      'isActive': isActive,
    };
  }

  Device toEntity() {
    return Device(
      id: id,
      ip: ip,
      name: name,
      type: type == 'esp8266' ? DeviceType.esp8266 : DeviceType.esp32c6,
      capabilities: capabilities,
      isActive: isActive,
    );
  }

  factory DeviceDTO.fromEntity(Device device) {
    return DeviceDTO(
      id: device.id,
      ip: device.ip,
      name: device.name,
      type: device.type == DeviceType.esp8266 ? 'esp8266' : 'esp32c6',
      capabilities: device.capabilities,
      isActive: device.isActive,
    );
  }
}
