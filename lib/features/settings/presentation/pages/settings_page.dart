import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../../shared/widgets/neumorphic_toggle.dart';
import '../../../../app.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Ayarlar',
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Theme Section
            NeumorphicContainer(
              style: NeumorphicStyle.convex,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Görünüm',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Dark Mode Toggle
                  Row(
                    children: [
                      Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.accentPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Karanlık Tema',
                              style: AppTextStyles.body1,
                            ),
                            Text(
                              isDark ? 'Aktif' : 'Kapalı',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      NeumorphicToggle(
                        value: isDark,
                        onChanged: (value) {
                          ref.read(themeModeProvider.notifier).state =
                              value ? ThemeMode.dark : ThemeMode.light;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Network Section
            NeumorphicContainer(
              style: NeumorphicStyle.convex,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ağ',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildInfoRow(
                    context,
                    'Ağ Aralığı',
                    '192.168.55.0/24',
                    Icons.wifi,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildInfoRow(
                    context,
                    'API Portu',
                    '8080',
                    Icons.router,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildInfoRow(
                    context,
                    'Polling Aralığı',
                    '10 saniye',
                    Icons.sync,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // App Info
            NeumorphicContainer(
              style: NeumorphicStyle.convex,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uygulama',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildInfoRow(
                    context,
                    'Versiyon',
                    AppConstants.appVersion,
                    Icons.info_outline,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildInfoRow(
                    context,
                    'Platform',
                    'Windows Desktop',
                    Icons.desktop_windows,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.accentPrimary,
          size: 20,
        ),
        const SizedBox(width: AppConstants.paddingSmall),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body2,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.accentPrimary,
          ),
        ),
      ],
    );
  }
}
