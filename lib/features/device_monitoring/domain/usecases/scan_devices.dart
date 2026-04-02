import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/device_status.dart';
import '../repositories/device_repository.dart';

class ScanDevices {
  final DeviceRepository repository;

  ScanDevices(this.repository);

  Future<Either<Failure, Map<String, DeviceStatus>>> call() async {
    final devicesResult = await repository.getAllDevices();

    return devicesResult.fold(
      (failure) => Left(failure),
      (devices) async {
        final Map<String, DeviceStatus> statuses = {};

        await Future.wait(
          devices.map((device) async {
            final statusResult = await repository.getDeviceStatus(device.ip);
            statusResult.fold(
              (_) => null,
              (status) => statuses[device.id] = status,
            );
          }),
        );

        return Right(statuses);
      },
    );
  }
}
