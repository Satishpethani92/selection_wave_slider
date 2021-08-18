import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:selection_wave_slider/src/wave_slider.dart';
import 'package:path_drawing/path_drawing.dart';

class WavePainter extends CustomPainter {
  WavePainter({
    required this.selectedText,
    required this.sliderPosition,
    required this.dragPercentage,
    required this.animationProgress,
    required this.dragButtonColor,
    required this.toolTipBackgroundColor,
    required this.toolTipBorderColor,
    required this.toolTipTextStyle,
    required this.sliderState,
    required this.optionToChoose,
    required this.color,
    required this.sliderPointBorderColor,
    required this.sliderPointColor,
    required this.toolTipWidth,
    // this.displayTrackball = false,
    this.prevText,
    this.nextText,
  })  : wavePainter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
        fillPainter = Paint()
          ..color = sliderPointBorderColor
          ..style = PaintingStyle.fill,
        fillPainter2 = Paint()
          ..color = sliderPointColor
          ..style = PaintingStyle.fill,
        dragPointPainter = Paint()
          ..color = dragButtonColor
          ..style = PaintingStyle.fill;

  final double sliderPosition;
  final double dragPercentage;
  final double animationProgress;
  final List<String> optionToChoose;
  final SliderState sliderState;
  final double toolTipWidth;
  // final bool displayTrackball;

  final Color color;
  final Color sliderPointColor;
  final Color sliderPointBorderColor;
  final Color toolTipBackgroundColor;
  final Color toolTipBorderColor;
  final TextStyle toolTipTextStyle;
  final String selectedText;
  final PainTextData? prevText;
  final PainTextData? nextText;
  final Color dragButtonColor;

  final Paint wavePainter;
  final Paint fillPainter;
  final Paint dragPointPainter;

  /// Previous slider position initialised at the [anchorRadius], which is the start
  double _previousSliderPosition = anchorRadius;

  static const double anchorRadius = 4;

  double minWaveHeight = 100;
  double maxWaveHeight = 100;
  var fillPainter2;

  @override
  void paint(Canvas canvas, Size size) {
    final Size restrictedSize = Size(size.width, size.height);
    // _paintAnchors(canvas, restrictedSize);
    minWaveHeight = restrictedSize.height * 0.2;
    maxWaveHeight = restrictedSize.height * 0.8;
    switch (sliderState) {
      case SliderState.starting:
        _paintSlidingWave(canvas, restrictedSize);
        break;
      case SliderState.resting:
        _paintSlidingWave(canvas, restrictedSize);
        break;
      case SliderState.sliding:
        _paintSlidingWave(canvas, restrictedSize);
        break;
      case SliderState.stopping:
        _paintSlidingWave(canvas, restrictedSize);
        break;
      case SliderState.initial:
        _paintRestingWave(canvas, restrictedSize);
        break;
      default:
        _paintSlidingWave(canvas, restrictedSize);
        break;
    }
  }

  void _paintAnchors(Canvas canvas, Size size) {
    int dataLength = optionToChoose.length + 1;
    double positionY = size.height / 2;
    for (int i = 1; i < dataLength; i++) {
      canvas.drawCircle(Offset((size.width / dataLength) * i, positionY),
          anchorRadius, fillPainter);
      canvas.drawCircle(Offset((size.width / dataLength) * i, positionY),
          anchorRadius - 1, fillPainter2);
    }
  }

  void _paintRestingWave(Canvas canvas, Size size) {
    double positionY = size.height / 2;
    final Path path = Path();
    path.moveTo(anchorRadius, positionY);
    path.lineTo(size.width, positionY);
    canvas.drawPath(path, wavePainter);
    _paintAnchors(canvas, size);
  }

  void _paintSlidingWave(Canvas canvas, Size size) {
    final WaveCurveDefinitions line = _calculateWaveLineDefinitions(size);
    _paintWaveLine(canvas, size, line);

    _paintTrackball(canvas, size, waveCurve: line);
  }

  void _paintWaveLine(
      Canvas canvas, Size size, WaveCurveDefinitions waveCurve) {
    double positionY = size.height / 2;
    final Path path = Path();

    path.moveTo(anchorRadius, positionY);
    path.lineTo(waveCurve.startOfBezier, positionY);
    path.cubicTo(
        waveCurve.leftControlPoint1,
        positionY,
        waveCurve.leftControlPoint2,
        waveCurve.controlHeight,
        waveCurve.centerPoint,
        waveCurve.controlHeight);
    path.cubicTo(
        waveCurve.rightControlPoint1,
        waveCurve.controlHeight,
        waveCurve.rightControlPoint2,
        positionY,
        waveCurve.endOfBezier,
        positionY);
    path.lineTo(size.width, positionY);

    canvas.drawPath(path, wavePainter);
    _paintAnchors(canvas, size);
  }

  void _paintTrackball(Canvas canvas, Size size,
      {required WaveCurveDefinitions waveCurve}) {
    double indicatorSize = minWaveHeight;
    double centerPoint = sliderPosition, controlHeight = size.height;
    centerPoint = (centerPoint > size.width) ? size.width : centerPoint;
    centerPoint = waveCurve.centerPoint;
    controlHeight = waveCurve.controlHeight;

    indicatorSize = (size.height - controlHeight) / 2.5;

    if (indicatorSize < minWaveHeight) {
      indicatorSize = minWaveHeight;
    }
    indicatorSize = 8.5;

    var width = toolTipWidth;

    TextPainter tp;
    TextPainter? tp2;
    if (SliderState.sliding == sliderState) {
      TextSpan span = new TextSpan(
          style: toolTipTextStyle.apply(
              color: toolTipTextStyle.color != null
                  ? toolTipTextStyle.color!.withOpacity(prevText!.opacity)
                  : Colors.black.withOpacity(prevText!.opacity)),
          text: prevText!.text);
      tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();

      TextSpan span2 = new TextSpan(
          style: toolTipTextStyle.apply(
              color: toolTipTextStyle.color != null
                  ? toolTipTextStyle.color!.withOpacity(nextText!.opacity)
                  : Colors.black.withOpacity(nextText!.opacity)),
          text: nextText!.text);
      tp2 = new TextPainter(
          text: span2,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp2.layout();
    } else {
      TextSpan span = new TextSpan(
          style: toolTipTextStyle.apply(
              color: toolTipTextStyle.color != null
                  ? toolTipTextStyle.color
                  : Colors.black),
          text: selectedText);
      tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
    }
    if (tp2 != null) {
      width = tp.width > tp2.width ? tp.width : tp2.width;
    } else {
      width = tp.width;
    }
    var paint1 = Paint()
      ..strokeWidth = 1
      ..color = toolTipBorderColor
      ..style = PaintingStyle.stroke;
    var paint2 = Paint()
      ..strokeWidth = 1
      ..color = toolTipBackgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(
        dashPath(
            Path()
              ..addRRect(RRect.fromRectAndRadius(
                  Rect.fromLTWH(
                    centerPoint - (width + 20) / 2,
                    -40,
                    width + 20,
                    30,
                  ),
                  Radius.circular(8.0))),
            dashArray: CircularIntervalList<double>(
              <double>[6, 3],
            )),
        paint1);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTWH(
                centerPoint - (width + 16) / 2,
                -38,
                width + 16,
                26,
              ),
              Radius.circular(8.0))),
        paint2);
    tp.paint(
        canvas,
        new Offset(centerPoint - (tp.size.width) / 2,
            -40 + (15 - (tp.size.height) / 2)));
    if (tp2 != null) {
      tp2.paint(
          canvas,
          new Offset(centerPoint - (tp2.size.width) / 2,
              -40 + (15 - (tp2.size.height) / 2)));
    }
  }

  WaveCurveDefinitions _calculateWaveLineDefinitions(Size size) {
    final double controlHeight = 5;

    final double bendWidth = (20 + 20).toDouble();
    final double bezierWidth = (20 + 20).toDouble();

    double centerPoint = sliderPosition;
    centerPoint = (centerPoint > size.width) ? size.width : centerPoint;

    double startOfBend = centerPoint - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = sliderPosition + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    startOfBend = (startOfBend <= anchorRadius) ? anchorRadius : startOfBend;
    startOfBezier =
        (startOfBezier <= anchorRadius) ? anchorRadius : startOfBezier;
    endOfBend = (endOfBend > size.width) ? size.width : endOfBend;
    endOfBezier = (endOfBezier > size.width) ? size.width : endOfBezier;

    double leftBendControlPoint1 = startOfBend;
    double leftBendControlPoint2 = startOfBend;
    double rightBendControlPoint1 = endOfBend;
    double rightBendControlPoint2 = endOfBend;

    const double bendability = 25.0;
    const double maxSlideDifference = 30.0;
    double slideDifference = (sliderPosition - _previousSliderPosition).abs();

    slideDifference = (slideDifference > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    double bend =
        lerpDouble(0.0, bendability, slideDifference / maxSlideDifference)!;
    final bool moveLeft = sliderPosition < _previousSliderPosition;
    bend = moveLeft ? -bend : bend;

    leftBendControlPoint1 = leftBendControlPoint1 + bend;
    leftBendControlPoint2 = leftBendControlPoint2 - bend;
    rightBendControlPoint1 = rightBendControlPoint1 - bend;
    rightBendControlPoint2 = rightBendControlPoint2 + bend;

    centerPoint = centerPoint - bend;

    final WaveCurveDefinitions waveCurveDefinitions = WaveCurveDefinitions(
      controlHeight: controlHeight,
      startOfBezier: startOfBezier,
      endOfBezier: endOfBezier,
      leftControlPoint1: leftBendControlPoint1,
      leftControlPoint2: leftBendControlPoint2,
      rightControlPoint1: rightBendControlPoint1,
      rightControlPoint2: rightBendControlPoint2,
      centerPoint: centerPoint,
    );

    return waveCurveDefinitions;
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    final double diff = _previousSliderPosition - oldDelegate.sliderPosition;
    if (diff.abs() > 20) {
      _previousSliderPosition = sliderPosition;
    } else {
      _previousSliderPosition = oldDelegate.sliderPosition;
    }
    return true;
  }
}

enum SliderState { starting, resting, sliding, stopping, initial }

class WaveCurveDefinitions {
  WaveCurveDefinitions({
    required this.startOfBezier,
    required this.endOfBezier,
    required this.leftControlPoint1,
    required this.leftControlPoint2,
    required this.rightControlPoint1,
    required this.rightControlPoint2,
    required this.controlHeight,
    required this.centerPoint,
  });

  double startOfBezier;
  double endOfBezier;
  double leftControlPoint1;
  double leftControlPoint2;
  double rightControlPoint1;
  double rightControlPoint2;
  double controlHeight;
  double centerPoint;
}
