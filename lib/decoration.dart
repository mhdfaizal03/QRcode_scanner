import 'dart:ui';
import 'package:flutter/material.dart';

class StartBackgroundColor extends StatelessWidget {
  final Widget child;
  const StartBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff09090b),
      child: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -150,
            left: -150,
            child: _GlowCircle(
              color: Colors.blueAccent.withValues(alpha: 0.12),
              size: 500,
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: _GlowCircle(
              color: Colors.purpleAccent.withValues(alpha: 0.1),
              size: 600,
            ),
          ),
          
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
                   ? Colors.blueAccent.withValues(alpha: 0.3)
                   : Colors.white.withValues(alpha: 0.1),
                width: 1.2,
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
