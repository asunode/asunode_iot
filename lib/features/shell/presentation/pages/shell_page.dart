import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../device_monitoring/presentation/pages/monitoring_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
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
                Text(
                  'v${AppConstants.appVersion}',
                  style: Theme.of(context).textTheme.bodySmall,
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
          NeumorphicContainer(
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
                  decoration: const BoxDecoration(
                    color: AppColors.statusOnline,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Bağlantı bekleniyor...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
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
