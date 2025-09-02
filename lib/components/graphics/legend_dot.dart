import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;     // e.g. "0–5m"
  final double size;

  const LegendDot({
    super.key,
    required this.color,
    required this.label,
    this.size = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.2),
              width: 0.75,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
