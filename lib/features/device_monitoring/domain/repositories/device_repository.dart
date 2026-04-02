import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/device.dart';
import '../entities/device_status.dart';

abstract class DeviceRepository {
  /// Tüm cihazları getir (cache'den)
  Future<Either<Failure, List<Device>>> getAllDevices();

  /// Cihaz ekle veya güncelle
  Future<Either<Failure, void>> saveDevice(Device device);

  /// Cihaz durumunu getir (ESP'den)
  Future<Either<Failure, DeviceStatus>> getDeviceStatus(String ip);

  /// Röle toggle
  Future<Either<Failure, bool>> toggleRelay(String ip, String relayId);

  /// Röle durumu ayarla (on/off)
  Future<Either<Failure, bool>> setRelay(String ip, String relayId, bool state);

  /// Cihazı yeniden başlat
  Future<Either<Failure, bool>> rebootDevice(String ip);
}
