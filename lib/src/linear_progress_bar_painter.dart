part of circular_slider;

/// CustomPainter class to draw linear progress bar
class LinearProgressBarPainter extends CustomPainter {
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

  //constructor
  LinearProgressBarPainter({
    required this.size,
    this.trackWidth = 32.0,
    required this.progressBarWidth,
    required this.values,
    required this.colors,
    this.trackColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
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
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      shadowPaint,
    );

    //progress bar track paint
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = trackColor
      ..strokeWidth = trackWidth;

    //draw progrwss bar track
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      trackPaint,
    );

    //length of list
    int length = values.length;
    double totalPercentage = 0.0;

    //to store values in reverse order
    List<LinearShader> progressBarsPainters = [];

    //iterating through list for calculating values
    for (int i = 0; i < length; i++) {
      totalPercentage += values[i];

      //progress bar paint
      final progressBarPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = colors[i]
        ..strokeWidth = progressBarWidth;

      //adding values to list
      progressBarsPainters.insert(
        0,
        LinearShader(
          width: size.width * totalPercentage,
          paint: progressBarPaint,
        ),
      );
    }

    //drawing actual progress bars
    for (final progressBarPaint in progressBarsPainters) {
      canvas.drawLine(
        const Offset(0, 0),
        Offset(progressBarPaint.width, 0),
        progressBarPaint.paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// class for storing values of the ProgressBar
class LinearShader {
  final double width;
  final Paint paint;

  LinearShader({
    required this.width,
    required this.paint,
  });
}
