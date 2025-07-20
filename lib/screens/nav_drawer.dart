import 'package:flutter/material.dart';
import 'package:transit_tracker/models/point.dart';

class NavDrawer extends StatelessWidget {
  final List<Point> ports;
  final Point selected;
  final void Function(Point) onSelect;

  const NavDrawer({
    super.key,
    required this.ports,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: ports.map((point) {
          return ListTile(
            title: Text('${point.id}'),
            selected: selected.id == point.id,
            onTap: () {
              Navigator.of(context).pop();
              onSelect(point);
            },
          );
        }).toList(),
      ),
    );
  }
}
