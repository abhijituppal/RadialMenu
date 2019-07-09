import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Radial Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  double _currentPercentage;
  double _newPercentage;
  AnimationController _percentageController;

  @override
  void initState() {
    super.initState();
    _percentageController = AnimationController(vsync: this, duration: Duration(milliseconds: 10000));
    _percentageController.addListener(() {
      setState(() {
        _currentPercentage = lerpDouble(_currentPercentage, _newPercentage, _percentageController.value);
      });
    });
    setState(() {
      _currentPercentage = 0.0;
      _newPercentage = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        width: 200,
        height: 200,
        child: CustomPaint(
          foregroundPainter:
              _RadialPainter(lineColor: Colors.amber, completeColor: Colors.blueAccent, completePercent: _currentPercentage, width: 8.0),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _currentPercentage = _newPercentage;
                  _newPercentage += 10;
                  if (_newPercentage > 100) {
                    _newPercentage = 0;
                    _currentPercentage = 0;
                  }
                  _percentageController.forward(from: 0);
                });
              },
              color: Colors.purple,
              splashColor: Colors.blueAccent,
              shape: CircleBorder(),
              child: Text("Click"),
            ),
          ),
        ),
      )),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  _RadialPainter({this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);

    final arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, complete);

// draws a yellow line
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), line);
    canvas.save();
    canvas.translate(size.width / 4, size.height / 4);
// draws a green line after translation
    line..color = Colors.green;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), line);
    canvas.restore();
// draws a red over the original yellow line
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), line..color = Colors.red);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
