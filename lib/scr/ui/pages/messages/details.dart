import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/real_state/models/message.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails(
      {super.key, required this.message, required this.entrepriseID});
  final Message message;
  final String entrepriseID;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
          maxWidth: Get.width * 0.95,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header élégant avec gradient et icône de catégorie
                _buildHeader(),
                
                // Contenu principal
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message principal
                        _buildMessageSection(),
                        
                        24.h,
                        
                        // Informations de contact
                        if (!message.contact.isNul) _buildContactSection(),
                        
                        24.h,
                        
                        // Date et actions
                        _buildFooterSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final categoryColor = categorieColors[message.categorie.toLowerCase()] ?? Colors.blue;
    final categoryIcon = _getCategoryIcon(message.categorie.toLowerCase());
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.9),
            categoryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Icône de catégorie
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              
              16.w,
              
              // Titre de catégorie
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.categorie.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Détails du message",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bouton de fermeture
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.message_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              8.w,
              Text(
                "Message",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          12.h,
          Text(
            message.message,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                color: Colors.blue[600],
                size: 20,
              ),
              8.w,
              Text(
                "Contact",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          12.h,
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse("tel:${message.contact}"));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.call,
                    color: Colors.blue[700],
                    size: 18,
                  ),
                  8.w,
                  EText(
                    message.contact,
                 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(context) {
    return Column(
      children: [
        // Date
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey[600],
                size: 18,
              ),
              8.w,
              Text(
                message.date.split(" ")[0].split("-").reversed.join("-"),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        20.h,
        
        // Bouton de suppression
        // if (!entrepriseID.isNul)
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showDeleteDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[500],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              icon: Icon(
                CupertinoIcons.trash,
                size: 20,
              ),
              label: Text(
                "Supprimer ce message",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
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

  void _showDeleteDialog(context) {
    Get.dialog(
      TwoOptionsDialog(
        confirmFunction: () async {
          Get.back();
          loading();
          try {
            await DB
                .firestore(Collections.entreprises)
                .doc(entrepriseID)
                .collection(Collections.messages)
                .doc(message.id)
                .delete();
                print(entrepriseID);
            Get.back();
            Get.back();
            Toasts.success(context, description: "Avis supprimé avec succès");
          } catch (e) {
            Get.back();
            Fluttertoast.showToast(
                msg: "Une erreur s'est produite");
          }
        },
        body: "Voulez-vous vraiment supprimer cet avis ?",
        confirmationText: "Supprimer",
        title: "Suppression",
      ),
    );
  }
}

Map<String, Color> categorieColors = {
  "suggestion": Colors.green,
  "plainte": Colors.red,
  "idée": Color(0xff4cc9f0),
  "appréciation": Colors.teal
};
