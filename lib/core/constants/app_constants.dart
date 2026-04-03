class AppConstants {
  AppConstants._();

  // Uygulama Bilgileri
  static const String appName = 'ASUNODE IoT';
  static const String appVersion = '1.0.0';

  // Window Ayarları
  static const double windowWidth = 1600.0;
  static const double windowHeight = 1000.0;
  static const double minimumWidth = 1280.0;
  static const double minimumHeight = 720.0;

  // Border Radius (Neumorphic Design)
  static const double radiusCard = 32.0;
  static const double radiusButton = 16.0;
  static const double radiusInput = 12.0;
  static const double radiusSmall = 8.0;

  // Padding & Spacing
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Grid Layout
  static const int deviceGridColumns = 3;
  static const double deviceCardAspectRatio = 1.8;
  static const double gridSpacing = 12.0;

  // Shadow Offsets (Neumorphic)
  static const double shadowOffsetConvex = 6.0;
  static const double shadowBlurConvex = 16.0;
  static const double shadowOffsetConcave = 4.0;
  static const double shadowBlurConcave = 8.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Data Management
  static const int maxLogEntries = 100;
  static const int maxDeviceLogEntries = 10;
  static const Duration cacheExpiry = Duration(minutes: 5);

  // Storage Keys
  static const String keyDevices = 'devices';
  static const String keySettings = 'settings';
  static const String keyThemeMode = 'theme_mode';
}
