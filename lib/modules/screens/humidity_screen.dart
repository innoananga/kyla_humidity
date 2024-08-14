import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources /colors.dart';
import '../widgets/humidity_details.dart';
import '../widgets/humidity_vertical_bar.dart';

class HumidityScreen extends StatefulWidget {
  const HumidityScreen({super.key});

  @override
  _HumidityScreenState createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> with TickerProviderStateMixin {
  double _verticalPosition = 0.4;

  double _currentHumidity = 67.0;
  double _newHumidity = 67.0;

  final _clampBottomLimit = 0.8;
  final _clampTopLimit = 0.2;

  late AnimationController _previousValueAnimationController;
  late AnimationController _newValueAnimationController;

  late Animation<Offset> _previousHumidityOffset;
  late Animation<Offset> _newHumidityOffset;
  late Animation<double> _previousHumidityOpacity;
  late Animation<double> _newHumidityOpacity;

  @override
  void initState() {
    _previousValueAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _newValueAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _previousHumidityOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.3),
    ).animate(_previousValueAnimationController);

    _newHumidityOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(_newValueAnimationController);

    _previousHumidityOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_previousValueAnimationController);

    _newHumidityOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_newValueAnimationController);

    super.initState();
  }

  void _updatePosition(Offset localPosition, double maxHeight) {
    setState(() {
      _verticalPosition = (localPosition.dy / maxHeight).clamp(_clampTopLimit, _clampBottomLimit);
      final double normalizedPosition = (_verticalPosition - _clampTopLimit) / (_clampBottomLimit - _clampTopLimit);
      _newHumidity = 100 * (1 - normalizedPosition).abs();
    });
  }

  void _onDragEnd() {
    if (_currentHumidity != _newHumidity) {
      _previousValueAnimationController.reset();
      _newValueAnimationController.reset();
      _previousValueAnimationController.forward().then((_) {
        setState(() {
          _currentHumidity = _newHumidity;
        });
        _newValueAnimationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 65.h, right: 15.w),
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.more_horiz,
                  color: Palette.white,
                  size: 30,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HumidityVerticalBar(
                  verticalPosition: _verticalPosition,
                  onPositionChanged: _updatePosition,
                  onVerticalDragEnd: _onDragEnd,
                  currentHumidity: _newHumidity,
                  clampBottomLimit: _clampBottomLimit,
                  clampTopLimit: _clampTopLimit,
                ),
                SizedBox(width: 20.w),
                HumidityDetails(
                  currentHumidity: _currentHumidity,
                  previousHumidityOffset: _previousHumidityOffset,
                  newHumidityOffset: _newHumidityOffset,
                  previousHumidityOpacity: _previousHumidityOpacity,
                  newHumidityOpacity: _newHumidityOpacity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _previousValueAnimationController.dispose();
    _newValueAnimationController.dispose();
    super.dispose();
  }
}
