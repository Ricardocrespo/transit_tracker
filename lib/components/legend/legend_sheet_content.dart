import 'package:flutter/material.dart';
import 'package:transit_tracker/components/graphics/legend_dot.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class LegendSheetContent extends StatelessWidget {
  final List<Color> colors;         // newest → oldest
  final List<String> verbose;       // e.g. ["between 0 and 5 minutes ago", ...]

  const LegendSheetContent({
    super.key,
    required this.colors,
    required this.verbose,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context).translate('legend.title'), style: Theme.of(context).textTheme.titleMedium),
        Divider(height: 8),
        Text(AppLocalizations.of(context).translate('legend.subtitle'), style: textStyle),
        const SizedBox(height: 8),

        // Verbose list
        ...List.generate(colors.length, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LegendDot(color: colors[i], label: '', size: 12),
              const SizedBox(width: 8),
              Flexible(child: Text(verbose[i], style: textStyle)),
            ],
          ),
        )),
      ],
    );
  }
}
