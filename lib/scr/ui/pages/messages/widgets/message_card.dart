import 'package:immobilier_apk/scr/config/app/export.dart';
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
    final categoryColor = categorieColors[element.categorie.toLowerCase()] ?? Colors.blue;
    final categoryIcon = _getCategoryIcon(element.categorie.toLowerCase());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Get.dialog(MessageDetails(
            message: element,
            entrepriseID: entrepriseID, // À adapter selon vos besoins
          ));
        },
        child: Container(
         height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: categoryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Header avec gradient et catégorie
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor.withOpacity(0.9),
                        categoryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Icône de catégorie
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      
                      16.w,
                      
                      // Titre de catégorie et siège
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element.categorie.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            if (element.siege != null) ...[
                              4.h,
                              Text(
                                element.siege!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Indicateur de statut
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contenu du message
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message principal
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          element.message.replaceAll("\n", " "),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),
                      
                      16.h,
                      
                      // Informations de contact et date
                      Row(
                        children: [
                          // Contact
                          if (!element.contact.isNul) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blue[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Colors.blue[600],
                                    size: 16,
                                  ),
                                  6.w,
                                  Text(
                                    element.contact??"",
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            12.w,
                          ],
                          
                          // Date
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  6.w,
                                  Text(
                                    _formatDate(element.date),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

Map<String, Color> categorieColors = {
  "suggestion": Colors.green,
  "plainte": const Color.fromARGB(255, 255, 17, 0),
  "idée": Color.fromARGB(255, 0, 79, 206),
  "appréciation": const Color.fromARGB(255, 0, 150, 55)
};
