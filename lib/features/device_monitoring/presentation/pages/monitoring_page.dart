import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_button.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../domain/entities/device.dart';
import '../providers/device_list_provider.dart';
import '../providers/device_status_provider.dart';
import '../providers/scanning_provider.dart';
import '../widgets/device_card.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectFirstDevice();
    });
  }

  void _selectFirstDevice() {
    final devices = ref.read(deviceListProvider).valueOrNull;
    if (devices != null && devices.isNotEmpty && _selectedDeviceId == null) {
      setState(() {
        _selectedDeviceId = devices[0].id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(deviceListProvider);
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: devicesAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
        data: (devices) {
          if (devices.isEmpty) {
            return _buildEmptyState();
          }
          // İlk yüklemede seçili cihaz yoksa ilk kartı seç
          if (_selectedDeviceId == null && devices.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedDeviceId = devices[0].id;
              });
            });
          }
          return _buildContent(devices);
        },
      ),
    );
  }

  Widget _buildContent(List<Device> devices) {
    return Row(
      children: [
        // SOL: Grid bolumu (3/4)
        Expanded(
          flex: 3,
          child: RefreshIndicator(
            onRefresh: () => ref.read(deviceListProvider.notifier).refresh(),
            color: AppColors.accentPrimary,
            child: GridView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.deviceGridColumns,
                childAspectRatio: AppConstants.deviceCardAspectRatio,
                crossAxisSpacing: AppConstants.gridSpacing,
                mainAxisSpacing: AppConstants.gridSpacing,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                final isSelected = device.id == _selectedDeviceId;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDeviceId = device.id;
                    });
                  },
                  child: Container(
                    decoration: isSelected
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusCard,
                            ),
                            border: Border.all(
                              color: AppColors.accentPrimary,
                              width: 2,
                            ),
                          )
                        : null,
                    child: DeviceCard(device: device),
                  ),
                );
              },
            ),
          ),
        ),

        // SAG: Detay paneli (1/4)
        Expanded(
          flex: 1,
          child: _buildDetailPanel(devices),
        ),
      ],
    );
  }

  Widget _buildDetailPanel(List<Device> devices) {
    if (_selectedDeviceId == null) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: Text(
            'Cihaz seciniz',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final selectedDevice = devices.firstWhere(
      (d) => d.id == _selectedDeviceId,
      orElse: () => devices.first,
    );

    final statusAsync = ref.watch(deviceStatusProvider(selectedDevice.id));

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: NeumorphicContainer(
        style: NeumorphicStyle.convex,
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baslik
            Text(
              selectedDevice.name,
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),
            Text(
              selectedDevice.ip,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 4),
            Text(
              selectedDevice.type.name.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Status bilgisi
            statusAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentPrimary,
                  strokeWidth: 2,
                ),
              ),
              error: (error, stack) => Text(
                'Durum alinamadi',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.statusOffline,
                ),
              ),
              data: (status) => _buildDetailStatus(status, selectedDevice),
            ),

            const Spacer(),

            // Placeholder
            Center(
              child: Text(
                'Detay icerigi gelecek',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStatus(
    dynamic status,
    Device device,
  ) {
    if (status == null) {
      return Text(
        'Durum bilinmiyor',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    final isOnline = status.isOnline as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Online/Offline badge
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
            Text(
              isOnline ? 'Online' : 'Offline',
              style: AppTextStyles.body2.copyWith(
                color: isOnline
                    ? AppColors.statusOnline
                    : AppColors.statusOffline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        if (isOnline) ...[
          const SizedBox(height: 12),

          // Ping
          _buildDetailRow('Ping', '${status.pingLatency}ms'),

          // MAC
          if (status.macAddress != null)
            _buildDetailRow('MAC', status.macAddress!),

          // Sensors
          if (status.sensors != null) ...[
            const SizedBox(height: 8),
            if (status.sensors!.temperature != null)
              _buildDetailRow(
                'Sicaklik',
                '${status.sensors!.temperature!.toStringAsFixed(1)}\u00B0C',
              ),
            if (status.sensors!.humidity != null)
              _buildDetailRow(
                'Nem',
                '${status.sensors!.humidity!.toStringAsFixed(0)}%',
              ),
            if (status.sensors!.motion != null)
              _buildDetailRow(
                'Hareket',
                status.sensors!.hasMotion ? 'Algilandi' : 'Yok',
              ),
          ],

          // Relays
          if (status.relays.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...status.relays.entries.map<Widget>((entry) {
              final isOn = status.isRelayActive(entry.key);
              return _buildDetailRow(
                entry.key.replaceAll('_', ' ').toUpperCase(),
                isOn ? 'ACIK' : 'KAPALI',
                valueColor: isOn
                    ? AppColors.statusOnline
                    : AppColors.statusOffline,
              );
            }),
          ],
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.accentPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.accentPrimary),
          SizedBox(height: AppConstants.paddingMedium),
          Text('Cihazlar yukleniyor...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.statusOffline,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Hata olustu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            NeumorphicButton(
              onPressed: () =>
                  ref.read(deviceListProvider.notifier).refresh(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicContainer(
                  style: NeumorphicStyle.concave,
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.circular(60),
                  child: const Center(
                    child: Icon(
                      Icons.devices_other_rounded,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'Henuz cihaz bulunamadi',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Aginizdaki ESP cihazlarini bulmak icin\ntarama baslatin.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                NeumorphicButton(
                  type: NeumorphicButtonType.primary,
                  width: 200,
                  onPressed: () =>
                      ref.read(scanningProvider.notifier).scan(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.radar_rounded,
                          color: AppColors.accentText, size: 20),
                      SizedBox(width: AppConstants.paddingSmall),
                      Text('Tarama Baslat'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
