import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/text.dart';

/// Utilitaires pour le formatage de texte avec ETextSpan
class TextUtils {
  
  /// Convertit un texte avec ** en gras en utilisant ETextSpan
  /// Supprime également les parties encadrées de []
  static List<TextSpan> parseBoldText(String text, {
    Color? color,
    double? size,
    FontWeight? baseWeight,
  }) {
    // Supprimer les parties entre []
    String cleanedText = _removeBrackets(text);
    
    List<TextSpan> spans = [];
    List<String> parts = cleanedText.split('**');
    
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      
      // Les parties paires sont normales, les impaires sont en gras
      bool isBold = i % 2 == 1;
      
      spans.add(ETextSpan(
        text: parts[i],
        color: color,
        size: size??18,
        weight: isBold ? FontWeight.bold : baseWeight ?? FontWeight.normal,
      ));
    }
    
    return spans;
  }
  
  /// Supprime les parties entre crochets []
  static String _removeBrackets(String text) {
    // Utiliser une regex pour supprimer tout ce qui est entre []
    return text.replaceAll(RegExp(r'\[.*?\]'), '');
  }
  
  /// Widget qui affiche un texte avec formatage ** en gras
  static Widget buildFormattedText(String text, {
    bool? selectable,
    Color? color,
    double? size,
    FontWeight? baseWeight,
    TextAlign? align,
    int? maxLines,
  }) {
    List<TextSpan> spans = parseBoldText(text, 
      color: color, 
      size: size, 
      baseWeight: baseWeight
    );
    
    return selectable == true ? SelectableText.rich(
      TextSpan(children: spans),
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines,
      textScaleFactor: 0.7,
    ) : Text.rich(
      TextSpan(children: spans),
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textScaleFactor: 0.7,
    );
  }
}
