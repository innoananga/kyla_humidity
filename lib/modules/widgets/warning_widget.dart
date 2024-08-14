import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../resources /colors.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: Palette.yellow,
          size: 24,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2.h),
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Palette.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              ' – extreme humidity levels.',
              style: TextStyle(color: Palette.white, fontSize: 9.sp, height: 1.62),
            ),
          ],
        ),
        Text(
          'Use precaution for set-points outside of 20%-55%.',
          style: TextStyle(color: Palette.white, fontSize: 9.sp, height: 1.62),
        ),
      ],
    );
  }
}
