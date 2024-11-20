import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  DashboardTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), // Réduire les marges internes
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0, color: color), // Réduire la taille de l’icône
          SizedBox(height: 8.0), // Réduire l’espacement vertical
          Text(
            title,
            style: TextStyle(fontSize: 16.0, color: color), // Réduire la taille du texte
          ),
          Expanded(child: child), // Adapter la taille du contenu
        ],
      ),
    );
  }
}
