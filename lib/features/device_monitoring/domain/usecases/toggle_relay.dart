import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/device_repository.dart';

class ToggleRelay {
  final DeviceRepository repository;

  ToggleRelay(this.repository);

  Future<Either<Failure, bool>> call(ToggleRelayParams params) async {
    return await repository.toggleRelay(params.deviceIp, params.relayId);
  }
}

class ToggleRelayParams {
  final String deviceIp;
  final String relayId;

  ToggleRelayParams({
    required this.deviceIp,
    required this.relayId,
  });
}
