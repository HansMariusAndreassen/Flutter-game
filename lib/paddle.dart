import 'package:flutter/material.dart';

class Paddle extends StatelessWidget {
  final double position;
  final double width;
  final double height;

  const Paddle(
      {super.key, required this.position, this.width = 50, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: position,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
