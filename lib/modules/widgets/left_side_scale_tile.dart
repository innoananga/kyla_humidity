import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources /colors.dart';

class LeftSideScaleTile extends StatefulWidget {
  final int value;
  final bool isShowWarning;
  final int differenceUp;
  final int differenceDown;
  final double currentHumidityValue;
  final int? currentScaleValue;
  final double verticalSpaceBetween;

  const LeftSideScaleTile({
    required this.value,
    required this.isShowWarning,
    required this.differenceUp,
    required this.differenceDown,
    required this.currentHumidityValue,
    required this.currentScaleValue,
    required this.verticalSpaceBetween,
    super.key,
  });

  @override
  State<LeftSideScaleTile> createState() => _LeftSideScaleTileState();
}

class _LeftSideScaleTileState extends State<LeftSideScaleTile> with TickerProviderStateMixin {
  late AnimationController _sizeAnimationController;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _offsetAnimation;
  double _offset = 0.0;

  Color _textColor = Palette.white;
  String? _textFieldValue;

  @override
  void initState() {
    if (widget.value == widget.currentHumidityValue.round()) {
      _textColor = Palette.blue;
    }
    _textFieldValue = '${widget.value.toString()}%';

    _sizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(_sizeAnimationController);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, _offset),
    ).animate(_sizeAnimationController);

    _sizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {}
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LeftSideScaleTile oldWidget) {
    if (widget.currentHumidityValue != oldWidget.currentHumidityValue ||
        widget.currentScaleValue != oldWidget.currentScaleValue) {
      _onDragCloseToPoint();

      if (widget.currentHumidityValue == widget.value) {
        _offset = 0.0;
      } else if (widget.currentHumidityValue > widget.value - widget.differenceDown &&
          widget.currentHumidityValue < widget.value) {
        _offset = (1.8.h * (100 * (widget.value - widget.currentHumidityValue) / widget.differenceDown) / 100);
      } else if (widget.currentHumidityValue < widget.value + widget.differenceUp &&
          widget.currentHumidityValue > widget.value) {
        _offset = (1.8.h * (100 * (widget.value - widget.currentHumidityValue) / widget.differenceUp) / 100);
      }
      _offsetAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, _offset),
      ).animate(_sizeAnimationController);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onDragCloseToPoint() {
    if (widget.currentHumidityValue > widget.value - widget.differenceDown &&
        widget.currentHumidityValue < widget.value + widget.differenceUp &&
        widget.currentScaleValue == widget.value &&
        (_sizeAnimationController.status == AnimationStatus.dismissed ||
            _sizeAnimationController.status == AnimationStatus.completed)) {
      _textColor = Palette.blue;
      _textFieldValue = '${widget.currentHumidityValue.round()}%';

      _sizeAnimationController.forward();
    } else if (widget.currentScaleValue != widget.value &&
        _sizeAnimationController.status == AnimationStatus.completed) {
      _textColor = Palette.white;
      _textFieldValue = '${widget.value.toString()}%';

      _sizeAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: widget.verticalSpaceBetween),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Row(
          children: [
            if (widget.isShowWarning)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Container(
                  width: 5.w,
                  height: 5.h,
                  decoration: const BoxDecoration(
                    color: Palette.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              SizedBox(
                width: 13.w,
              ),
            ScaleTransition(
              scale: _sizeAnimation,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                style: TextStyle(color: _textColor, fontSize: 16.sp, fontWeight: FontWeight.w700, height: 1.15),
                child: Text(
                  _textFieldValue ?? '${widget.value}%',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
