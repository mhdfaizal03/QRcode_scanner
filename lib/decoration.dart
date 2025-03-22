import 'package:flutter/material.dart';

class StartBackgroundColor extends StatelessWidget {
  Widget child;
  StartBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange, Colors.red])),
      child: child,
    );
  }
}
