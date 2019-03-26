import 'package:flutter/material.dart';

class CirclePaint extends StatelessWidget{

  final Size size;

  CirclePaint({@required this.size});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPaint(
      painter: CirclePainter(),
      size: size,
    );
  }
}

class CirclePainter extends CustomPainter{

  Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
  ..color = Colors.blue
  ..strokeWidth = 2;


  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    double r = (size.width/2).toDouble();
    canvas.drawCircle(Offset(r, r),r,_paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}