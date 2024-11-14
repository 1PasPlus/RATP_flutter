import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  DashboardTile({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color),
      ),
      child: InkWell(
        onTap: () {
          // Action lors du clic sur le conteneur (optionnel)
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64.0, color: color),
              SizedBox(height: 16.0),
              Text(
                title,
                style: TextStyle(fontSize: 24.0, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
