class NetworkConstants {
  NetworkConstants._();

  // Ağ Yapılandırması
  static const String networkSubnet = '192.168.55.0/24';
  static const String gateway = '192.168.55.1';
  static const int subnetMask = 24;

  // IP Aralıkları
  static const String deviceIpStart = '192.168.55.20';
  static const String deviceIpEnd = '192.168.55.29';
  static const String dashboardIp = '192.168.55.100';

  // API Yapılandırması
  static const int apiPort = 8080;
  static const String endpointStatus = '/status';
  static const String endpointCommand = '/command';

  // Timeout Ayarları
  static const Duration connectionTimeout = Duration(seconds: 2);
  static const Duration requestTimeout = Duration(seconds: 3);

  // Polling Ayarları
  static const Duration pollingInterval = Duration(seconds: 10);
  static const Duration retryDelay = Duration(seconds: 5);

  // Komut Doğrulama
  static const List<String> validActions = [
    'toggle',
    'open',
    'close',
    'read',
    'ping',
    'reboot',
    'reset',
  ];

  static const List<String> validRelayTargets = [
    'relay_1',
    'relay_2',
  ];
}
