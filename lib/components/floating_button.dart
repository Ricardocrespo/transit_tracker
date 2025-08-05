import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Alignment alignment;
  final VoidCallback onPressed;
  final Widget icon;
  final String heroTag;
  final bool isDisabled;

  const FloatingButton({
    super.key,
    required this.alignment,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FloatingActionButton(
            mini: true,
            heroTag: heroTag,
            onPressed: isDisabled ? null : onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
