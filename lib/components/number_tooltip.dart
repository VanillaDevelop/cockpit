import 'package:flutter/material.dart';

// A widget that displays a number in a circle with a tooltip
class NumberTooltip extends StatelessWidget {
  final String tooltipText;
  final int count;
  final Color color;

  const NumberTooltip({
    super.key,
    required this.tooltipText,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipText,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
