import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/app/message_colors.dart';
import 'package:immobilier_apk/scr/config/app/text_utils.dart';
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
          maxWidth: 800,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header minimaliste
            _buildHeader(),

            // Contenu principal
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date de réception
                    _buildDateSection(),

                    20.h,

                    // Message principal
                    _buildMessageSection(),

                    20.h,

                    // Informations de contact
                    if (!message.contact.isNul) _buildContactSection(),

                    20.h,

                    // Actions
                    _buildActionsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final categoryColor = MessageColors.getCategoryColor(message.categorie);
    final categoryIcon = _getCategoryIcon(message.categorie.toLowerCase());

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.08),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // Badge de catégorie
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 16,
                ),
                6.w,
                EText(
                  message.categorie.toUpperCase(),
                  color: Colors.white,
                  weight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),

          Spacer(),

          // Bouton de fermeture minimaliste
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section
        EText(
          "Message",
       font: Fonts.poppinsBold,
       size: 24,
        ),
        12.h,
        Container(height: 1, width: 70, color: Colors.grey,),
        12.h,


        // Contenu du message
        TextUtils.buildFormattedText(
          selectable: true,
                        message.message,
                        color: Colors.grey[900],
                        baseWeight: FontWeight.w400,
                      ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section
        EText(
          "Contact",
          color: Colors.grey[900],
          size: 18,
          weight: FontWeight.w600,
        ),

        12.h,

        // Bouton d'appel
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              launchUrl(Uri.parse("tel:${message.contact}"));
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.phone_outlined,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EText(
                          "Appeler",
                          color: Colors.blue[700],
                          weight: FontWeight.w600,
                        ),
                        EText(
                          message.contact!,
                          color: Colors.blue[600],
                          size: 13,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue[400],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section

        12.h,

        // Informations de date
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EText(
                "Date de réception",
                size: 18,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                  12.w,
                  EText(
                    _formatDate(message.date),
                    color: Colors.grey[900],
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(context) {
    return InkWell(
      onTap: () => _showDeleteDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red[200]!,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Colors.red[700],
          size: 20,
        ),
      ),
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
            Fluttertoast.showToast(msg: "Une erreur s'est produite");
          }
        },
        body: "Voulez-vous vraiment supprimer cet avis ?",
        confirmationText: "Supprimer",
        title: "Suppression",
      ),
    );
  }
}

// Les couleurs sont maintenant définies dans MessageColors
