import 'package:trace_or/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CurvePainterShort extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(size.width * 0.75, size.height);
    path.cubicTo(size.width * 0.67, size.height, size.width * 0.62, size.height * 0.98, size.width * 0.49, size.height * 0.93);
    path.cubicTo(size.width * 0.38, size.height * 0.89, size.width / 3, size.height * 0.87, size.width * 0.28, size.height * 0.87);
    path.cubicTo(size.width * 0.19, size.height * 0.87, size.width * 0.11, size.height * 0.90, size.width * 0.04, size.height * 0.96);
    path.cubicTo(size.width * 0, size.height * 0.99, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height,0, size.height * 0.49, 0, size.height * 0.49);
    path.cubicTo(0, size.height * 0.49, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width / 2, 0, size.width / 2, 0);
    path.cubicTo(size.width / 2, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.46, size.width, size.height * 0.46);
    path.cubicTo(size.width, size.height * 0.46, size.width, size.height * 0.92, size.width, size.height * 0.92);
    path.cubicTo(size.width, size.height * 0.92, size.width * 0.98, size.height * 0.93, size.width * 0.98, size.height * 0.93);
    path.cubicTo(size.width * 0.9, size.height * 0.98, size.width * 0.83, size.height, size.width * 0.75, size.height);
    path.cubicTo(size.width * 0.75, size.height, size.width * 0.75, size.height, size.width * 0.75, size.height);
    paint.color = AppColors.colorTwo;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}