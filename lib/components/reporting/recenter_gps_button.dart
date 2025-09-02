import 'package:flutter/material.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class RecenterGpsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RecenterGpsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.translate('report.recenter'),
      child: FloatingActionButton.small(
        heroTag: 'recenter_gps',
        onPressed: onPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
