import 'package:flutter/material.dart';

class LegendToggle extends StatefulWidget {
  final Widget legendContent; // e.g., your gradient+labels card
  final String label; // i18n: "Legend"

  const LegendToggle({
    super.key,
    required this.legendContent,
    required this.label,
  });

  @override
  State<LegendToggle> createState() => _LegendToggleState();
}

class _LegendToggleState extends State<LegendToggle>
    with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionChip(
          avatar: const Icon(Icons.info_outline, size: 18),
          label: Text(widget.label),
          onPressed: () => setState(() => _open = !_open),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget.legendContent,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
