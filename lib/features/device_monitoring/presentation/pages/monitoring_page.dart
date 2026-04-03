import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neumorphic_button.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../providers/device_list_provider.dart';
import '../providers/scanning_provider.dart';
import '../widgets/device_card.dart';

class MonitoringPage extends ConsumerWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(deviceListProvider);
    final scanningStatus = ref.watch(scanningProvider);
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: _buildScanFab(context, ref, scanningStatus),
      body: RefreshIndicator(
        onRefresh: () => ref.read(deviceListProvider.notifier).refresh(),
        color: AppColors.accentPrimary,
        child: devicesAsync.when(
          loading: () => _buildLoadingState(context),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (devices) {
            if (devices.isEmpty) {
              return _buildEmptyState(context, ref);
            }
            return _buildDeviceGrid(context, devices);
          },
        ),
      ),
    );
  }

  Widget _buildScanFab(
    BuildContext context,
    WidgetRef ref,
    ScanningStatus scanningStatus,
  ) {
    final isScanning = scanningStatus.state == ScanningState.scanning;

    return NeumorphicButton(
      type: NeumorphicButtonType.primary,
      width: 56,
      height: 56,
      borderRadius: BorderRadius.circular(28),
      isEnabled: !isScanning,
      onPressed: () => ref.read(scanningProvider.notifier).scan(),
      child: isScanning
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.accentText,
              ),
            )
          : const Icon(
              Icons.radar_rounded,
              color: AppColors.accentText,
              size: 28,
            ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.accentPrimary),
          SizedBox(height: AppConstants.paddingMedium),
          Text('Cihazlar yükleniyor...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
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
              'Hata oluştu',
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
              onPressed: () => ref.read(deviceListProvider.notifier).refresh(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
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
                  'Henüz cihaz bulunamadı',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Ağınızdaki ESP cihazlarını bulmak için\ntarama başlatın.',
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
                      Text('Tarama Başlat'),
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

  Widget _buildDeviceGrid(BuildContext context, List devices) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.deviceGridColumns,
          childAspectRatio: AppConstants.deviceCardAspectRatio,
          crossAxisSpacing: AppConstants.gridSpacing,
          mainAxisSpacing: AppConstants.gridSpacing,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) => DeviceCard(device: devices[index]),
      ),
    );
  }
}
