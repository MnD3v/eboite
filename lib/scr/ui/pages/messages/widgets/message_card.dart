import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/app/message_colors.dart';
import 'package:immobilier_apk/scr/config/app/text_utils.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:my_widgets/real_state/models/message.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.element,
    required this.entrepriseID
  });
  
  final String entrepriseID;
  final Message element;

  @override
  Widget build(BuildContext context) {
    final categoryColor = MessageColors.getCategoryColor(element.categorie);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9E9E9E).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Get.dialog(MessageDetails(
              message: element,
              entrepriseID: entrepriseID,
            ));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Category Chip & Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(element.categorie),
                            size: 14,
                            color: categoryColor,
                          ),
                          const SizedBox(width: 6),
                          EText(
                            element.categorie.toUpperCase(),
                            color: categoryColor,
                            size: 14,
                            weight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    EText(
                      _formatDate(element.date),
                      color: Colors.grey.shade400,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                
                const SizedBox(height: 14),
                
                // Content
                TextUtils.buildFormattedText(
                  element.message.replaceAll("\n", " "),
                  color: const Color(0xFF2D3436),
                  size: 18,
                  baseWeight: FontWeight.w500,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 16),
                
                // Footer: Siege & Action
                Row(
                  children: [
                    if (element.siege != null) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade400),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: EText(
                          element.siege!,
                          color: Colors.grey.shade600,
                          size: 15,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                 
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "suggestion":
        return Icons.lightbulb_outline_rounded;
      case "plainte":
        return Icons.warning_amber_rounded;
      case "idée":
        return Icons.psychology_outlined;
      case "appréciation":
        return Icons.thumb_up_outlined;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  String _formatDate(String date) {
    try {
      final parts = date.split(" ")[0].split("-");
      if (parts.length >= 3) {
        return "${parts[2]}/${parts[1]}/${parts[0]}";
      }
      return date;
    } catch (e) {
      return date;
    }
  }
}
