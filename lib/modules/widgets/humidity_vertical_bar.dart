import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../resources /colors.dart';
import '../utils/humidity_bar_painter.dart';
import '../utils/percentage_recalculation.dart';
import 'left_side_scale_tile.dart';

class HumidityVerticalBar extends StatefulWidget {
  final double verticalPosition;
  final Function(Offset, double) onPositionChanged;
  final Function() onVerticalDragEnd;
  final double currentHumidity;
  final double clampBottomLimit;
  final double clampTopLimit;

  const HumidityVerticalBar({
    required this.verticalPosition,
    required this.onPositionChanged,
    required this.onVerticalDragEnd,
    required this.currentHumidity,
    required this.clampBottomLimit,
    required this.clampTopLimit,
    super.key,
  });

  @override
  State<HumidityVerticalBar> createState() => _HumidityVerticalBarState();
}

class _HumidityVerticalBarState extends State<HumidityVerticalBar> {
  final List<double> leftSideScaleValues = [100, 75, 50, 45, 40, 35, 30, 25, 10, 0];

  int? currentScaleValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localPosition = box.globalToLocal(details.globalPosition);
        widget.onPositionChanged(localPosition, box.size.height);
      },
      onVerticalDragEnd: (_) => widget.onVerticalDragEnd(),
      child: SizedBox(
        width: Get.width / 2,
        height: Get.height,
        child: Stack(
          children: [
            Positioned.fill(
              left: 100.w,
              child: CustomPaint(
                painter: HumidityBarPainter(
                  verticalPosition: widget.verticalPosition,
                  currentHumidity: widget.currentHumidity,
                  clampTopLimit: widget.clampTopLimit,
                  clampBottomLimit: widget.clampBottomLimit,
                ),
              ),
            ),
            Positioned(
              top: Get.height * widget.verticalPosition - 20.h,
              left: 100.w,
              right: 0.w,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Palette.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Icon(Icons.arrow_drop_up, color: Palette.darkGrey, size: 24),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.arrow_drop_down, color: Palette.darkGrey, size: 24),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Get.height * widget.clampTopLimit - 8.h,
              width: 100.w,
              right: 80.w,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: leftSideScaleValues.length,
                itemBuilder: (_, i) {
                  final intCurrentHumidity = percentageRecalculation(widget.currentHumidity + 0.5).round();
                  int differenceDown = 0;
                  int differenceUp = 0;

                  if (i + 1 != leftSideScaleValues.length) {
                    differenceDown = leftSideScaleValues[i].round() - leftSideScaleValues[i + 1].round();
                  }

                  if (i != 0) {
                    differenceUp = leftSideScaleValues[i - 1].round() - leftSideScaleValues[i].round();
                  }

                  if (currentScaleValue != leftSideScaleValues[i].round() &&
                      (intCurrentHumidity >= leftSideScaleValues[i].round() - (differenceDown / 4).clamp(1, 2) &&
                          intCurrentHumidity <= leftSideScaleValues[i].round() + (differenceUp / 4).clamp(1, 2))) {
                    currentScaleValue = leftSideScaleValues[i].round();
                  }

                  return LeftSideScaleTile(
                    isShowWarning: leftSideScaleValues[i].round() <= 25 || leftSideScaleValues[i].round() >= 50,
                    value: leftSideScaleValues[i].round(),
                    differenceDown: differenceDown,
                    differenceUp: differenceUp,
                    currentHumidityValue: percentageRecalculation(widget.currentHumidity),
                    currentScaleValue: currentScaleValue,
                    verticalSpaceBetween:
                        ((widget.clampBottomLimit - widget.clampTopLimit) * Get.height - 9 * 16.sp * 1.15) / 9,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
