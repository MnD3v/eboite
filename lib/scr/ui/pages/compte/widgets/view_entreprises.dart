import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/set_entreprise.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/my_widgets.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: EScaffold(
        color: Colors.white,
        appBar: _buildAppBar(),
        body: utilisateur.entreprises.isEmpty
            ? _buildEmptyState()
            : _buildEntreprisesList(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: EText(
        "Mes entreprises",
        size: 24,
        weight: FontWeight.w700,
        color: Colors.white,
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _showCreateEntrepriseDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20, 
                  vertical: 12
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.color500,
                      AppColors.color500.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color500.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_business_outlined,
                      color: Colors.white,
                      size: 20,
                  ),
                    8.w,
                  EText(
                    "Créer une entreprise",
                    color: Colors.white,
                    weight: FontWeight.w700,
                    size: 16,
                  ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation Lottie
            Container(
              height: Get.width * 0.6,
              width: Get.width * 0.6,
              child: Lottie.asset(
                'assets/lotties/empty.json',
                fit: BoxFit.contain,
              ),
            ),
            
            32.h,
            
            // Titre
            EText(
              "Aucune entreprise disponible",
              align: TextAlign.center,
              size: 24,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
            
            16.h,
            
            // Description
            EText(
              "Créez votre première entreprise pour commencer à recevoir des retours de vos clients",
              align: TextAlign.center,
              size: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            
            40.h,
            
            // Bouton d'action
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 350,
              ),
              child: ElevatedButton.icon(
                onPressed: () => _showCreateEntrepriseDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 16
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  Icons.add_business_outlined,
                  size: 20,
                ),
                label: EText(
                  "Créer une entreprise",
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntreprisesList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.h,
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.color500.withOpacity(0.9),
                      AppColors.color500.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color500.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    16.h,
                    EText(
                      "Gérez vos entreprises",
                      align: TextAlign.center,
                      size: 22,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    12.h,
                    EText(
                      "Téléchargez vos affiches et modifiez vos informations",
                      align: TextAlign.center,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
              32.h,
              for (int i = 0; i < utilisateur.entreprises.length; i++) ...[
                if(utilisateur.entreprises[i].auteur == utilisateur.telephone.numero) ...[
                  _buildEntrepriseCard(utilisateur.entreprises[i]),
                ],
                if (i != utilisateur.entreprises.length - 1) 24.h,
              ],
              40.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntrepriseCard(RealEntreprise element) {
    WidgetsToImageController controller = WidgetsToImageController();

    Widget actionButton({
      required Color backgroundColor,
      required IconData icon,
      required VoidCallback onTap,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      );
    }

    Widget buildInviteButton() {
      return actionButton(
        backgroundColor: Colors.green.withOpacity(0.2),
        icon: Icons.person_add,
        onTap: () {
          final RxSet<Siege> selectedCellules = <Siege>{}.obs;
          String email = "";
          Get.dialog(
            Dialog(
              insetPadding: EdgeInsets.all(16),
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EText(
                      "Inviter un utilisateur",
                      size: 20,
                      weight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                    24.h,
                    ETextField(
                      placeholder: "Adresse email",
                      onChanged: (value) {
                        email = value;
                      },
                      phoneScallerFactor: phoneScallerFactor,
                    ),
                    if (element.sieges.length > 1) ...[
                      24.h,
                      EText(
                        "Sélectionnez les cellules auxquelles cet utilisateur aura accès",
                        size: 14,
                        weight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      12.h,
                      Obx(() => Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: element.sieges.map((siege) {
                              final bool isSelected = selectedCellules.contains(siege);
                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    selectedCellules.remove(siege);
                                  } else {
                                    selectedCellules.add(siege);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 180),
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.color500.withOpacity(0.12)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected ? AppColors.color500 : Colors.grey[300]!,
                                      width: 1.3,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: AppColors.color500.withOpacity(0.18),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                                        size: 18,
                                        color: isSelected ? AppColors.color500 : Colors.grey[500],
                                      ),
                                      8.w,
                                      EText(
                                        siege.nom,
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: isSelected ? AppColors.color500 : Colors.grey[800],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    ],
                    24.h,
                    Row(
                      children: [
                        Expanded(
                          child: SimpleOutlineButton(
                            onTap: () {
                              Get.back();
                            },
                            text: "Annuler",
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: SimpleButton(
                            onTap: () async {
                            if(email.isEmpty) {
                              Toasts.error(Get.context!, description: "Veuillez saisir une adresse email");
                              return;
                            }
                            if (!GFunctions.isEmail(email)) {
                              Toasts.error(Get.context!, description: "Veuillez saisir une adresse email valide");
                              return;
                            }
                            loading();
                            var qUtilisateur = await  DB.firestore(Collections.utilistateurs).doc(email).get();   
                            if (qUtilisateur.exists) {
                              
                              var utilisateur = Utilisateur.fromMap(qUtilisateur.data()!);
                              if(utilisateur.entreprises.any((entreprise) => entreprise.id == element.id)) {
                                Get.back();
                                Get.back();
                                Toasts.error(Get.context!, description: "Utilisateur déjà ajouté");
                                return;
                              }
                              var entreprise = element.copyWith(sieges: selectedCellules.toList());
                              utilisateur.entreprises.add(entreprise);
                              await Utilisateur.setUser(utilisateur);
                              Get.back();
                              Get.back();

                              Toasts.success(Get.context!, description: "Utilisateur ajouté avec succès");
                            }
                            else{
                              Get.back();
                              Get.back();

                              Toasts.error(Get.context!, description: "Utilisateur non trouvé");
                            }

                            },
                            text: "Valider",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Widget buildEditButton() {
      return actionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        icon: Icons.edit_outlined,
        onTap: () {
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
        },
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.color500.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.business,
                        color: AppColors.color500,
                        size: 28,
                      ),
                    ),
                    16.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EText(
                            element.nom,
                            size: 22,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          8.h,
                          EText(
                            "ID: ${element.id.toUpperCase()}",
                            size: 14,
                            color: Colors.white.withOpacity(0.8),
                            font: 'monospace',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    Expanded(child: buildInviteButton()),
                    12.w,
                    Expanded(child: buildEditButton()),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 18,
                        offset: Offset(0, 8),
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
                            width: 300,
                          ),
                          Positioned(
                            top: 180,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
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
                                dataModuleStyle: QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(6),
                                size: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                8.w,
                                EText(
                                  "eboite.co/${element.id.toUpperCase()}",
                                  color: Colors.white,
                                  font: Fonts.poppinsBold,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                24.h,
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Uint8List? p_bytes = await controller.capture();
                      if (p_bytes != null) {
                        _saveFile(Get.context!, p_bytes);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: EText(
                      "Télécharger l'affiche",
                      size: 16,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateEntrepriseDialog() {
    String nom = "";
    String description = "";
    final selectedItems = <String>[].obs;
    String id = "";

    if (Utilisateur.currentUser.value!.abonnement.isNul ||
        DateTime.parse(Utilisateur.currentUser.value!.abonnement!.limite).isBefore(DateTime.now())) {
      Get.to(AbonnementsListe());
      return;
    }

    if (utilisateur.abonnement!.type == 'Standard' && utilisateur.entreprises.isNotEmpty) {
      Custom.showDialog(Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.red[500],
                  size: 40,
                ),
              ),
              
              24.h,
              
              EText(
                "Limite d'abonnement",
                size: 20,
                weight: FontWeight.w700,
                color: Colors.grey[800],
              ),
              
              16.h,
              
              EText(
                "Avec votre abonnement Standard, vous pouvez créer une seule entreprise.",
                align: TextAlign.center,
                size: 16,
                color: Colors.grey[600],
              ),
              
              8.h,
              
              EText(
                "Pour créer plusieurs entreprises, passez à l'abonnement Premium.",
                align: TextAlign.center,
                size: 16,
                color: Colors.grey[600],
              ),
              
              24.h,
              
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(AbonnementsListe(onlyPremium: true));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color500,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: EText(
                    "Changer d'abonnement",
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ),
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
    await Permission.storage.request();
    var status = await Permission.storage.status;
    print(status);
    
    final directory = await getExternalStorageDirectories();
    print(directory);
    
    final file = File(
        '/storage/emulated/0/Documents/eboite_${utilisateur.nom}${DateTime.now().microsecond}.png');
    await file.writeAsBytes(byteData);

    print('end');
    Toasts.success(context,
        description:
            "Enregistré avec succès dans le dossier /storage/emulated/0/Documents/eboite_${utilisateur.nom}${DateTime.now().microsecond}.png");
  }
}
