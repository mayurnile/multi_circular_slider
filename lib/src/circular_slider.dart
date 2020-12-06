library circular_slider;

import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'progress_bar_painter.dart';

class MultiCircularSlider extends StatefulWidget {
  final double size;
  final double trackWidth;
  final double progressBarWidth;
  final List<double> values;
  final List<Color> colors;
  final Color trackColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget innerWidget;
  final Widget innerIcon;
  final bool showTotalPercentage;
  final String label;
  final TextStyle percentageTextStyle;
  final TextStyle labelTextStyle;

  ///A widget to make multiple progress bar to show
  ///multiple values in a single bar
  ///
  ///For example to show storage space taken up by different types of files in File Manager
  ///
  ///
  ///`values` pass different percentages you want to show which sum up to 1.0 or less
  ///
  ///
  ///
  ///`color` different colors which you want to give to the progress bars
  ///
  ///NOTE : Length of values should be equal to length of colors
  ///
  ///
  ///
  ///`size` the space widget should take up on screen
  ///
  ///
  ///
  ///`trackWidth` stroke width of the progressBar track
  ///
  ///default values is set to 32.0
  ///
  ///
  ///
  ///`progressBarWidth` stroke width of the progressBar
  ///
  ///default values is set to 32.0
  ///
  ///
  ///
  ///`animationDuration` the duration you want for the animation
  ///
  ///default values is set to 1000 milliseconds
  ///
  ///
  ///
  ///`animationCurve` the curve you want for animation
  ///
  ///default values is set to Curves.easeInOutCubic
  ///
  ///
  ///
  ///`innerWidget` the widget you want to show inside the circular progress bar
  ///
  ///NOTE : innerWidget will only de displayed if showTotalPercentage is false
  ///
  ///
  ///
  ///`innerIcon` the icon which you can display above the total percentage text
  ///
  ///
  ///
  ///`showTotalPercentage` whether to show total percentage in center or not
  ///
  ///default values is set to true
  ///
  ///
  ///
  ///`label` any label text which you want to show below total percentage
  ///
  ///
  ///
  ///`labelTextStyle` TextStyle which you want to give to label
  ///
  ///
  ///
  ///`percentageTextStyle` TextStyle which you want to give to percentage
  ///
  MultiCircularSlider({
    Key key,
    @required this.values,
    @required this.colors,
    @required this.size,
    this.trackWidth = 32.0,
    this.progressBarWidth = 32.0,
    this.trackColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOutCubic,
    this.innerWidget,
    this.innerIcon,
    this.showTotalPercentage = true,
    this.label,
    this.labelTextStyle,
    this.percentageTextStyle,
  }) : super(key: key);

  @override
  _MultiCircularSliderState createState() => _MultiCircularSliderState();
}

class _MultiCircularSliderState extends State<MultiCircularSlider> with SingleTickerProviderStateMixin {
  //for animation
  AnimationController _controller;
  Animation<double> _animation;

  //for calculation
  double percentage = 0.0;

  @override
  void initState() {
    super.initState();

    widget.values.forEach((value) {
      percentage += value;
    });

    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.animationCurve));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return CustomPaint(
          painter: ProgressBarPainter(
            size: widget.size,
            values: List.generate(widget.values.length, (index) => widget.values[index] * _animation.value),
            colors: widget.colors,
            progressBarWidth: widget.progressBarWidth,
            trackColor: widget.trackColor,
            trackWidth: widget.trackWidth,
          ),
          child: Container(
            height: widget.size,
            width: widget.size,
            padding: const EdgeInsets.all(42.0),
            child: widget.innerWidget != null
                ? widget.innerWidget
                : Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10.0,
                    offset: Offset(0.0, -18.0),
                  ),
                ],
              ),
              child: widget.showTotalPercentage
                  ? Column(
                children: [
                  //inner icon
                  widget.innerIcon != null ? widget.innerIcon : SizedBox.shrink(),
                  //total percentage
                  Text(
                    '${(percentage * _animation.value * 100).ceil()}%',
                    textAlign: TextAlign.center,
                    style: widget.percentageTextStyle != null
                        ? widget.percentageTextStyle
                        : TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 28.0,
                      color: Color(0xFF012C61),
                    ),
                  ),
                  //spacing
                  SizedBox(height: 8.0),
                  //text
                  widget.label != null
                      ? FittedBox(
                    child: Text(
                      widget.label,
                      style: widget.labelTextStyle != null
                          ? widget.labelTextStyle
                          : TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                        color: Color(0xFF939AA4),
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        );
      },
      child: widget.innerWidget != null ? widget.innerWidget : SizedBox.shrink(),
    );
  }
}
