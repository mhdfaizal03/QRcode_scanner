import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// --- UNIVERSAL DESIGN SYSTEM CONSTANTS ---
class UiConstants {
  static const double maxContentWidth = 1200;
  static const double mobilePadding = 24.0;
  static const double tabletPadding = 40.0;
  static const double desktopPadding = 60.0;
  
  static double mainPadding(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width < 600) return mobilePadding;
    if (width < 1200) return tabletPadding;
    return desktopPadding;
  }
}

// --- FLUID SCALING ENGINE ---
class ResponsiveSizer {
  static double scale(BuildContext context, double size, {double? max}) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    // Standard mobile width base for scaling is 375
    double scaled = size * (screenWidth / 375);
    if (max != null) return math.min(scaled, max);
    return scaled;
  }
}


class StartBackgroundColor extends StatelessWidget {
  final Widget child;
  const StartBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff09090b),
      child: Stack(
        children: [
          const AnimatedBackground(),
          
          // Blur Layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent),
          ),
          
          child,
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -150 + (50 * _controller.value),
              left: -150 + (100 * _controller.value),
              child: _GlowCircle(
                color: Colors.blueAccent.withValues(alpha: 0.15),
                size: 500,
              ),
            ),
            Positioned(
              bottom: -150 - (100 * _controller.value),
              right: -150 - (50 * _controller.value),
              child: _GlowCircle(
                color: Colors.purpleAccent.withValues(alpha: 0.12),
                size: 600,
              ),
            ),
            Positioned(
              top: 200,
              right: -100 + (150 * _controller.value),
              child: _GlowCircle(
                color: Colors.cyanAccent.withValues(alpha: 0.08),
                size: 400,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: size / 2,
            spreadRadius: 20,
          )
        ],
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double opacity;
  final bool borderGlow;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 25,
    this.padding = const EdgeInsets.all(16),
    this.opacity = 0.08,
    this.borderGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderGlow 
                   ? Colors.blueAccent.withValues(alpha: 0.5)
                   : Colors.white.withValues(alpha: 0.08),
                width: borderGlow ? 1.5 : 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class EntranceAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const EntranceAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 30),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutQuart,
      child: child,
      builder: (context, value, child) {
        return Transform.translate(
          offset: offset * (1.0 - value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}
