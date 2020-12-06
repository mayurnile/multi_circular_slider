import 'package:flutter/material.dart';

import 'package:multi_circular_slider/multi_circular_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Progress Bar',
      home: MyTestWidget(),
    );
  }
}

class MyTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: MultiCircularSlider(
            size: MediaQuery.of(context).size.width * 0.8,
            values: [0.2, 0.1, 0.3, 0.25],
            colors: [Color(0xFFFD1960), Color(0xFF29D3E8), Color(0xFF18C737), Color(0xFFFFCC05)],
            showTotalPercentage: true,
          ),
        ),
      ),
    );
  }
}