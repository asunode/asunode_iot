import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/device_dto.dart';
import '../models/status_dto.dart';

class DeviceLocalDataSource {
  final SharedPreferences prefs;

  DeviceLocalDataSource({required this.prefs});

  static const _keyDevices = 'devices';
  static const _keyStatusPrefix = 'status_';

  /// Cihaz listesini cache'den al
  Future<List<DeviceDTO>> getCachedDevices() async {
    final jsonString = prefs.getString(_keyDevices);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => DeviceDTO.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Cihaz listesini cache'e yaz
  Future<void> cacheDevices(List<DeviceDTO> devices) async {
    final jsonString = jsonEncode(
      devices.map((d) => d.toJson()).toList(),
    );
    await prefs.setString(_keyDevices, jsonString);
  }

  /// Tek bir cihazı cache'e ekle veya güncelle
  Future<void> cacheDevice(DeviceDTO device) async {
    final devices = await getCachedDevices();
    final index = devices.indexWhere((d) => d.id == device.id);

    if (index >= 0) {
      devices[index] = device;
    } else {
      devices.add(device);
    }

    await cacheDevices(devices);
  }

  /// Cihaz durumunu cache'e yaz
  Future<void> cacheStatus(String deviceId, StatusDTO status) async {
    final key = '$_keyStatusPrefix$deviceId';
    final jsonString = jsonEncode(status.toJson());
    await prefs.setString(key, jsonString);
  }

  /// Cihaz durumunu cache'den al
  Future<StatusDTO?> getCachedStatus(String deviceId) async {
    final key = '$_keyStatusPrefix$deviceId';
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return StatusDTO.fromJson(json);
  }

  /// Tüm cache'i temizle
  Future<void> clearCache() async {
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key == _keyDevices || key.startsWith(_keyStatusPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
