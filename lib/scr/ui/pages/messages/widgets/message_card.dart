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
  final entrepriseID;

  final Message element;

  @override
  Widget build(BuildContext context) {
    final categoryColor = MessageColors.getCategoryColor(element.categorie);
    final categoryIcon = _getCategoryIcon(element.categorie.toLowerCase());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Get.dialog(MessageDetails(
              message: element,
              entrepriseID: entrepriseID,
            ));
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header minimaliste avec catégorie
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Badge de catégorie minimaliste
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryIcon,
                              color: Colors.white,
                              size: 14,
                            ),
                            4.w,
                            EText(
                              element.categorie.toUpperCase(),
                             color: Colors.white,
                             size: 17,
                            ),
                          ],
                        ),
                      ),
                      
                      Spacer(),
                      
                      // Date discrète
                      EText(
                        _formatDate(element.date),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                
                // Contenu principal
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message principal avec typographie améliorée
                      TextUtils.buildFormattedText(
                        element.message.replaceAll("\n", " "),
                        color: Colors.grey[900],
                        baseWeight: FontWeight.w400,
                        maxLines: 3,
                      ),
                      
                      12.h,
                      
                      // Footer avec informations secondaires
                      Row(
                        children: [
                          // Siège si disponible
                          if (element.siege != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey[600],
                                    size: 14,
                                  ),
                                  4.w,
                                  EText(
                                    element.siege!,
                                    color: Colors.grey[700],
                                    size: 15,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            
                            8.w,
                          ],
                          
                          // Contact si disponible
                          if (!element.contact.isNul) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Colors.blue[600],
                                    size: 14,
                                  ),
                                  4.w,
                                  EText(
                                    element.contact!,
                                    color: Colors.blue[700],
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          
                          Spacer(),
                          
                          // Indicateur de navigation subtil
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
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
        return Icons.lightbulb_outline;
      case "plainte":
        return Icons.report_problem_outlined;
      case "idée":
        return Icons.psychology_outlined;
      case "appréciation":
        return Icons.favorite_outline;
      default:
        return Icons.message_outlined;
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

// Les couleurs sont maintenant définies dans MessageColors
