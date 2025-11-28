import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final double size;
  final String text;
  final TextEditingController controller;

  const BaseTextField({
    super.key,
    required this.size,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
