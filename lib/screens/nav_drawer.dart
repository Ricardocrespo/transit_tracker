import 'package:flutter/material.dart';
import 'package:transit_tracker/models/point.dart';
import 'package:transit_tracker/models/zone.dart';
import 'package:transit_tracker/utils/lang/app_localizations.dart';

class NavDrawer extends StatelessWidget {
  final List<Zone> zones;
  final Point selected;
  final void Function(Point) onSelect;
  final void Function() onSettingsTap;

  const NavDrawer({
    super.key,
    required this.zones,
    required this.selected,
    required this.onSelect,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final entry in zones.asMap().entries) ...[
            Padding(
              padding: EdgeInsets.only(top: entry.key == 0 ? 12 : 0),
              child: ListTile(
                title: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('navigation.zone.${entry.value.id}'),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                enabled: false,
              ),
            ),
            for (final point in entry.value.points)
              ListTile(
                title: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('navigation.point.${point.id}'),
                ),
                selected: selected.id == point.id,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelect(point);
                },
                visualDensity: const VisualDensity(vertical: -4.0),
              ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context).translate('navigation.settings'),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onSettingsTap();
            },
          ),
        ],
      ),
    );
  }
}
