
import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
