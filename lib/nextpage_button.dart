import 'package:flutter/material.dart';

class NextPageButton extends StatefulWidget {
  final String text;
  final Widget icon;
  final VoidCallback goto;
  final String heroTag;
  final bool isPrimary;

  const NextPageButton({
    super.key,
    required this.text,
    required this.icon,
    required this.goto,
    required this.heroTag,
    this.isPrimary = false,
  });

  @override
  State<NextPageButton> createState() => _NextPageButtonState();
}

class _NextPageButtonState extends State<NextPageButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.goto();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? LinearGradient(
                        colors: [
                          Colors.blueAccent.withValues(alpha: 0.8),
                          Colors.blue.shade400.withValues(alpha: 0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.isPrimary ? null : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: widget.isPrimary 
                      ? Colors.lightBlueAccent.withValues(alpha: 0.5) 
                      : Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: widget.isPrimary
                    ? [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: widget.isPrimary ? Colors.white : Colors.blueAccent,
                      size: 20,
                    ),
                    child: widget.icon,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      shadows: widget.isPrimary ? [
                        Shadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))
                      ] : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
