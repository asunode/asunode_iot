import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/device.dart';
import '../../domain/usecases/get_all_devices.dart';
import '../../domain/repositories/device_repository.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/data_sources/esp_remote_data_source.dart';
import '../../data/data_sources/device_local_data_source.dart';
import '../../../../shared/services/ping_service.dart';

// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

// Repository provider
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl(
    remoteDataSource: ESPRemoteDataSource(client: http.Client()),
    localDataSource: DeviceLocalDataSource(
      prefs: ref.watch(sharedPreferencesProvider),
    ),
    pingService: PingService(),
  );
});

// GetAllDevices use case provider
final getAllDevicesProvider = Provider<GetAllDevices>((ref) {
  return GetAllDevices(ref.watch(deviceRepositoryProvider));
});

// Device list state provider
final deviceListProvider =
    StateNotifierProvider<DeviceListNotifier, AsyncValue<List<Device>>>((ref) {
  final getAllDevices = ref.watch(getAllDevicesProvider);
  return DeviceListNotifier(getAllDevices);
});

class DeviceListNotifier extends StateNotifier<AsyncValue<List<Device>>> {
  final GetAllDevices getAllDevices;

  DeviceListNotifier(this.getAllDevices) : super(const AsyncValue.loading()) {
    loadDevices();
  }

  Future<void> loadDevices() async {
    state = const AsyncValue.loading();
    final result = await getAllDevices();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (devices) => state = AsyncValue.data(devices),
    );
  }

  Future<void> refresh() => loadDevices();
}
