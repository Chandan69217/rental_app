import 'package:flutter/cupertino.dart';

import '../utilities/color_theme.dart';

class RectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..color = ColorTheme.Blue
    .. style = PaintingStyle.fill;

    RRect rRect = RRect.fromLTRBAndCorners(
      0, 10, size.height * 0.1, size.height - 10,
      topRight: Radius.circular(10), // Round the top-right corner
      bottomRight: Radius.circular(10), // Round the bottom-right corner
      topLeft: Radius.zero, // No rounding for top-left corner
      bottomLeft: Radius.zero, // No rounding for bottom-left corner
    );
    canvas.drawRRect(rRect, paint);

    // canvas.clipRRect(RRect.fromRectAndRadius(
    //     Rect.fromPoints(
    //         Offset.zero,
    //         Offset(
    //           0,
    //           size.height,
    //         )),
    //     Radius.circular(10),));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
