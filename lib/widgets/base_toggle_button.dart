import 'package:flutter/material.dart';

class BaseToggleButton extends StatefulWidget {
  final Size size;
  final String firstLabel;
  final String secondLabel;
  final ValueChanged<bool> onChanged; // true면 첫 번째 선택, false면 두 번째 선택
  final bool initialValue;

  const BaseToggleButton({
    super.key,
    required this.size,
    required this.firstLabel,
    required this.secondLabel,
    required this.onChanged,
    this.initialValue = true,
  });

  @override
  State<BaseToggleButton> createState() => _BaseToggleButtonState();
}

class _BaseToggleButtonState extends State<BaseToggleButton> {
  late bool isFirst;

  @override
  void initState() {
    super.initState();
    isFirst = widget.initialValue;
  }

  void _setValue(bool value) {
    setState(() {
      isFirst = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _setValue(true),
              style: OutlinedButton.styleFrom(
                backgroundColor: isFirst ? Colors.deepPurple.shade100 : null,
                side: BorderSide(
                  color: isFirst ? Colors.deepPurple : Colors.grey,
                  width: isFirst ? 2 : 1,
                ),
                minimumSize: widget.size,
              ),
              child: Text(
                widget.firstLabel,
                style: TextStyle(
                  fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                  color: isFirst ? Colors.deepPurple : Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _setValue(false),
              style: OutlinedButton.styleFrom(
                backgroundColor: !isFirst ? Colors.deepPurple.shade100 : null,
                side: BorderSide(
                  color: !isFirst ? Colors.deepPurple : Colors.grey,
                  width: !isFirst ? 2 : 1,
                ),
                minimumSize: widget.size,
              ),
              child: Text(
                widget.secondLabel,
                style: TextStyle(
                  fontWeight: !isFirst ? FontWeight.bold : FontWeight.normal,
                  color: !isFirst ? Colors.deepPurple : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
