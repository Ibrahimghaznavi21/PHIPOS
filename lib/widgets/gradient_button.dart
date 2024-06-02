import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Gradient gradient;
  final TextStyle textStyle;
  final double borderRadius;
  final bool? loading;

  ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.gradient,
    required this.textStyle,
    this.borderRadius = 8.0,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1, // How much the shadow spreads
            blurRadius: 5, // How much the shadow blurs
            offset: Offset(0, 3), // Shadow position (horizontal, vertical)
          ),
        ],
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: loading! ? CircularProgressIndicator(color: Colors.black,) : Text(
             text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}