import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_status.dart';
import '../../domain/repositories/device_repository.dart';
import '../data_sources/esp_remote_data_source.dart';
import '../data_sources/device_local_data_source.dart';
import '../models/device_dto.dart';
import '../models/command_dto.dart';
import '../../../../shared/services/ping_service.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final ESPRemoteDataSource remoteDataSource;
  final DeviceLocalDataSource localDataSource;
  final PingService pingService;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.pingService,
  });

  @override
  Future<Either<Failure, List<Device>>> getAllDevices() async {
    try {
      final devicesDTO = await localDataSource.getCachedDevices();
      final devices = devicesDTO.map((dto) => dto.toEntity()).toList();
      return Right(devices);
    } catch (e) {
      return Left(CacheFailure('Failed to load devices: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveDevice(Device device) async {
    try {
      final dto = DeviceDTO.fromEntity(device);
      await localDataSource.cacheDevice(dto);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save device: $e'));
    }
  }

  @override
  Future<Either<Failure, DeviceStatus>> getDeviceStatus(String ip) async {
    try {
      final pingResult = await pingService.pingDevice(ip);

      if (!pingResult.isSuccess) {
        return Right(DeviceStatus(
          deviceId: ip,
          isOnline: false,
          pingLatency: pingResult.rttMs,
          lastSeen: DateTime.now(),
          relays: {},
        ));
      }

      final statusDTO = await remoteDataSource.getDeviceStatus(ip);
      final status = statusDTO.toEntity(pingLatency: pingResult.rttMs);

      await localDataSource.cacheStatus(ip, statusDTO);

      return Right(status);
    } on SocketException {
      return const Left(NetworkFailure('Network connection failed'));
    } catch (e) {
      return Left(ServerFailure('Failed to get status: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleRelay(String ip, String relayId) async {
    try {
      final command = CommandDTO.toggleRelay(ip, relayId);
      final success = await remoteDataSource.sendCommand(ip, command);
      return Right(success);
    } on SocketException {
      return const Left(NetworkFailure('Network connection failed'));
    } catch (e) {
      return Left(ServerFailure('Failed to toggle relay: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> setRelay(
    String ip,
    String relayId,
    bool state,
  ) async {
    try {
      final command = CommandDTO.setRelay(ip, relayId, state);
      final success = await remoteDataSource.sendCommand(ip, command);
      return Right(success);
    } on SocketException {
      return const Left(NetworkFailure('Network connection failed'));
    } catch (e) {
      return Left(ServerFailure('Failed to set relay: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> rebootDevice(String ip) async {
    try {
      final command = CommandDTO.rebootDevice(ip);
      final success = await remoteDataSource.sendCommand(ip, command);
      return Right(success);
    } on SocketException {
      return const Left(NetworkFailure('Network connection failed'));
    } catch (e) {
      return Left(ServerFailure('Failed to reboot device: $e'));
    }
  }
}
