library circular_slider;

import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'circular_progress_bar_painter.dart';
part 'linear_progress_bar_painter.dart';

enum MultiCircularSliderType {
  // to create a linear progress bar
  linear,
  // to create a circular progress bar
  circular,
}

class MultiCircularSlider extends StatefulWidget {
  final double size;
  final MultiCircularSliderType progressBarType;
  final double trackWidth;
  final double progressBarWidth;
  final List<double> values;
  final List<Color> colors;
  final Color trackColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget? innerWidget;
  final Widget? innerIcon;
  final bool showTotalPercentage;
  final String? label;
  final TextStyle? percentageTextStyle;
  final TextStyle? labelTextStyle;

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
  ///`colors` different colors which you want to give to the progress bars
  ///
  ///NOTE : Length of values should be equal to length of colors
  ///
  ///
  ///
  ///`size` the space widget should take up on screen
  ///
  ///
  ///`progressBarType` the type of progress bar you want to show
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
  ///`trackColor` color of the track of progressBar
  ///
  ///default values is set to Colors.grey
  ///
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
  const MultiCircularSlider({
    Key? key,
    required this.values,
    required this.colors,
    required this.size,
    required this.progressBarType,
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
  MultiCircularSliderState createState() => MultiCircularSliderState();
}

class MultiCircularSliderState extends State<MultiCircularSlider> with SingleTickerProviderStateMixin {
  //for animation
  late AnimationController _controller;
  late Animation<double> _animation;

  //for calculation
  double percentage = 0.0;

  @override
  void initState() {
    super.initState();

    //calculating total percentage
    for (final value in widget.values) {
      percentage += value;
    }

    //initializing controller
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);

    //initializing animation
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.animationCurve));

    //starting animation
    _controller.forward();
  }

  @override
  void dispose() {
    //dispose controller to avoid memory leaks
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //actual widget starts here
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        //custom painter to draw multiple progress bar
        return widget.progressBarType == MultiCircularSliderType.circular ? _buildCircularProgressBar() : _buildLinearProgressBar();
      },
      child: widget.innerWidget ?? const SizedBox.shrink(),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildCircularProgressBar() => CustomPaint(
        painter: _buildProgressBarPainter(),
        //inner widget with shadow
        child: Container(
          height: widget.size,
          width: widget.size,
          padding: const EdgeInsets.all(42.0),
          child: widget.innerWidget ??
              Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10.0,
                      offset: const Offset(0.0, -18.0),
                    ),
                  ],
                ),
                child: widget.showTotalPercentage
                    ? Column(
                        children: [
                          //inner icon
                          _buildInnerIcon(),
                          //total percentage
                          _buildTotalPercentage(),
                          //spacing
                          const SizedBox(height: 8.0),
                          //text
                          _buildTextWidget(),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
        ),
      );

  Widget _buildLinearProgressBar() => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // inner widget
          widget.innerWidget ?? const SizedBox.shrink(),
          // total percentage
          widget.showTotalPercentage
              ? Column(
                  children: [
                    //inner icon
                    _buildInnerIcon(),
                    //total percentage
                    _buildTotalPercentage(),
                    //spacing
                    const SizedBox(height: 8.0),
                    //text
                    _buildTextWidget(),
                  ],
                )
              : const SizedBox.shrink(),
          // linear progress bar
          CustomPaint(
            painter: _buildProgressBarPainter(),
            size: Size(widget.size, widget.size),
          ),
        ],
      );

  CustomPainter _buildProgressBarPainter() => widget.progressBarType == MultiCircularSliderType.circular
      ? CircularProgressBarPainter(
          size: widget.size,
          values: List.generate(widget.values.length, (index) => widget.values[index] * _animation.value),
          colors: widget.colors,
          progressBarWidth: widget.progressBarWidth,
          trackColor: widget.trackColor,
          trackWidth: widget.trackWidth,
        )
      : LinearProgressBarPainter(
          size: widget.size,
          values: List.generate(widget.values.length, (index) => widget.values[index] * _animation.value),
          colors: widget.colors,
          progressBarWidth: widget.progressBarWidth,
          trackColor: widget.trackColor,
          trackWidth: widget.trackWidth,
        );

  Widget _buildInnerIcon() => widget.innerIcon ?? const SizedBox.shrink();

  Widget _buildTotalPercentage() => Text(
        '${(percentage * _animation.value * 100).ceil()}%',
        textAlign: TextAlign.center,
        style: widget.percentageTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28.0,
              color: Color(0xFF012C61),
            ),
      );

  Widget _buildTextWidget() => widget.label != null
      ? FittedBox(
          child: Text(
            widget.label!,
            style: widget.labelTextStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                  color: Color(0xFF939AA4),
                ),
          ),
        )
      : const SizedBox.shrink();
}
