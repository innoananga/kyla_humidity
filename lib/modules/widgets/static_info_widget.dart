import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources /colors.dart';

class StaticInfoWidget extends StatelessWidget {
  final String title;
  final String value;

  const StaticInfoWidget({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Palette.chartDarkGrey, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(color: Palette.white, fontSize: 22.sp, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
