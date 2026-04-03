import 'package:flutter/material.dart';

enum LedStatus {
  online,  // Yeşil + pulse glow
  offline, // Kırmızı + solid
  warning, // Turuncu + blink glow
}

class StatusLed extends StatefulWidget {
  final LedStatus status;
  final double size;

  const StatusLed({
    super.key,
    required this.status,
    this.size = 20.0, // Default: 20px
  });

  @override
  State<StatusLed> createState() => _StatusLedState();
}

class _StatusLedState extends State<StatusLed>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.status == LedStatus.online
          ? const Duration(milliseconds: 2000)
          : const Duration(milliseconds: 1000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.status != LedStatus.offline) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusLed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _controller.stop();
      _controller.dispose();
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Renk paleti
  Color get _lightColor {
    switch (widget.status) {
      case LedStatus.online:
        return const Color(0xFF88FF88); // Açık yeşil
      case LedStatus.offline:
        return const Color(0xFFFF8888); // Açık kırmızı
      case LedStatus.warning:
        return const Color(0xFFFFAA66); // Açık turuncu
    }
  }

  Color get _darkColor {
    switch (widget.status) {
      case LedStatus.online:
        return const Color(0xFF00AA00); // Koyu yeşil
      case LedStatus.offline:
        return const Color(0xFFAA0000); // Koyu kırmızı
      case LedStatus.warning:
        return const Color(0xFFCC6600); // Koyu turuncu
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E5EC);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            // YUMUŞAK DIŞ GLOW (sadece online/warning)
            boxShadow: widget.status != LedStatus.offline
                ? [
                    // Geniş yumuşak glow
                    BoxShadow(
                      color: _lightColor
                          .withValues(alpha: _glowAnimation.value * 0.4),
                      blurRadius: widget.size * 2.0,
                      spreadRadius: widget.size * 0.5,
                    ),
                    // Orta glow
                    BoxShadow(
                      color: _lightColor
                          .withValues(alpha: _glowAnimation.value * 0.6),
                      blurRadius: widget.size * 1.0,
                      spreadRadius: widget.size * 0.2,
                    ),
                  ]
                : [
                    // Offline: sadece yumuşak shadow (glow yok)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: widget.size * 0.5,
                      offset: Offset(widget.size * 0.1, widget.size * 0.1),
                    ),
                  ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              // YUMUŞAK BEYAZ RING (doku ile birleşiyor)
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.95,
                colors: [
                  bgColor.withValues(alpha: 0.0), // Merkez şeffaf
                  bgColor.withValues(alpha: 0.3), // Yumuşak geçiş
                  Colors.white
                      .withValues(alpha: isDark ? 0.2 : 0.5), // Ring
                ],
                stops: const [0.7, 0.85, 1.0],
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.all(widget.size * 0.12), // Ring kalınlığı
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  // LED GRADYAN (SOL ÜSTTEN IŞIK GELİYOR)
                  gradient: RadialGradient(
                    center: const Alignment(-0.4, -0.4), // Sol üst
                    radius: 1.3,
                    colors: [
                      Colors.white.withValues(alpha: 0.9), // Işık merkezi
                      _lightColor, // Açık ton
                      _lightColor, // Orta
                      _darkColor, // Koyu kenar
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),

                  // İÇ DEPTH SHADOW (3D efekt)
                  boxShadow: [
                    // Sağ-alt koyu (depth)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      offset: Offset(
                          widget.size * 0.06, widget.size * 0.06),
                      blurRadius: widget.size * 0.12,
                    ),
                    // Sol-üst açık (3D pop)
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      offset: Offset(
                          -widget.size * 0.03, -widget.size * 0.03),
                      blurRadius: widget.size * 0.08,
                    ),
                  ],
                ),

                // MERKEZİ PARLAMA (yansıma)
                child: Center(
                  child: Container(
                    width: widget.size * 0.25,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
