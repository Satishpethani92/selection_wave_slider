import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selection_wave_slider/src/wave_slider.dart';

class WaveSliderWithDragPoint extends StatefulWidget {
  final List<String> optionToChoose;
  WaveSliderWithDragPoint(
      {required this.optionToChoose,
      this.toolTipBackgroundColor = Colors.transparent,
      this.dragButtonColor = Colors.black,
      this.toolTipBorderColor = Colors.black,
      this.toolTipTextStyle,
      this.sliderHeight = 100,
      this.selected,
      this.dragButton,
      this.sliderColor = Colors.black,
      this.sliderPointColor = Colors.white,
      this.sliderPointBorderColor = Colors.black,
      required this.onSelected})
      : assert(sliderHeight! >= 80 &&
            optionToChoose.length > 0 &&
            optionToChoose.length <= 10);
  final Color dragButtonColor;
  final Color toolTipBackgroundColor;
  TextStyle? toolTipTextStyle;
  final Color toolTipBorderColor;
  Widget? dragButton;
  final Color? sliderColor;
  final Color? sliderPointColor;
  final double? sliderHeight;
  final Color? sliderPointBorderColor;

  final int? selected;
  ValueChanged<int> onSelected;
  @override
  _WaveSliderWithDragPointState createState() =>
      _WaveSliderWithDragPointState();
}

class _WaveSliderWithDragPointState extends State<WaveSliderWithDragPoint> {
  double circleRadius = 15;

  late double width;
  double? x;
  double? y;
  double? tempX, tempY;
  double objectRadius = 18;
  double objectPadding = 9;
  int? selectedAns;
  bool isLoading = false;
  int centerPadding = 25;

  final GlobalKey<WaveSliderState> _key = GlobalKey();
  @override
  void initState() {
    if (widget.selected != null &&
        widget.selected! < widget.optionToChoose.length) {
      selectedAns = widget.selected!;
    }

    super.initState();
  }

  @override
  void didUpdateWidget(WaveSliderWithDragPoint oldWidget) {
    if (widget.selected != null &&
        widget.selected! < widget.optionToChoose.length) {
      selectedAns = widget.selected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;

        if (x == null && y == null) {
          x = (width / 2) - objectRadius;
          y = widget.sliderHeight! - (objectRadius + objectPadding);
        }
        if (tempX == null && tempY == null) {
          tempX = x!;
          tempY = y!;
        }
        return Container(
          height: widget.sliderHeight!,
          width: width,
          child: Stack(
            // overflow: Overflow.visible,
            children: [
              WaveSlider(
                key: _key,
                selected: selectedAns,
                color: widget.sliderColor!,
                sliderPointColor: widget.sliderPointColor!,
                sliderPointBorderColor: widget.sliderPointBorderColor!,
                optionToChoose: widget.optionToChoose,
                toolTipBackgroundColor: widget.toolTipBackgroundColor,
                toolTipBorderColor: widget.toolTipBorderColor,
                toolTipTextStyle: widget.toolTipTextStyle != null
                    ? widget.toolTipTextStyle!
                    : TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                dragButtonColor: widget.dragButtonColor,
                dragButton: widget.dragButton != null
                    ? widget.dragButton
                    : Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.black),
                          padding: EdgeInsets.all(5),
                          height: 18,
                          width: 18,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                onDragStart: (value) {
                  if (selectedAns == null) {
                    selectedAns = value;
                    _key.currentState!.updateSlider(selectedAns!);
                    widget.onSelected(selectedAns!);
                    setState(() {});
                  }
                },
                onChanged: (value) {
                  selectedAns = value;
                  widget.onSelected(selectedAns!);
                  setState(() {});
                },
              ),
              Visibility(
                child: AnimatedPositioned(
                  top: tempY!,
                  left: tempX!,
                  duration: Duration(
                      milliseconds: tempY! ==
                              widget.sliderHeight! -
                                  (objectRadius + objectPadding)
                          ? 200
                          : 1),
                  child: GestureDetector(
                    onPanStart: (details) {},
                    onPanUpdate: (details) {
                      double x = details.localPosition.dx;
                      double y = details.localPosition.dy;
                      this.tempX = this.x! + x - objectRadius;
                      if (this.y! + y - objectRadius + 18 <
                          widget.sliderHeight!) {
                        this.tempY = this.y! + y - objectRadius;
                      }
                      if (tempY! < 10) {
                        int options = widget.optionToChoose.length;
                        if (tempX! < (width / (options + 1))) {
                          selectedAns = 0;
                        } else if (tempX! > (width / (options + 1)) * options) {
                          selectedAns = options - 1;
                        } else {
                          int startValue =
                              (tempX! + 18) ~/ (width / (options + 1));
                          double value =
                              (tempX! + 18) / (width / (options + 1));

                          if (value < (startValue + 0.5)) {
                            selectedAns = startValue - 1;
                          } else {
                            selectedAns = startValue;
                          }
                        }
                        _key.currentState!.updateSlider(selectedAns!);
                      }
                      setState(() {});
                    },
                    onPanEnd: (details) {
                      if (tempY! + objectRadius > 40) {
                        circleRadius = 30;
                        centerPadding = 25;
                        tempY = widget.sliderHeight! -
                            (objectRadius + objectPadding);
                        tempX = (width / 2) - objectRadius;
                      } else {
                        int options = widget.optionToChoose.length;
                        if (tempX! < (width / (options + 1))) {
                          selectedAns = 0;
                        } else if (tempX! > (width / (options + 1)) * options) {
                          selectedAns = options - 1;
                        } else {
                          int startValue =
                              (tempX! + 18) ~/ (width / (options + 1));
                          double value =
                              (tempX! + 18) / (width / (options + 1));

                          if (value < (startValue + 0.5)) {
                            selectedAns = startValue - 1;
                          } else {
                            selectedAns = startValue;
                          }
                        }
                        _key.currentState!.updateSlider(selectedAns!);
                      }
                      y = tempY!;
                      x = tempX!;

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: objectRadius * 2,
                      width: objectRadius * 2,
                      padding: EdgeInsets.all(objectPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(objectRadius),
                        child: widget.dragButton != null
                            ? widget.dragButton
                            : Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.black),
                                  padding: EdgeInsets.all(5),
                                  height: 18,
                                  width: 18,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                visible: selectedAns == null,
              ),
            ],
          ),
        );
      },
    );
  }
}
