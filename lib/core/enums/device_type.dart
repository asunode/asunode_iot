/// Cihaz kategori enumerasyonu
enum DeviceCategory {
  /// Açma/kapama kontrolü (lamba, priz vb)
  switch_,

  /// Sadece sensör (sıcaklık, nem, hareket)
  sensor,

  /// İklim cihazı (klima, termostat)
  climate,

  /// Röle kontrol (çoklu relay)
  relay,

  /// Diğer/tanımsız
  other,
}

extension DeviceCategoryExtension on DeviceCategory {
  /// Türkçe görünen ad
  String get displayName {
    switch (this) {
      case DeviceCategory.switch_:
        return 'Anahtar';
      case DeviceCategory.sensor:
        return 'Sensör';
      case DeviceCategory.climate:
        return 'İklim';
      case DeviceCategory.relay:
        return 'Röle';
      case DeviceCategory.other:
        return 'Diğer';
    }
  }

  /// Icon
  String get icon {
    switch (this) {
      case DeviceCategory.switch_:
        return '💡';
      case DeviceCategory.sensor:
        return '📊';
      case DeviceCategory.climate:
        return '❄️';
      case DeviceCategory.relay:
        return '🔌';
      case DeviceCategory.other:
        return '📦';
    }
  }

  /// String'den parse
  static DeviceCategory fromString(String? value) {
    if (value == null) return DeviceCategory.other;
    switch (value.toLowerCase()) {
      case 'switch':
        return DeviceCategory.switch_;
      case 'sensor':
        return DeviceCategory.sensor;
      case 'climate':
        return DeviceCategory.climate;
      case 'relay':
        return DeviceCategory.relay;
      default:
        return DeviceCategory.other;
    }
  }

  /// String'e çevir
  String toJsonString() {
    switch (this) {
      case DeviceCategory.switch_:
        return 'switch';
      case DeviceCategory.sensor:
        return 'sensor';
      case DeviceCategory.climate:
        return 'climate';
      case DeviceCategory.relay:
        return 'relay';
      case DeviceCategory.other:
        return 'other';
    }
  }
}
