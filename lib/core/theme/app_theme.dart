import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Colors
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.accentPrimary,
        onPrimary: AppColors.accentText,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        secondary: AppColors.textSecondary,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),

      // Font Family
      fontFamily: GoogleFonts.manrope().fontFamily,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headline2,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Colors
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accentPrimary,
        onPrimary: AppColors.accentText,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        secondary: AppColors.textSecondaryDark,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1Dark,
        displayMedium: AppTextStyles.headline2Dark,
        displaySmall: AppTextStyles.headline3Dark,
        bodyLarge: AppTextStyles.body1Dark,
        bodyMedium: AppTextStyles.body2Dark,
        bodySmall: AppTextStyles.captionDark,
        labelLarge: AppTextStyles.buttonDark,
      ),

      // Font Family
      fontFamily: GoogleFonts.manrope().fontFamily,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headline2Dark,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
    );
  }
}
