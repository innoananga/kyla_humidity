import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources /colors.dart';

class HumidityBarPainter extends CustomPainter {
  final double verticalPosition;
  final double currentHumidity;
  final double clampTopLimit;
  final double clampBottomLimit;

  HumidityBarPainter({
    required this.verticalPosition,
    required this.currentHumidity,
    required this.clampTopLimit,
    required this.clampBottomLimit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 30.r;
    final double centerX = size.width / 2;
    final double centerY = size.height * verticalPosition;

    _drawGradientLine(canvas, size, radius, centerX, centerY);
    _drawTicks(canvas, size, radius, centerX, centerY);

    // ///-----------------------------------
    //
    // final TextSpan currentValueSpan = TextSpan(
    //   style: TextStyle(
    //     color: Palette.blue,
    //     fontSize: 16.sp,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   text: "$currentValue%",
    // );
    // final TextPainter tp = TextPainter(
    //   text: currentValueSpan,
    //   textAlign: TextAlign.right,
    //   textDirection: TextDirection.ltr,
    // );
    // tp.layout();
    // //tp.paint(canvas, Offset(centerX - radius * 4.5, centerY - tp.height / 2));
    //
    // ///------------------------------------
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawGradientLine(
    Canvas canvas,
    Size size,
    double radius,
    double centerX,
    double centerY,
  ) {
    final shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.01, 0.2, 0.3, 0.4, 0.60, 0.75, 0.92, 0.99],
      colors: [
        Palette.background,
        Palette.pink,
        Palette.pink,
        Palette.blue,
        Palette.blue,
        Palette.pink,
        Palette.pink,
        Palette.background,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint paint = Paint()
      ..shader = shader
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.w
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    path.moveTo(centerX, 0);

    path.lineTo(centerX, centerY - radius * 3);

    path.cubicTo(
      centerX, centerY - radius / 2, //
      centerX - radius, centerY - radius * 1.2, //
      centerX - radius, centerY, //
    );

    path.moveTo(centerX, centerY + radius * 3);

    path.cubicTo(
      centerX, centerY + radius / 2, //
      centerX - radius, centerY + radius * 1.2, //
      centerX - radius, centerY, //
    );

    path.moveTo(centerX, centerY + radius * 3);

    path.lineTo(centerX, size.height);

    canvas.drawPath(path, paint);
  }

  void _drawTicks(
    Canvas canvas,
    Size size,
    double radius,
    double centerX,
    double centerY,
  ) {
    final Paint tickPaint = Paint()
      ..color = Palette.chartDarkGrey
      ..strokeWidth = 1.w;

    const numberOfTicks = 45;
    const stepsBetweenLongTicks = 5;
    final double tickSpacing = (clampBottomLimit - clampTopLimit) * size.height / numberOfTicks;
    final double tickLengthLong = 25.w;
    final double tickLengthShort = 15.w;

    for (double index = 0; index <= numberOfTicks; index++) {
      double dx = centerX;
      double i = size.height * 0.2 + index * tickSpacing;

      if (i < centerY - radius * 3) {
        dx = centerX;
      } else if (i >= centerY - radius * 3 && i <= centerY) {
        double t = (i - (centerY - radius * 3)) / (radius * 2.8);
        dx = centerX - radius * (t * t);
      } else if (i > centerY && i <= centerY + radius * 3) {
        double t = (i - centerY) / (radius * 3);
        dx = centerX - radius * ((1 - t) * (1 - t)) * 1.2;
      } else {
        dx = centerX;
      }
      final double tickLength = index % stepsBetweenLongTicks == 0 ? tickLengthLong : tickLengthShort;
      canvas.drawLine(
        Offset(dx - tickLength - 10.w, i),
        Offset(dx - 10.w, i),
        tickPaint,
      );
    }
  }
}
