import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources /colors.dart';

class AnimatedPercentageInfoWidget extends StatelessWidget {
  final int percentValue;
  final Animation<Offset> previousValueOffset;
  final Animation<Offset> currentValueOffset;
  final Animation<double> previousValueOpacity;
  final Animation<double> currentValueOpacity;

  const AnimatedPercentageInfoWidget({
    required this.percentValue,
    required this.previousValueOffset,
    required this.currentValueOffset,
    required this.previousValueOpacity,
    required this.currentValueOpacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: 90.w,
          child: Stack(
            children: [
              FadeTransition(
                opacity: previousValueOpacity,
                child: SlideTransition(
                  position: previousValueOffset,
                  child: Text(
                    '$percentValue',
                    style: TextStyle(color: Palette.white, fontSize: 42.sp, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              FadeTransition(
                opacity: currentValueOpacity,
                child: SlideTransition(
                  position: currentValueOffset,
                  child: Text(
                    '$percentValue',
                    style: TextStyle(color: Palette.white, fontSize: 42.sp, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          '%',
          style: TextStyle(color: Palette.white, fontSize: 32.sp, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
