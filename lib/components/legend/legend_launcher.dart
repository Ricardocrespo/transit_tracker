import 'package:flutter/material.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

typedef LegendBuilder = Widget Function(BuildContext);

class LegendLauncher extends StatelessWidget {
  final LegendBuilder buildLegendSheet;
  final bool enabled;

  const LegendLauncher({
    super.key,
    required this.buildLegendSheet,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: ActionChip(
          avatar: const Icon(Icons.info_outline, size: 18),
          label: Text(AppLocalizations.of(context).translate('legend.title')),
          onPressed: !enabled
              ? null
              : () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  barrierColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  builder: (ctx) => SizedBox(
                    // ← expand to full width
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        16 + MediaQuery.of(ctx).padding.bottom, // safe bottom
                      ),
                      child: buildLegendSheet(ctx), // your LegendSheetContent
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
