import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../device_monitoring/presentation/pages/monitoring_page.dart';
import '../../../device_monitoring/presentation/providers/device_list_provider.dart';
import '../../../device_monitoring/presentation/providers/scanning_provider.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class ShellPage extends ConsumerStatefulWidget {
  const ShellPage({super.key});

  @override
  ConsumerState<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends ConsumerState<ShellPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    MonitoringPage(),
    Center(child: Text('Automation')),
    Center(child: Text('Analytics')),
    SettingsPage(),
  ];

  static const _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Monitoring'),
    _NavItem(icon: Icons.smart_toy_rounded, label: 'Automation'),
    _NavItem(icon: Icons.analytics_rounded, label: 'Analytics'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // AppBar
          NeumorphicContainer(
            style: NeumorphicStyle.convex,
            borderRadius: BorderRadius.zero,
            height: 64,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.memory_rounded,
                  color: AppColors.accentPrimary,
                  size: 28,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const Spacer(),
                // Home - Monitoring'e dön
                _buildAppBarAction(
                  icon: Icons.home_outlined,
                  tooltip: 'Ana Sayfa',
                  onPressed: () => setState(() => _selectedIndex = 0),
                ),
                // Scan - Ağ taraması
                _buildScanAction(),
                // Theme toggle
                _buildThemeAction(),
                // Exit - Uygulamayı kapat
                _buildAppBarAction(
                  icon: Icons.logout,
                  tooltip: 'Çıkış',
                  onPressed: () => exit(0),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Row(
              children: [
                // NavigationRail
                NeumorphicContainer(
                  style: NeumorphicStyle.convex,
                  width: 72,
                  borderRadius: BorderRadius.zero,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingLarge,
                  ),
                  child: Column(
                    children: List.generate(_navItems.length, (index) {
                      final item = _navItems[index];
                      final isSelected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingSmall,
                        ),
                        child: _buildNavItem(item, isSelected, index),
                      );
                    }),
                  ),
                ),

                // Content Area
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),

          // Status Bar
          _buildStatusBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }

  Widget _buildScanAction() {
    final scanStatus = ref.watch(scanningProvider);
    final isScanning = scanStatus.state == ScanningState.scanning;

    return Tooltip(
      message: isScanning ? 'Taranıyor...' : 'Ağ Tara',
      child: InkWell(
        onTap: isScanning
            ? null
            : () async {
                await ref.read(scanningProvider.notifier).scan();
                await ref.read(deviceListProvider.notifier).refresh();
              },
        borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isScanning
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accentPrimary,
                  ),
                )
              : const Icon(Icons.radar_rounded, size: 22),
        ),
      ),
    );
  }

  Widget _buildThemeAction() {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Tooltip(
      message: isDark ? 'Açık Tema' : 'Koyu Tema',
      child: InkWell(
        onTap: () {
          ref.read(themeModeProvider.notifier).state =
              isDark ? ThemeMode.light : ThemeMode.dark;
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    final scanStatus = ref.watch(scanningProvider);
    final deviceListAsync = ref.watch(deviceListProvider);
    final totalDevices = deviceListAsync.valueOrNull?.length ?? 0;
    final onlineCount =
        scanStatus.results.values.where((s) => s.isOnline).length;
    final isScanning = scanStatus.state == ScanningState.scanning;
    final lastScan = scanStatus.lastScanTime;

    String statusMessage;
    Color statusColor;

    if (isScanning) {
      statusMessage = 'Taranıyor...';
      statusColor = AppColors.accentPrimary;
    } else if (lastScan != null) {
      final timeStr =
          '${lastScan.hour.toString().padLeft(2, '0')}:${lastScan.minute.toString().padLeft(2, '0')}';
      statusMessage =
          '$onlineCount/$totalDevices cihaz online • Son tarama: $timeStr';
      statusColor =
          onlineCount > 0 ? AppColors.statusOnline : AppColors.statusOffline;
    } else {
      statusMessage = 'Bağlantı bekleniyor...';
      statusColor = AppColors.textSecondary;
    }

    return NeumorphicContainer(
      style: NeumorphicStyle.flat,
      borderRadius: BorderRadius.zero,
      height: 32,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            statusMessage,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Tooltip(
        message: item.label,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          ),
          child: Icon(
            item.icon,
            color: isSelected
                ? AppColors.accentText
                : Theme.of(context).iconTheme.color,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
