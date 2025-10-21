import 'package:flutter/material.dart';

/// Couleurs unifiées pour les catégories de messages
/// Utilisées sur toutes les plateformes (web, mobile, desktop)
class MessageColors {
  static const Map<String, Color> categorieColors = {
    "suggestion": Color(0xFF1976D2), // Material Blue 700
    "plainte": Color(0xFFD32F2F), // Material Red 700
    "idée": Color(0xFF7B1FA2), // Material Purple 700
    "appréciation": Color(0xFF388E3C), // Material Green 700
  };

  /// Obtient la couleur pour une catégorie donnée
  static Color getCategoryColor(String category) {
    return categorieColors[category.toLowerCase()] ?? Colors.blue;
  }

  /// Styles de texte unifiés pour toutes les plateformes
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}
