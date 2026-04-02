import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class NeumorphicToggle extends StatefulWidget {
  const NeumorphicToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60,
    this.height = 32,
    this.isEnabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final bool isEnabled;

  @override
  State<NeumorphicToggle> createState() => _NeumorphicToggleState();
}

class _NeumorphicToggleState extends State<NeumorphicToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );

    _thumbAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(NeumorphicToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isEnabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final opacity = widget.isEnabled ? 1.0 : 0.5;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AppConstants.animationFast,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Track (Concave - içe çökük)
              _buildTrack(brightness),

              // Thumb (Convex - dışa çıkıntılı)
              AnimatedBuilder(
                animation: _thumbAnimation,
                builder: (context, child) => _buildThumb(brightness),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrack(Brightness brightness) {
    final bgColor = brightness == Brightness.dark
        ? AppColors.surfaceDark
        : AppColors.background;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          // Inner shadow (top-left)
          BoxShadow(
            color: brightness == Brightness.dark
                ? AppColors.shadowDarkMode.withValues(alpha: 0.7)
                : AppColors.shadowDark.withValues(alpha: 0.7),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
          // Inner shadow (bottom-right)
          BoxShadow(
            color: brightness == Brightness.dark
                ? AppColors.shadowLightMode.withValues(alpha: 0.5)
                : AppColors.shadowLight.withValues(alpha: 0.5),
            offset: const Offset(-2, -2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(Brightness brightness) {
    final thumbSize = widget.height - 8;
    final maxOffset = widget.width - thumbSize - 8;
    final offset = _thumbAnimation.value * maxOffset + 4;

    final thumbColor = widget.value
        ? AppColors.accentPrimary
        : (brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.background);

    return Positioned(
      left: offset,
      top: 4,
      child: Container(
        width: thumbSize,
        height: thumbSize,
        decoration: BoxDecoration(
          color: thumbColor,
          shape: BoxShape.circle,
          boxShadow: [
            // Convex shadow (bottom-right)
            BoxShadow(
              color: brightness == Brightness.dark
                  ? AppColors.shadowDarkMode.withValues(alpha: 0.8)
                  : AppColors.shadowDark.withValues(alpha: 0.7),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
            // Convex shadow (top-left)
            BoxShadow(
              color: brightness == Brightness.dark
                  ? AppColors.shadowLightMode.withValues(alpha: 0.7)
                  : AppColors.shadowLight.withValues(alpha: 0.6),
              offset: const Offset(-3, -3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
