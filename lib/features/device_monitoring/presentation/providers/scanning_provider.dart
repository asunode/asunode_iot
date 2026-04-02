import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_status.dart';
import '../../domain/usecases/scan_devices.dart';
import 'device_status_provider.dart';

// Scanning state
enum ScanningState { idle, scanning, completed, error }

class ScanningStatus {
  final ScanningState state;
  final Map<String, DeviceStatus> results;
  final String? errorMessage;
  final DateTime? lastScanTime;

  ScanningStatus({
    required this.state,
    this.results = const {},
    this.errorMessage,
    this.lastScanTime,
  });

  ScanningStatus copyWith({
    ScanningState? state,
    Map<String, DeviceStatus>? results,
    String? errorMessage,
    DateTime? lastScanTime,
  }) {
    return ScanningStatus(
      state: state ?? this.state,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
      lastScanTime: lastScanTime ?? this.lastScanTime,
    );
  }
}

// Scanning provider
final scanningProvider =
    StateNotifierProvider<ScanningNotifier, ScanningStatus>((ref) {
  final scanDevices = ref.watch(scanDevicesProvider);
  return ScanningNotifier(scanDevices);
});

class ScanningNotifier extends StateNotifier<ScanningStatus> {
  final ScanDevices scanDevices;

  ScanningNotifier(this.scanDevices)
      : super(ScanningStatus(state: ScanningState.idle));

  Future<void> scan() async {
    state = state.copyWith(state: ScanningState.scanning);

    final result = await scanDevices();

    result.fold(
      (failure) => state = ScanningStatus(
        state: ScanningState.error,
        errorMessage: failure.message,
        lastScanTime: DateTime.now(),
      ),
      (statuses) => state = ScanningStatus(
        state: ScanningState.completed,
        results: statuses,
        lastScanTime: DateTime.now(),
      ),
    );
  }

  void reset() {
    state = ScanningStatus(state: ScanningState.idle);
  }
}
