import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/main.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/app/fonts.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/set_entreprise.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/real_state/other/collections.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ViewUser extends StatelessWidget {
  ViewUser({super.key, required this.utilisateur});

  final RxList<Siege> sieges = <Siege>[].obs;
  final Utilisateur utilisateur;

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      color: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: utilisateur.entreprises.isEmpty
          ? _buildEmptyState()
          : _buildEntreprisesList(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 20, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: EText(
        "Mes entreprises",
        size: 24,
        weight: FontWeight.w700,
        color: Colors.black87,
        font: Fonts.poppinsBold,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextButton.icon(
            onPressed: () => _showCreateEntrepriseDialog(),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.color500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: EText("Créer", color: Colors.white, weight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Lottie.asset(
                'assets/lotties/empty.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            EText(
              "Aucune entreprise",
              align: TextAlign.center,
              size: 24,
              weight: FontWeight.w700,
              color: Colors.black87,
            ),
            const SizedBox(height: 12),
            EText(
              "Commencez par créer votre première entreprise pour gérer vos activités.",
              align: TextAlign.center,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCreateEntrepriseDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: EText("Créer une entreprise",
                    size: 16, weight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntreprisesList(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueGrey[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: Colors.blueGrey[700]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: EText(
                        "Gérez vos entreprises et téléchargez vos affiches QR Code ici.",
                        size: 14,
                        color: Colors.blueGrey[800],
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // List
              ...utilisateur.entreprises
                  .where((e) => e.auteur == utilisateur.telephone.numero)
                  .map((entreprise) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildEntrepriseCard(entreprise),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntrepriseCard(RealEntreprise element) {
    WidgetsToImageController controller = WidgetsToImageController();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.color500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.business_rounded,
                      color: AppColors.color500, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        element.nom,
                        size: 20,
                        weight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: EText(
                          "ID: ${element.id.toUpperCase()}",
                          size: 12,
                          color: Colors.grey[600],
                          font: 'monospace',
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions Menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: Colors.grey[400]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(element);
                    } else if (value == 'invite') {
                      _showInviteDialog(element);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 12),
                          EText("Modifier", size: 14),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'invite',
                      child: Row(
                        children: [
                          Icon(Icons.person_add_outlined,
                              size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 12),
                          EText("Inviter", size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Content (Poster Preview)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EText(
                  "Affiche QR Code",
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.black87,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: WidgetsToImage(
                        controller: controller,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                              image: AssetImage(Assets.image("affiche.png")),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 180,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: QrImageView(
                                  data: 'eboite.co/${element.id.toUpperCase()}',
                                  backgroundColor: Colors.transparent,
                                  eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.circle,
                                    color: AppColors.color500,
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.circle,
                                    color: Colors.black,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  size: 150,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.link,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  EText(
                                    "eboite.co/${element.id.toUpperCase()}",
                                    color: Colors.white,
                                    font: Fonts.poppinsBold,
                                    size:
                                        24, // Reduced size slightly to fit better
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        Uint8List? p_bytes = await controller.capture();
                        if (p_bytes != null) {
                          _saveFile(Get.context!, p_bytes);
                        }
                      } catch (e) {
                        Toasts.error(Get.context!,
                            description: "Erreur lors de la capture");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.download_rounded, size: 20),
                    label: EText("Télécharger l'affiche",
                        size: 16, weight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(RealEntreprise element) {
    Get.dialog(SetEntreprise(
      index: utilisateur.entreprises.indexOf(element),
      id: element.id,
      nom: element.nom,
      description: element.description,
      selectedItems: RxList(element.categories),
      sieges: RxList(element.sieges),
      user: utilisateur,
      notificationsSettings: element.notificationsSettings,
      existingLogoUrl: element.logo,
    ));
  }

  void _showInviteDialog(RealEntreprise element) {
    final RxSet<Siege> selectedCellules = <Siege>{}.obs;
    String email = "";

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.color500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person_add_rounded,
                        color: AppColors.color500),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EText(
                      "Inviter un utilisateur",
                      size: 20,
                      weight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ETextField(
                phoneScallerFactor: phoneScallerFactor,
                placeholder: "Adresse email de l'utilisateur",
                onChanged: (value) => email = value,
                // phoneScallerFactor: 1.0, // Assuming default or global
              ),
              if (element.sieges.length > 1) ...[
                const SizedBox(height: 24),
                EText(
                  "Accès aux cellules",
                  size: 14,
                  weight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 12),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: element.sieges.map((siege) {
                        final bool isSelected =
                            selectedCellules.contains(siege);
                        return FilterChip(
                          label: Text(siege.nom),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            if (selected) {
                              selectedCellules.add(siege);
                            } else {
                              selectedCellules.remove(siege);
                            }
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.color500.withOpacity(0.2),
                          checkmarkColor: AppColors.color500,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.color500
                                : Colors.grey[700],
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.color500
                                  : Colors.grey[300]!,
                            ),
                          ),
                        );
                      }).toList(),
                    )),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: EText("Annuler",
                          color: Colors.grey[600], weight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (email.isEmpty) {
                          Toasts.error(Get.context!,
                              description: "Veuillez saisir une adresse email");
                          return;
                        }
                        if (!GFunctions.isEmail(email)) {
                          Toasts.error(Get.context!,
                              description: "Email invalide");
                          return;
                        }

                        loading();
                        try {
                          var qUtilisateur = await DB
                              .firestore(Collections.utilistateurs)
                              .doc(email)
                              .get();
                          if (qUtilisateur.exists) {
                            var utilisateur =
                                Utilisateur.fromMap(qUtilisateur.data()!);
                            if (utilisateur.entreprises.any(
                                (entreprise) => entreprise.id == element.id)) {
                              Get.back(); // Close loading
                              Get.back(); // Close dialog
                              Toasts.error(Get.context!,
                                  description:
                                      "Cet utilisateur est déjà membre");
                              return;
                            }
                            var entreprise = element.copyWith(
                                sieges: selectedCellules.toList());
                            utilisateur.entreprises.add(entreprise);
                            await Utilisateur.setUser(utilisateur);
                            Get.back(); // Close loading
                            Get.back(); // Close dialog
                            Toasts.success(Get.context!,
                                description: "Invitation envoyée avec succès");
                          } else {
                            Get.back(); // Close loading
                            Get.back(); // Close dialog
                            Toasts.error(Get.context!,
                                description: "Utilisateur introuvable");
                          }
                        } catch (e) {
                          Get.back();
                          Toasts.error(Get.context!,
                              description: "Une erreur est survenue");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: EText("Inviter",
                          color: Colors.white, weight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateEntrepriseDialog() {
    String nom = "";
    String description = "";
    final selectedItems = <String>[].obs;
    String id = "";

    if (Utilisateur.currentUser.value!.abonnement.isNul ||
        DateTime.parse(Utilisateur.currentUser.value!.abonnement!.limite)
            .isBefore(DateTime.now())) {
      Get.to(AbonnementsListe());
      return;
    }

    if (utilisateur.abonnement!.type == 'Standard' &&
        utilisateur.entreprises.isNotEmpty) {
      Custom.showDialog(Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded,
                    color: Colors.orange[500], size: 40),
              ),
              const SizedBox(height: 24),
              EText(
                "Passez au Premium",
                size: 22,
                weight: FontWeight.w700,
                color: Colors.black87,
              ),
              const SizedBox(height: 12),
              EText(
                "L'abonnement Standard est limité à une seule entreprise. Débloquez la création illimitée avec Premium.",
                align: TextAlign.center,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(AbonnementsListe(onlyPremium: true));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: EText("Voir les offres",
                      color: Colors.white, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: EText("Plus tard",
                    color: Colors.grey[500], weight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ));
      return;
    }

    Get.dialog(SetEntreprise(
      existingLogoUrl: null,
      description: description,
      nom: nom,
      id: id,
      user: utilisateur,
      selectedItems: selectedItems,
      sieges: sieges,
    ));
  }

  Future<void> _saveFile(BuildContext context, Uint8List byteData) async {
    // Note: Permission handling might vary by Android version.
    // For Android 10+, Scoped Storage is used and WRITE_EXTERNAL_STORAGE might not be needed or granted.
    // However, keeping original logic structure for now.

    if (Platform.isAndroid) {
      // Simple check, real implementation might need more robust permission handling for Android 13+
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    try {
      final directory =
          await getExternalStorageDirectory(); // Changed to getExternalStorageDirectory for better compatibility
      // Or use /storage/emulated/0/Documents if specifically required and accessible

      // Fallback to a safe directory if specific path fails
      final path = directory?.path ?? '/storage/emulated/0/Download';

      final fileName =
          'eboite_${utilisateur.nom}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('$path/$fileName');

      await file.writeAsBytes(byteData);
      Toasts.success(context, description: "Affiche enregistrée dans $path");
    } catch (e) {
      print(e);
      Toasts.error(context, description: "Erreur lors de l'enregistrement");
    }
  }
}
