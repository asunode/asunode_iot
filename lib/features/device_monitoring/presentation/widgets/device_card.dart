import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_status.dart';
import '../providers/device_status_provider.dart';

class DeviceCard extends ConsumerWidget {
  final Device device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(deviceStatusProvider(device.id));

    return NeumorphicContainer(
      style: NeumorphicStyle.convex,
      padding: const EdgeInsets.all(16),
      child: statusAsync.when(
        data: (status) => _buildCard(context, status),
        loading: () => _buildLoading(context),
        error: (error, stack) => _buildError(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context, DeviceStatus? status) {
    final isOnline = status?.isOnline ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Status dot + Name
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline
                    ? AppColors.statusOnline
                    : AppColors.statusOffline,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                device.name,
                style: AppTextStyles.headline3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // IP address
        Text(
          device.ip,
          style: AppTextStyles.caption,
        ),

        const SizedBox(height: 8),

        // Ping + Critical sensor (tek satir)
        if (isOnline && status != null) ...[
          Row(
            children: [
              // Ping badge
              NeumorphicContainer(
                style: NeumorphicStyle.concave,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text(
                  '${status.pingLatency}ms',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accentPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Critical sensor (varsa)
              ..._buildCriticalSensor(status),
            ],
          ),
        ] else ...[
          Text(
            'Cihaz cevrimdisi',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.statusOffline,
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildCriticalSensor(DeviceStatus status) {
    final sensors = status.sensors;
    if (sensors == null) return [];

    // Oncelik: Temperature > Motion > Humidity
    if (sensors.temperature != null) {
      return [
        const Icon(Icons.thermostat_rounded,
            size: 14, color: AppColors.accentPrimary),
        const SizedBox(width: 4),
        Text(
          '${sensors.temperature!.toStringAsFixed(1)}\u00B0C',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.accentPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ];
    }

    if (sensors.motion != null) {
      final detected = sensors.hasMotion;
      return [
        Icon(
          Icons.directions_run_rounded,
          size: 14,
          color: detected ? AppColors.statusWarning : AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          detected ? 'Algilandi' : 'Yok',
          style: AppTextStyles.caption.copyWith(
            color:
                detected ? AppColors.statusWarning : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ];
    }

    if (sensors.humidity != null) {
      return [
        const Icon(Icons.water_drop_rounded,
            size: 14, color: AppColors.statusInfo),
        const SizedBox(width: 4),
        Text(
          '${sensors.humidity!.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.statusInfo,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ];
    }

    return [];
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(device.name, style: AppTextStyles.headline3),
        const SizedBox(height: 8),
        const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accentPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(device.name, style: AppTextStyles.headline3),
        const SizedBox(height: 8),
        Text(
          'Hata',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.statusOffline,
          ),
        ),
      ],
    );
  }
}
