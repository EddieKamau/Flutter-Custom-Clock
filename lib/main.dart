import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart' as prefix0;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(backgroundColor: Colors.black, body: HomeContent(),),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>{

  double _hrRadian;
  double _minuteRadian;
  double _secRadian;
  int _minute;
  int _hr;
  Timer _everySec;
  

  @override
  void initState() {

    super.initState();
    setState(() {
        List _percentages = timeToPercentageConverter(TimeOfDay.now().hour.roundToDouble(), TimeOfDay.now().minute.roundToDouble(), DateTime.now().second.roundToDouble());
        _hrRadian = percentageToRadianConverter(_percentages)[0];
        _minuteRadian = percentageToRadianConverter(_percentages)[1];
        _secRadian = percentageToRadianConverter(_percentages)[2];
        _minute = TimeOfDay.now().minute;
        _hr = TimeOfDay.now().hour;

       
        
        
    });
    _everySec =  Timer.periodic(Duration(seconds: 1), (Timer _){
      setState(() {
        List _percentages = timeToPercentageConverter(TimeOfDay.now().hour.roundToDouble(), TimeOfDay.now().minute.roundToDouble(), DateTime.now().second.roundToDouble());
        _hrRadian = percentageToRadianConverter(_percentages)[0];
        _minuteRadian = percentageToRadianConverter(_percentages)[1];
        _secRadian = percentageToRadianConverter(_percentages)[2];
        _minute = TimeOfDay.now().minute;
        _hr = TimeOfDay.now().hour;
    });

    });
    
   
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Container(
            height: 360.0,
            width: 360.0,
            child: new CustomPaint(
              painter: new MyPainter(
                  minute: _minute,
                  minRadian: _minuteRadian,
                  hrRadian: _hrRadian,
                  secRadian: _secRadian,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(width: 1.3, color: Colors.pink)),
            height: 45,
            width: 45,
            child: Center(
              child: Text(
                _hr.toString(), 
                style: TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter{
  int minute;
  double hrRadian;
  double minRadian;
  double secRadian;
  MyPainter({this.minute,this.hrRadian, this.minRadian, this.secRadian});

  final Gradient mintGradient = new RadialGradient(
      colors: <Color>[
        Colors.cyan,
        Colors.cyanAccent,
        Colors.white
          ],
          stops: [
            0.0,
            0.3,
            1.0
          ],
      );
  final secGradient = new SweepGradient(
      startAngle: 3 * pi / 2,
      endAngle: 7 * pi / 2,
      tileMode: TileMode.repeated,
      colors: [Colors.blueAccent, Colors.pink, Colors.purple, Colors.purpleAccent, Colors.lightBlueAccent, Colors.blue],
    );


  @override
  void paint(Canvas canvas, Size size) {



    TextPainter textPainter = new TextPainter()
        ..textAlign = TextAlign.center
        ..textDirection = TextDirection.ltr
        ..text = new TextSpan(
          text: minute.toString(),
          style: prefix0.TextStyle(fontSize: 20, color: Colors.red));
        textPainter.layout();

    canvas.save();

    canvas.translate(size.width / 2, size.width / 2);
    canvas.rotate(pi*2/60 * minute);
    canvas.save();
    canvas.translate(0, -size.width/2 -20);
    final int quadSide = (minute / 15).floor();

    switch (quadSide) {
      case 0:
        canvas.rotate(0);
        break;
      case 1:
        canvas.rotate(-pi);
        break;
      case 2:
        canvas.rotate(pi);
        break;
      case 3:
        canvas.rotate(0);
        break;
    }

    
    textPainter.paint(canvas, Offset(-textPainter.width/2, -1));

    canvas.restore();

    canvas.restore();

    // canvas.rotate(pi *2 / 60 *minute);
    
    // canvas.translate(20, -20);
    // // canvas.rotate(pi/2);
    // textPainter.paint(canvas, Offset(-textPainter.width/2 ,-radius));


  final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    Paint outLine = new Paint()
        ..color = Colors.purpleAccent
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

    Paint hrLine = new Paint()
        ..color = Colors.pink
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke
        ..strokeWidth = 70;
        
    Paint sectLine = new Paint()
        ..shader = secGradient.createShader(rect)
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

    Paint minPath = new Paint()
      ..shader = mintGradient.createShader(rect)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 255;
    

    Offset center  = new Offset(size.width/2, size.height/2);

    
    // Minute path
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: 50),
        -pi/2,
        minRadian,
        false,
        minPath
    );
    
    
    // hour line
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: 10),
        -pi/2,
        hrRadian,
        false,
        hrLine
    );
    
    // Second path
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: 173),
        -pi/2,
        secRadian,
        false,
        sectLine
    );
    

    canvas.drawCircle(
        center,
        178,
        outLine
    );



     

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

List<double> timeToPercentageConverter(double hrs, double mint, double sec){
  double _baseHours = 12;
  double _baseMinutes = 60;
  double _baseSec = 60;
  if(hrs > _baseHours) hrs = hrs - 12;
  double _hrPercentage = (hrs / _baseHours) * 100;
  double _minutePercentage = (mint / _baseMinutes) * 100;
  double _secPercentage = (sec / _baseSec) * 100;

  return [_hrPercentage, _minutePercentage, _secPercentage];
}

List<double> percentageToRadianConverter(List<double> percentages){
  double _hrRadian = 2*pi* (percentages[0]/100);
  double _minuteRadian = 2*pi* (percentages[1]/100);
  double _secRadian = 2*pi* (percentages[2]/100);
  

  return [_hrRadian, _minuteRadian, _secRadian];
}