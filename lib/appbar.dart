import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  Function() onTap;
  AppBarWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white54,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_left),
        ),
      ),
    );
  }
}
