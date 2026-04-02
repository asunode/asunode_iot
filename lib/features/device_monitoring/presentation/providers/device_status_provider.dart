import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/constants/network_constants.dart';
import '../../domain/entities/device_status.dart';
import '../../domain/usecases/scan_devices.dart';
import 'device_list_provider.dart';

// ScanDevices use case provider
final scanDevicesProvider = Provider<ScanDevices>((ref) {
  return ScanDevices(ref.watch(deviceRepositoryProvider));
});

// Device status provider (family - her cihaz için ayrı)
final deviceStatusProvider = StateNotifierProvider.family<
    DeviceStatusNotifier, AsyncValue<DeviceStatus?>, String>(
  (ref, deviceId) {
    final scanDevices = ref.watch(scanDevicesProvider);
    return DeviceStatusNotifier(deviceId, scanDevices);
  },
);

class DeviceStatusNotifier extends StateNotifier<AsyncValue<DeviceStatus?>> {
  final String deviceId;
  final ScanDevices scanDevices;
  Timer? _pollingTimer;

  DeviceStatusNotifier(this.deviceId, this.scanDevices)
      : super(const AsyncValue.loading()) {
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    final result = await scanDevices();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (statuses) {
        final status = statuses[deviceId];
        state = AsyncValue.data(status);
      },
    );
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      NetworkConstants.pollingInterval,
      (_) => _fetchStatus(),
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> refresh() => _fetchStatus();

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
