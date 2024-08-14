import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kyla_test/modules/widgets/static_info_widget.dart';
import 'package:kyla_test/modules/widgets/warning_widget.dart';

import '../resources /colors.dart';
import '../utils/percentage_recalculation.dart';
import 'animated_percentage_info_widget.dart';

class HumidityDetails extends StatelessWidget {
  final double currentHumidity;
  final Animation<Offset> previousHumidityOffset;
  final Animation<Offset> newHumidityOffset;
  final Animation<double> previousHumidityOpacity;
  final Animation<double> newHumidityOpacity;

  const HumidityDetails({
    required this.currentHumidity,
    required this.previousHumidityOffset,
    required this.newHumidityOffset,
    required this.previousHumidityOpacity,
    required this.newHumidityOpacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          const StaticInfoWidget(
            title: 'RETURN TEMPERATURE',
            value: '20°C',
          ),
          SizedBox(height: 24.h),
          Text(
            'CURRENT HUMIDITY',
            style: TextStyle(color: Palette.chartDarkGrey, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          AnimatedPercentageInfoWidget(
            percentValue: percentageRecalculation(currentHumidity).round(),
            previousValueOffset: previousHumidityOffset,
            currentValueOffset: newHumidityOffset,
            previousValueOpacity: previousHumidityOpacity,
            currentValueOpacity: newHumidityOpacity,
          ),
          SizedBox(height: 24.h),
          const StaticInfoWidget(
            title: 'ABSOLUTE HUMIDITY',
            value: '4gr/ft3',
          ),
          SizedBox(height: 24.h),
          const WarningWidget(),
        ],
      ),
    );
  }
}
