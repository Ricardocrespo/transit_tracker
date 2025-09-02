import 'package:flutter/material.dart';
import 'legend_dot.dart';

class LegendDotsCompact extends StatelessWidget {
  final List<Color> colors;     // newest → oldest
  final List<String> labels;    // same length as colors
  final double maxWidth;        // to keep layout responsive

  const LegendDotsCompact({
    super.key,
    required this.colors,
    required this.labels,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: List.generate(
          colors.length,
          (i) => LegendDot(color: colors[i], label: labels[i]),
        ),
      ),
    );
  }
}

class LegendDotsExpanded extends StatelessWidget {
  final List<Color> colors;       // newest → oldest
  final List<String> verbose;     // e.g. "between 5 and 10 minutes ago"

  const LegendDotsExpanded({
    super.key,
    required this.colors,
    required this.verbose,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(colors.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LegendDot(color: colors[i], label: "", size: 12),
              const SizedBox(width: 8),
              Flexible(child: Text(verbose[i], style: textStyle)),
            ],
          ),
        );
      }),
    );
  }
}
