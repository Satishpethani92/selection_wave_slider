import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selection_wave_slider/src/wave_painter.dart';

class WaveSlider extends StatefulWidget {
  /// Creates a wave slider.
  ///
  /// When the state of the slider is changed the widget calls the [onChanged] callback.
  const WaveSlider({
    Key? key,
    required this.optionToChoose,
    this.selected,
    this.onDragStart,
    this.showDragMeUp = false,
    this.dragButton,
    this.toolTipBackgroundColor,
    required this.toolTipTextStyle,
    this.toolTipBorderColor,
    this.dragButtonColor,
    this.color = Colors.black,
    this.sliderPointColor = Colors.black,
    this.sliderPointBorderColor = Colors.white,
    required this.onChanged,
  }) : super(key: key);

  final Color? dragButtonColor;
  final Color? toolTipBackgroundColor;
  final Color? toolTipBorderColor;
  final TextStyle toolTipTextStyle;
  final Widget? dragButton;
  final List<String> optionToChoose;

  /// The color of the slider can be set by specifying a [color] - default is black.
  final Color color;
  final Color sliderPointColor;
  final Color sliderPointBorderColor;

  final bool showDragMeUp;
  final int? selected;
  final ValueChanged<int> onChanged;
  final ValueChanged<int>? onDragStart;

  @override
  WaveSliderState createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  double _dragPercentage = 0.0;
  double _sliderWidth = 0;

  late WaveSliderController _slideController;
  int dataSize = -1;
  double? toolTipWidth;
  @override
  void didUpdateWidget(WaveSlider oldWidget) {
    dataSize = widget.optionToChoose.length + 1;

    for (int i = 0; i < widget.optionToChoose.length; i++) {
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          text: widget.optionToChoose[i]);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      if (toolTipWidth == null) {
        toolTipWidth = tp.width;
      } else if (toolTipWidth! < tp.width) {
        toolTipWidth = tp.width;
      }
      ;
    }
    if (slectedIndex > dataSize) {
      slectedIndex = -1;
    }

    setState(() {});
  }

  @override
  void reassemble() {
    // print(toolTipWidth);
  }

  @override
  void initState() {
    super.initState();
    dataSize = widget.optionToChoose.length + 1;

    for (int i = 0; i < widget.optionToChoose.length; i++) {
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          text: widget.optionToChoose[i]);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      if (toolTipWidth == null) {
        toolTipWidth = tp.width;
      } else if (toolTipWidth! < tp.width) {
        toolTipWidth = tp.width;
      }
    }
    // print(toolTipWidth);

    WidgetsBinding.instance!.addPostFrameCallback((_) => {
          new Timer(Duration(milliseconds: 50), () {
            if (widget.selected != null) {
              slectedIndex = widget.selected!;
              var sliderwidth = _sliderWidth;
              var indexSize = dataSize;
              _slideController.setStateToStopping();
              setState(() {
                _dragPosition = (sliderwidth / indexSize) * (slectedIndex + 1);
                _dragPercentage = _dragPosition / _sliderWidth;
              });
            }
          })
        });

    _slideController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  updateSlider(int selected) {
    slectedIndex = selected;
    var sliderwidth = _sliderWidth;
    var indexSize = dataSize;
    _slideController.setStateToStopping();
    setState(() {
      _dragPosition = (sliderwidth / indexSize) * (selected + 1);
      _dragPercentage = _dragPosition / _sliderWidth;
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void calculateMiddlePoint(val) {
    var sliderwidth = _sliderWidth;
    var indexSize = dataSize;
    var currentPoint = val;
    var middleValue = (sliderwidth / indexSize) / 2;

    for (int i = 1; i < indexSize + 1; i++) {
      var end = (((sliderwidth / indexSize) * (i + 1)) - middleValue);
      var start = ((sliderwidth / indexSize) * (i)) - middleValue;
      if (i == 1) {
        start = -46;
      }
      if (i == indexSize - 1) {
        end = sliderwidth.toDouble() + (2 * middleValue);
      }
      if (currentPoint >= start && end > currentPoint) {
        slectedIndex = i - 1;
        widget.onChanged(slectedIndex);
        setState(() {
          _dragPosition = (sliderwidth / indexSize) * i;
          _dragPercentage = _dragPosition / _sliderWidth;
        });
        break;
      }
    }
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset localOffset = box.globalToLocal(start.globalPosition);

    offsettest = localOffset;
    _slideController.setStateToStart();
    var sliderwidth = _sliderWidth;
    var indexSize = dataSize;

    // print(indexSize);
    var index = (localOffset.dx) ~/ (sliderwidth / indexSize);
    if (widget.onDragStart != null && slectedIndex == -1) {
      widget.onDragStart!(index.clamp(0, indexSize - 2));
    }
    if (index == 0) index = 1;
    if (index == indexSize - 1) index = indexSize - 2;
    if (index < indexSize - 1) {
      previousText = widget.optionToChoose[index - 1];
      nextText = widget.optionToChoose[index];
    } else {
      index = indexSize - 2;
      previousText = widget.optionToChoose[index - 1];
      nextText = widget.optionToChoose[index];
    }

    double nextTextOpacity =
        ((localOffset.dx) / (sliderwidth / indexSize) - index).clamp(.0, 1.0);
    if (nextTextOpacity < 0) nextTextOpacity = 0;
    if (nextTextOpacity > 1) nextTextOpacity = 1;

    double previoutTextOpacity = 1 - nextTextOpacity;
    next = PainTextData(opacity: nextTextOpacity, text: nextText!);
    previous = PainTextData(opacity: previoutTextOpacity, text: previousText!);

    if ((sliderwidth / indexSize) * 1 < localOffset.dx - 30 &&
        (sliderwidth / indexSize) * (indexSize - 1) + 30 > localOffset.dx) {
      setState(() {
        _dragPosition = localOffset.dx;
        _dragPercentage = _dragPosition / _sliderWidth;
      });
    }
  }

  Offset? offsettest;
  String? previousText;
  String? nextText;
  PainTextData? next;
  PainTextData? previous;
  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset localOffset = box.globalToLocal(update.globalPosition);

    var sliderwidth = _sliderWidth;
    var indexSize = dataSize;
    // print(indexSize);
    var index = (localOffset.dx) ~/ (sliderwidth / indexSize);
    if (index == 0) index = 1;
    if (index == indexSize - 1) index = indexSize - 2;
    if (index < indexSize - 1) {
      previousText = widget.optionToChoose[index - 1];
      nextText = widget.optionToChoose[index];
    } else {
      index = indexSize - 2;
      previousText = widget.optionToChoose[index - 1];
      nextText = widget.optionToChoose[index];
    }

    double nextTextOpacity =
        ((localOffset.dx) / (sliderwidth / indexSize) - index).clamp(.0, 1.0);
    if (nextTextOpacity < 0) nextTextOpacity = 0;
    if (nextTextOpacity > 1) nextTextOpacity = 1;

    double previoutTextOpacity = 1 - nextTextOpacity;
    next = PainTextData(opacity: nextTextOpacity, text: nextText!);
    previous = PainTextData(opacity: previoutTextOpacity, text: previousText!);

    offsettest = localOffset;
    _slideController.setStateToSliding();

    if ((sliderwidth / indexSize) - 30 < localOffset.dx &&
        (sliderwidth / indexSize) * (indexSize - 1) + 30 > localOffset.dx) {
      setState(() {
        _dragPosition = localOffset.dx;
        _dragPercentage = _dragPosition / _sliderWidth;
      });
    }
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    _slideController.setStateToStopping();
    calculateMiddlePoint(offsettest!.dx);

    setState(() {});
  }

  int slectedIndex = -1;
  double sizeCircle = 17;
  double targetSize = 25;

  double? widthMul;
  double? heightMul;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    widthMul = width / 414;
    heightMul = height / 896;
    var heightExtra = widget.showDragMeUp ? (70 * heightMul!) : 0;
    return Container(
      height: (110 + heightExtra).toDouble(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _sliderWidth = constraints.maxWidth;
          return Container(
            child: Column(
              children: [
                /*_buildSliderTooltip(),*/
                Stack(
                  children: [
                    _buildSlider(),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  double objectRadius = 18;
  double objectPadding = 9;
  _buildSlider() {
    // print(_dragPosition);
    // print(_dragPercentage);
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            width: _sliderWidth,
            height: 50,
            child: CustomPaint(
              painter: WavePainter(
                nextText: next,
                prevText: previous,
                toolTipWidth: toolTipWidth!,
                selectedText: slectedIndex != -1 &&
                        slectedIndex < widget.optionToChoose.length
                    ? widget.optionToChoose[slectedIndex]
                    : "",
                dragButtonColor: widget.dragButtonColor!,
                toolTipBackgroundColor: widget.toolTipBackgroundColor!,
                toolTipBorderColor: widget.toolTipBorderColor!,
                toolTipTextStyle: widget.toolTipTextStyle,
                optionToChoose: widget.optionToChoose,
                color: widget.color,
                sliderPointColor: widget.sliderPointColor,
                sliderPointBorderColor: widget.sliderPointBorderColor,
                sliderPosition: _dragPosition,
                dragPercentage: _dragPercentage,
                sliderState: _slideController.state,
                animationProgress: _slideController.progress,
              ),
            ),
          ),
          if (slectedIndex != -1)
            Positioned(
                top: 0,
                bottom: 0,
                left: _dragPosition - 18,
                child: Center(
                    child: Container(
                  color: Colors.transparent,
                  height: objectRadius * 2,
                  width: objectRadius * 2,
                  padding: EdgeInsets.all(objectPadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(objectRadius),
                    child: widget.dragButton,
                  ),
                )))
        ],
      ),
      onHorizontalDragStart: (DragStartDetails start) =>
          _onDragStart(context, start),
      onHorizontalDragUpdate: (DragUpdateDetails update) =>
          _onDragUpdate(context, update),
      onHorizontalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
    );
  }
}

class PainTextData {
  String text;
  double opacity;

  PainTextData({required this.text, required this.opacity});
}

class WaveSliderController extends ChangeNotifier {
  WaveSliderController({required TickerProvider vsync})
      : controller = AnimationController(vsync: vsync) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final AnimationController controller;
  SliderState _state = SliderState.initial;

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _startAnimation() {
    controller.duration = Duration(milliseconds: 500);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }
}
