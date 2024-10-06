import 'package:trace_or/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class CurvePainterLong extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    canvas.drawPath(path, paint);

    path.cubicTo(size.width * 0.88, size.height*0.99, size.width * 0.38, size.height * 0.95, size.width * 0.45, size.height * 0.935);
    path.cubicTo(size.width * 0.25, size.height* 1.02, size.width * 0.28, size.height * 1.055, size.width * 0.02, size.height * 0.93);
    path.cubicTo(size.width * 0.02, size.height * 0.93, 0, size.height * 0.92, 0, size.height * 0.92);
    path.cubicTo(0, size.height * 0.46, 0, 0, 0, 0);
    path.cubicTo(size.width / 2, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.49, size.width, size.height * 0.49);
    path.cubicTo(size.width, size.height * 0.75, size.width, size.height * 0.97, size.width, size.height * 0.97);
    path.cubicTo(size.width, size.height * 0.97, size.width, size.height * 0.97, size.width * 0.97, size.height * 0.95);
    path.cubicTo(size.width * 0.89, size.height * 0.89, size.width * 0.83, size.height * 0.86, size.width * 0.75, size.height * 0.86);
    path.cubicTo(size.width * 0.70, size.height * 0.86, size.width * 0.64, size.height * 0.88, size.width * 0.56, size.height * 0.92);
    path.cubicTo(size.width /3, size.height*1.03, size.width *0.25, size.height*1.02, size.width * 0.19, size.height);
    paint.color = AppColors.colorOne;
    canvas.drawPath(path, paint);

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}