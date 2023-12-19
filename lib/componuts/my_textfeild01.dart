import 'package:flutter/material.dart';

class MyTextField01 extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField01(
      {super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText, required initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF241f1c),),
          ),
          fillColor: Colors.white24,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black,),
        ),
      ),
    );
  }
}
