import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../../shared/widgets/neumorphic_toggle.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_status.dart';
import '../providers/device_status_provider.dart';

class DeviceCard extends ConsumerWidget {
  final Device device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(deviceStatusProvider(device.id));

    return statusAsync.when(
      loading: () => _buildLoadingCard(context),
      error: (err, stack) => _buildErrorCard(context, err.toString()),
      data: (status) => _buildStatusCard(context, ref, status),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return NeumorphicContainer(
      style: NeumorphicStyle.convex,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeviceHeader(context, isOnline: false),
          const Spacer(),
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.accentPrimary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return NeumorphicContainer(
      style: NeumorphicStyle.convex,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeviceHeader(context, isOnline: false),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Hata: $error',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.statusOffline,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    WidgetRef ref,
    DeviceStatus? status,
  ) {
    final isOnline = status?.isOnline ?? false;

    return NeumorphicContainer(
      style: NeumorphicStyle.convex,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: name, IP, type icon, status dot
          _buildDeviceHeader(context, isOnline: isOnline),

          if (status != null && isOnline) ...[
            const SizedBox(height: AppConstants.paddingSmall),

            // Info row: MAC + ping badge
            _buildInfoRow(context, status),
            const SizedBox(height: AppConstants.paddingMedium),

            // Relay controls
            if (status.relays.isNotEmpty) ...[
              _buildRelaySection(context, ref, status),
              const SizedBox(height: AppConstants.paddingMedium),
            ],

            // Sensor data
            if (status.sensors != null) _buildSensorSection(context, status),
          ],

          if (!isOnline) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Cihaz çevrimdışı',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusOffline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceHeader(BuildContext context, {required bool isOnline}) {
    return Row(
      children: [
        // Online/offline dot
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isOnline ? AppColors.statusOnline : AppColors.statusOffline,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppConstants.paddingSmall),

        // Device name & IP
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: AppTextStyles.headline3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(device.ip, style: AppTextStyles.caption),
            ],
          ),
        ),

        // Device type chip
        Icon(
          device.type == DeviceType.esp8266
              ? Icons.memory_rounded
              : Icons.developer_board_rounded,
          color: AppColors.accentPrimary,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, DeviceStatus status) {
    return Row(
      children: [
        // MAC address
        if (status.macAddress != null)
          Expanded(
            child: Text(
              status.macAddress!,
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Ping latency badge
        NeumorphicContainer(
          style: NeumorphicStyle.concave,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingSmall,
            vertical: AppConstants.paddingXSmall,
          ),
          child: Text(
            '${status.pingLatency}ms',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accentPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelaySection(
    BuildContext context,
    WidgetRef ref,
    DeviceStatus status,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Röleler', style: AppTextStyles.body2),
        const SizedBox(height: AppConstants.paddingSmall),
        ...status.relays.entries.map((entry) {
          final isOn = status.isRelayActive(entry.key);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.paddingXSmall),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isOn ? AppColors.relayOn : AppColors.relayOff,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: Text(
                    entry.key.replaceAll('_', ' ').toUpperCase(),
                    style: AppTextStyles.caption,
                  ),
                ),
                NeumorphicToggle(
                  value: isOn,
                  width: 48,
                  height: 24,
                  onChanged: (value) {
                    // TODO: CP10 - toggleRelayProvider entegrasyonu
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSensorSection(BuildContext context, DeviceStatus status) {
    final sensors = status.sensors!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sensörler', style: AppTextStyles.body2),
        const SizedBox(height: AppConstants.paddingSmall),
        if (sensors.motion != null)
          _buildSensorRow(
            Icons.directions_run_rounded,
            'Hareket',
            sensors.hasMotion ? 'Algılandı' : 'Yok',
            sensors.hasMotion
                ? AppColors.statusWarning
                : AppColors.textSecondary,
          ),
        if (sensors.temperature != null)
          _buildSensorRow(
            Icons.thermostat_rounded,
            'Sıcaklık',
            '${sensors.temperature!.toStringAsFixed(1)}°C',
            AppColors.accentPrimary,
          ),
        if (sensors.humidity != null)
          _buildSensorRow(
            Icons.water_drop_rounded,
            'Nem',
            '${sensors.humidity!.toStringAsFixed(0)}%',
            AppColors.statusInfo,
          ),
      ],
    );
  }

  Widget _buildSensorRow(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingXSmall),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(label, style: AppTextStyles.caption),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
