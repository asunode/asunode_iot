import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'core/constants/app_constants.dart';
import 'features/device_monitoring/presentation/providers/device_list_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // TEST: İlk çalıştırmada örnek cihazları ekle
  if (!prefs.containsKey('devices')) {
    final testDevices = [
      {
        'id': '192.168.55.20',
        'ip': '192.168.55.20',
        'name': 'ESP32-C6 Salon',
        'type': 'esp32c6',
        'capabilities': ['relay_1', 'relay_2', 'temperature', 'humidity', 'motion'],
        'isActive': true,
      },
      {
        'id': '192.168.55.29',
        'ip': '192.168.55.29',
        'name': 'ESP8266 Mutfak',
        'type': 'esp8266',
        'capabilities': ['relay_1', 'relay_2'],
        'isActive': true,
      },
    ];
    await prefs.setString('devices', jsonEncode(testDevices));
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(AppConstants.windowWidth, AppConstants.windowHeight),
      minimumSize: Size(AppConstants.minimumWidth, AppConstants.minimumHeight),
      center: true,
      title: AppConstants.appName,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AsuNodeApp(),
    ),
  );
}
