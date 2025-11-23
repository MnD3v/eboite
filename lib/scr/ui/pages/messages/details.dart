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
    final categoryColor = MessageColors.getCategoryColor(message.categorie);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
          maxWidth: 550, // Slightly narrower for a more card-like feel
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, categoryColor),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildDateAndLocation(),
                      const SizedBox(height: 32),
                      _buildMessageContent(categoryColor),
                      const SizedBox(height: 32),
                      if (!message.contact.isNul) ...[
                        _buildContactSection(categoryColor),
                        const SizedBox(height: 32),
                      ],
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color categoryColor) {
    final categoryIcon = _getCategoryIcon(message.categorie.toLowerCase());

    return Stack(
      children: [
        // Decorative Background
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.08),
          ),
        ),

        // Large Faded Icon
        Positioned(
          right: -20,
          top: -20,
          child: Transform.rotate(
            angle: -0.2,
            child: Icon(
              categoryIcon,
              size: 180,
              color: categoryColor.withOpacity(0.08),
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, color: categoryColor, size: 18),
                        const SizedBox(width: 8),
                        EText(
                          message.categorie.toUpperCase(),
                          color: categoryColor,
                          weight: FontWeight.w800,
                          size: 13,
                          letterSpacing: 1.2,
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Material(
                    color: Colors.white.withOpacity(0.5),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Get.back(),
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.close,
                            size: 22, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateAndLocation() {
    return Row(
      children: [
        _buildInfoChip(
          Icons.calendar_today_rounded,
          _formatDate(message.date),
          Colors.blueGrey,
        ),
        if (message.siege != null && message.siege!.isNotEmpty) ...[
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          _buildInfoChip(
            Icons.location_on_rounded,
            message.siege!,
            Colors.red[400]!,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color.withOpacity(0.8)),
        const SizedBox(width: 8),
        EText(
          text,
          color: Colors.grey[700],
          size: 15,
          weight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildMessageContent(Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EText(
          "MESSAGE",
          size: 12,
          weight: FontWeight.w800,
          color: Colors.grey[400],
          letterSpacing: 1.5,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.format_quote_rounded,
                  color: accentColor.withOpacity(0.3), size: 32),
              const SizedBox(height: 8),
              TextUtils.buildFormattedText(
                selectable: true,
                message.message,
                color: const Color(0xFF2D3436),
                baseWeight: FontWeight.w500,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EText(
          "CONTACT",
          size: 12,
          weight: FontWeight.w800,
          color: Colors.grey[400],
          letterSpacing: 1.5,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.phone_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EText(
                      message.contact!,
                      size: 18,
                      weight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                    ),
                    const SizedBox(height: 4),
                    EText(
                      "Appuyez pour appeler",
                      size: 13,
                      color: Colors.grey[500],
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse("tel:${message.contact}")),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: EText(
                      "Appeler",
                      color: Colors.blue[700],
                      weight: FontWeight.w700,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => _showDeleteDialog(context),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red[400],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.red[50],
        ),
        icon: Icon(Icons.delete_outline_rounded,
            size: 20, color: Colors.red[400]),
        label: EText(
          "Supprimer le message",
          color: Colors.red[400],
          weight: FontWeight.w700,
          size: 14,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "suggestion":
        return Icons.lightbulb_outline_rounded;
      case "plainte":
        return Icons.report_problem_outlined;
      case "idée":
        return Icons.psychology_outlined;
      case "appréciation":
        return Icons.favorite_outline_rounded;
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

  void _showDeleteDialog(context) {
    Custom.showDialog(
      TwoOptionsDialog(
        confirmFunction: () async {
          loading();
          try {
            await DB
                .firestore(Collections.entreprises)
                .doc(entrepriseID)
                .collection(Collections.messages)
                .doc(message.id)
                .delete();
            Get.back(); // Close loading
            Get.back(); // Close details dialog
            Toasts.success(context, description: "Message supprimé");
          } catch (e) {
            Get.back(); // Close loading
            Toasts.error(context, description: "Erreur lors de la suppression");
          }
        },
        body: "Cette action est irréversible.",
        confirmationText: "Supprimer",
        title: "Supprimer ce message ?",
      ),
    );
  }
}
