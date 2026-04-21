import 'package:flutter/material.dart';
import 'package:gotech_app/decoration.dart';

class AppBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  const AppBarWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: const GlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: 100,
          opacity: 0.1,
          child: Center(
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
