import 'package:flutter/material.dart';

class LockedOverlay extends StatelessWidget {
  const LockedOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(Icons.lock, size: 48, color: Colors.white),
      ),
    );
  }
}
