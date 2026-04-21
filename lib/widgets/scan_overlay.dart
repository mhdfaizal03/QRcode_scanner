import 'package:flutter/material.dart';

class NeonScanOverlay extends CustomPainter {
  final double animationValue;

  NeonScanOverlay({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBase = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double side = (size.width < 600)
        ? 250.0
        : (size.width < 1200)
            ? 350.0
            : 400.0;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );

    // Draw corners (Crosshairs)
    const cornerLength = 40.0;
    final path = Path()
      // Top Left
      ..moveTo(rect.left, rect.top + cornerLength)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + cornerLength, rect.top)
      // Top Right
      ..moveTo(rect.right - cornerLength, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + cornerLength)
      // Bottom Right
      ..moveTo(rect.right, rect.bottom - cornerLength)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - cornerLength, rect.bottom)
      // Bottom Left
      ..moveTo(rect.left + cornerLength, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cornerLength);

    // Subtle target pulse
    final pulseScale = 1.0 + (0.05 * animationValue);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(pulseScale);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Draw glow
    canvas.drawPath(
        path,
        paintBase
          ..strokeWidth = 4.0
          ..color = Colors.blueAccent.withValues(alpha: 0.8));
    canvas.drawPath(
      path,
      paintBase
        ..strokeWidth = 12.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
        ..color = Colors.blueAccent.withValues(alpha: 0.2),
    );
    canvas.restore();

    // Scanning Line
    final scanLineY = rect.top + (rect.height * animationValue);
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blueAccent.withValues(alpha: 0),
          Colors.blueAccent.withValues(alpha: 0.8),
          Colors.white,
          Colors.blueAccent.withValues(alpha: 0.8),
          Colors.blueAccent.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(rect.left, scanLineY - 5, rect.width, 10))
      ..strokeWidth = 4.0;

    canvas.drawLine(
      Offset(rect.left, scanLineY),
      Offset(rect.right, scanLineY),
      scanPaint,
    );

    // Glowing scan line trail
    canvas.drawRect(
      Rect.fromLTRB(rect.left, scanLineY - 20, rect.right, scanLineY),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueAccent.withValues(alpha: 0),
            Colors.blueAccent.withValues(alpha: 0.15)
          ],
        ).createShader(Rect.fromLTRB(rect.left, scanLineY - 20, rect.right, scanLineY)),
    );
  }

  @override
  bool shouldRepaint(NeonScanOverlay oldDelegate) => true;
}
