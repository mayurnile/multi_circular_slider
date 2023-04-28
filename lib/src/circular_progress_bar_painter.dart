part of circular_slider;

/// CustomPainter class to draw progress bar curves
class CircularProgressBarPainter extends CustomPainter {
  //size of the widget
  final double size;

  //width of the track
  final double trackWidth;

  //width of the progressbar
  final double progressBarWidth;

  //list of total values
  final List<double> values;

  //list of colors
  final List<Color> colors;

  //color of track
  final Color trackColor;

  //color of track
  final double baseAngle;

  //color of track
  final double startAngle;

  //constructor
  CircularProgressBarPainter({
    required this.size,
    this.trackWidth = 32.0,
    required this.progressBarWidth,
    required this.values,
    required this.colors,
    this.trackColor = Colors.grey,
    required this.baseAngle,
    required this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //actual starting angle of arc
    final double startAngleInRadians = degreeToRadians(startAngle);
    //total length of the track of progressbar
    final double trackSweepAngle = degreeToRadians(baseAngle);

    //shadow paint
    final shadowPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10.0,
      )
      ..strokeWidth = trackWidth;
    // ..strokeWidth = math.max(trackWidth, progressBarWidth);
    //draw shadow
    drawCurve(
      canvas,
      size,
      startAngleInRadians,
      trackSweepAngle,
      shadowPaint,
    );

    //progress bar track paint
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = trackColor
      ..strokeWidth = trackWidth;
    //progress bar track curve
    drawCurve(
      canvas,
      size,
      startAngleInRadians,
      trackSweepAngle,
      trackPaint,
    );

    //length of list
    int length = values.length;
    double totalPercentage = 0.0;

    //to store values in reverse order
    List<CircularShader> progressBars = [];

    //iterating through list for calculating values
    for (int i = 0; i < length; i++) {
      double percentage = baseAngle * values[i];
      totalPercentage += percentage;
      double sweepAngle = degreeToRadians(totalPercentage);

      //progress bar paint
      final progressBarPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = colors[i]
        ..strokeWidth = progressBarWidth;

      //adding values to list
      progressBars.insert(
        0,
        CircularShader(
          startAngle: startAngleInRadians,
          sweepAngle: sweepAngle,
          paint: progressBarPaint,
        ),
      );
    }

    //drawing actual progress bars
    for (final progressBar in progressBars) {
      drawCurve(
        canvas,
        size,
        progressBar.startAngle,
        progressBar.sweepAngle,
        progressBar.paint,
      );
    }
  }

  ///[Logic for drawing curve]
  drawCurve(
    Canvas canvas,
    Size size,
    double startAngle,
    double sweepAngle,
    Paint paint,
  ) {
    double radius = size.width / 2;
    Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  ///[Logic for converting degree to radians]
  degreeToRadians(double degree) {
    return degree * (math.pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// class for storing values of the ProgressBar
class CircularShader {
  final double startAngle;
  final double sweepAngle;
  final Paint paint;

  CircularShader({
    required this.startAngle,
    required this.sweepAngle,
    required this.paint,
  });
}
