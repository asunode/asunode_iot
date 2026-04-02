import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

enum NeumorphicButtonType { primary, secondary }

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = NeumorphicButtonType.secondary,
    this.width,
    this.height,
    this.borderRadius,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final NeumorphicButtonType type;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isEnabled;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && widget.onPressed != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final radius = widget.borderRadius ??
        BorderRadius.circular(AppConstants.radiusButton);

    // Primary button colors
    final isPrimary = widget.type == NeumorphicButtonType.primary;
    final bgColor = isPrimary
        ? AppColors.accentPrimary
        : (brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.background);

    final opacity = widget.isEnabled ? 1.0 : 0.5;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppConstants.animationFast,
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: AppConstants.animationFast,
          child: Container(
            width: widget.width,
            height: widget.height ?? 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: radius,
              boxShadow: _buildShadows(
                isPrimary,
                _isPressed,
                brightness,
              ),
            ),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isPrimary
                      ? AppColors.accentText
                      : (brightness == Brightness.dark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _buildShadows(
    bool isPrimary,
    bool isPressed,
    Brightness brightness,
  ) {
    if (isPressed) {
      // Pressed state: inset shadows (concave)
      return [
        BoxShadow(
          color: isPrimary
              ? AppColors.accentPrimary.withValues(alpha: 0.6)
              : (brightness == Brightness.dark
                  ? AppColors.shadowDarkMode.withValues(alpha: 0.5)
                  : AppColors.shadowDark.withValues(alpha: 0.5)),
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ];
    }

    // Normal state: convex shadows
    if (isPrimary) {
      // Primary button with blue glow
      return [
        BoxShadow(
          color: AppColors.accentPrimary.withValues(alpha: 0.4),
          offset: const Offset(4, 4),
          blurRadius: 12,
        ),
        BoxShadow(
          color: brightness == Brightness.dark
              ? AppColors.shadowLightMode.withValues(alpha: 0.5)
              : AppColors.shadowLight.withValues(alpha: 0.5),
          offset: const Offset(-4, -4),
          blurRadius: 8,
        ),
      ];
    } else {
      // Secondary button: standard neumorphic
      return [
        BoxShadow(
          color: brightness == Brightness.dark
              ? AppColors.shadowDarkMode.withValues(alpha: 0.7)
              : AppColors.shadowDark.withValues(alpha: 0.7),
          offset: const Offset(4, 4),
          blurRadius: 12,
        ),
        BoxShadow(
          color: brightness == Brightness.dark
              ? AppColors.shadowLightMode.withValues(alpha: 0.6)
              : AppColors.shadowLight.withValues(alpha: 0.6),
          offset: const Offset(-4, -4),
          blurRadius: 8,
        ),
      ];
    }
  }
}
