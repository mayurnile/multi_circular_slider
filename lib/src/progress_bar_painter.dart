part of circular_slider;

class ProgressBarPainter extends CustomPainter {
  final double size;
  final double trackWidth;
  final double progressBarWidth;
  final List<double> values;
  final List<Color> colors;
  final Color trackColor;

  ProgressBarPainter({
    @required this.size,
    this.trackWidth = 32.0,
    this.progressBarWidth = 32.0,
    @required this.values,
    @required this.colors,
    this.trackColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double baseAngle = 180.0;
    final double startAngle = degreeToRadians(baseAngle);
    final double trackSweepAngle = degreeToRadians(baseAngle);

    //shadow paint
    final shadowPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0)
      ..strokeWidth = 42.0;
    //draw shadow
    drawCurve(canvas, size, startAngle, trackSweepAngle, shadowPaint);

    //progress bar track paint
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = trackColor
      ..strokeWidth = 32.0;
    //progress bar track curve
    drawCurve(canvas, size, startAngle, trackSweepAngle, trackPaint);

    int length = values.length;
    double totalPercentage = 0.0;

    List<Shader> _progressBars = [];

    for (int i = 0; i < length; i++) {
      double percentage = baseAngle * values[i];
      totalPercentage += percentage;
      double sweepAngle = degreeToRadians(totalPercentage);

      //progress bar paint
      final progressBarPaint = Paint()
      // ..shader = progressBarGradient.createShader(progressBarRect)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = colors[i]
        ..strokeWidth = 32.0;

      //adding values to list
      _progressBars.insert(0, Shader(startAngle: startAngle, sweepAngle: sweepAngle, paint: progressBarPaint));
      //progress bar curve
    }

    _progressBars.forEach((progressBar) {
      drawCurve(canvas, size, progressBar.startAngle, progressBar.sweepAngle, progressBar.paint);
    });
  }

  ///[Logic for drawing curve]
  drawCurve(Canvas canvas, Size size, double startAngle, double sweepAngle, Paint paint) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
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

class Shader {
  final double startAngle;
  final double sweepAngle;
  final Paint paint;

  Shader({
    @required this.startAngle,
    @required this.sweepAngle,
    @required this.paint,
  });
}
