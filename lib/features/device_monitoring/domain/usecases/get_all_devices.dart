import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/device.dart';
import '../repositories/device_repository.dart';

class GetAllDevices {
  final DeviceRepository repository;

  GetAllDevices(this.repository);

  Future<Either<Failure, List<Device>>> call() async {
    return await repository.getAllDevices();
  }
}
