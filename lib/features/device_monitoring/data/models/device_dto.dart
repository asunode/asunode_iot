import '../../../../core/enums/device_type.dart';
import '../../domain/entities/device.dart';

class DeviceDTO {
  final String id;
  final String ip;
  final String name;
  final String type;
  final List<String> capabilities;
  final bool isActive;
  final String? deviceCategory;

  DeviceDTO({
    required this.id,
    required this.ip,
    required this.name,
    required this.type,
    required this.capabilities,
    required this.isActive,
    this.deviceCategory,
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
      deviceCategory: json['deviceCategory'] as String?,
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
      'deviceCategory': deviceCategory,
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
      deviceCategory: DeviceCategoryExtension.fromString(deviceCategory),
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
      deviceCategory: device.deviceCategory.toJsonString(),
    );
  }
}
