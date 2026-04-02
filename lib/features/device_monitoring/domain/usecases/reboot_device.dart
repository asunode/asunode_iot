import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/device_repository.dart';

class RebootDevice {
  final DeviceRepository repository;

  RebootDevice(this.repository);

  Future<Either<Failure, bool>> call(String deviceIp) async {
    return await repository.rebootDevice(deviceIp);
  }
}
