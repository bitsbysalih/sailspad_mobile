import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width = 100,
    this.height = 45,
    this.margin,
  }) : super(key: key);

  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: -10,
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFFFBFBFB),
          foregroundColor: Color(0xff455154),
          side: BorderSide(
            width: 1,
            color: Color(0xFFE3E3E3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
