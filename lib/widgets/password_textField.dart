import 'dart:ui';

import 'package:flutter/material.dart';

class PasswordTexField extends StatelessWidget {
  final controller;
  final hintText;
  final prefixIcon;
  final suffixIcon;
  VoidCallback? suffixPress;
  final obsecureText;
  final String? Function(String?) validator;


  PasswordTexField({
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixPress,
    this.obsecureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obsecureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: IconButton(onPressed: suffixPress, icon: suffixIcon),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(23),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(23),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(23),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(23),
          ),
        ),
      ),
    );
  }
}
