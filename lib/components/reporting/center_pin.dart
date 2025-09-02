import 'package:flutter/material.dart';

class CenterPin extends StatelessWidget {
  const CenterPin({
    super.key,
    this.pinSize = 44,
    this.offsetFactor = 0.27, // ← try 0.28 first; tune 0.26–0.30
    this.showCenterDot = true,
  });

  /// Visual size of the Material pin icon.
  final double pinSize;

  /// Portion of the pin height to shift UP so the tip sits on the true center.
  /// Typical good range for Icons.location_pin: 0.26–0.36.
  final double offsetFactor;

  /// Tiny dot at the exact map center (helps calibration).
  final bool showCenterDot;

  @override
  Widget build(BuildContext context) {
    final dy = -pinSize * offsetFactor;

    return IgnorePointer(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showCenterDot)
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 1.5, color: Colors.black26)],
                ),
              ),
            Transform.translate(
              offset: Offset(0, dy),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, size: pinSize, color: Colors.red),
                  const SizedBox(height: 2),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.12),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: SizedBox(width: 10, height: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
