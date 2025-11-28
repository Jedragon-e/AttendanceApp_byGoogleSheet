import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final Size size;
  final String text;
  final IconData? icon; // 아이콘은 선택
  final VoidCallback onPressed;

  const BaseButton({
    super.key,
    this.icon,
    required this.size,
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: size,
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
    );
  }
}
