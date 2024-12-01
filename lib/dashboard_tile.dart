import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final Color color;
  final Widget child;

  DashboardTile({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0), // Angles arrondis
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4), // Ombre portée
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: child,
      ),
    );
  }
}
