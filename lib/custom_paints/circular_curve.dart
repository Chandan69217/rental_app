import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CircularWave extends CustomPainter {
  final Color waveColor;
  final double waveHeight; // Amplitude of the wave
  final double waveLength; // Length of one wave cycle
  final double phaseShift; // Controls the wave's animation

  CircularWave({
    required this.waveColor,
    this.waveHeight = 20,
    this.waveLength = 100,
    this.phaseShift = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wavePaint = Paint()
      ..color = waveColor.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final Path wavePath = Path();

    // Starting point of the wave
    wavePath.moveTo(0, size.height / 2);

    // Generate wave points
    for (double x = 0; x <= size.width; x++) {
      double y = size.height / 2 +
          waveHeight * sin((2 * pi / waveLength) * x + phaseShift);
      wavePath.lineTo(x, y);
    }

    // Close the path to form the bottom fill
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}