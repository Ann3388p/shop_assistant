import 'package:flutter/material.dart';

class HomeCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.0002625,size.height*0.0005000);
    path_0.lineTo(size.width*0.0002375,size.height*0.0021667);
    path_0.lineTo(size.width,size.height*0.0005417);
    path_0.lineTo(size.width,size.height*0.8362500);
    path_0.lineTo(size.width*0.8743000,size.height*0.8727917);
    path_0.quadraticBezierTo(size.width*0.7514250,size.height*0.9630000,size.width*0.5000000,size.height);
    path_0.quadraticBezierTo(size.width*0.2514250,size.height*0.9643750,size.width*0.1232250,size.height*0.8658750);
    path_0.quadraticBezierTo(size.width*0.0311250,size.height*0.8408438,size.width*0.0004250,size.height*0.8325000);
    path_0.quadraticBezierTo(size.width*0.0005437,size.height*0.6244792,size.width*0.0009000,size.height*0.0004167);

    canvas.drawPath(path_0, paint_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
