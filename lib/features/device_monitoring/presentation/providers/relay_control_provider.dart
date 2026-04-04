import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/device_repository.dart';
import 'device_list_provider.dart';

/// Relay kontrol provider - relay acma/kapama islemlerini yonetir
final relayControlProvider =
    StateNotifierProvider<RelayControlNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(deviceRepositoryProvider);
  return RelayControlNotifier(repository);
});

class RelayControlNotifier extends StateNotifier<AsyncValue<void>> {
  final DeviceRepository repository;

  RelayControlNotifier(this.repository) : super(const AsyncValue.data(null));

  /// Relay durumunu set et (true = ACIK, false = KAPALI)
  Future<bool> setRelay(String ip, String relayId, bool newState) async {
    state = const AsyncValue.loading();

    final result = await repository.setRelay(ip, relayId, newState);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        state = const AsyncValue.data(null);
        return success;
      },
    );
  }

  /// Relay toggle et (mevcut durumu tersine cevir)
  Future<bool> toggleRelay(String ip, String relayId) async {
    state = const AsyncValue.loading();

    final result = await repository.toggleRelay(ip, relayId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        state = const AsyncValue.data(null);
        return success;
      },
    );
  }
}
