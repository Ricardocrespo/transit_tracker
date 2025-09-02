import 'package:flutter/material.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class PlacementSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PlacementSheet({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -2),
                color: Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.translate('report.setLocation'), // i18n key
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: onCancel,
                child: Text(l10n.translate('common.cancel')),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onConfirm,
                child: Text(l10n.translate('common.confirm')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
