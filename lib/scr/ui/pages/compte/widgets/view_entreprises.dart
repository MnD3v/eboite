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

  var sieges = (<Siege>[]).obs;
  final Utilisateur utilisateur;
  
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 1200;
    var isMediumScreen = screenWidth > 800 && screenWidth <= 1200;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: EScaffold(
        color: Colors.white,
        appBar: _buildAppBar(isLargeScreen, isMediumScreen),
        body: utilisateur.entreprises.isEmpty
            ? _buildEmptyState(isLargeScreen, isMediumScreen)
            : _buildEntreprisesList(isLargeScreen, isMediumScreen),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isLargeScreen, bool isMediumScreen) {
    return AppBar(
      title: EText(
        "Mes entreprises",
        size: isLargeScreen ? 28 : isMediumScreen ? 26 : 24,
        weight: FontWeight.w700,
        color: Colors.white,
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Container(
          margin: EdgeInsets.only(right: isLargeScreen ? 32 : isMediumScreen ? 24 : 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _showCreateEntrepriseDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 24 : isMediumScreen ? 20 : 20, 
                  vertical: isLargeScreen ? 16 : isMediumScreen ? 14 : 12
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
                      size: isLargeScreen ? 24 : isMediumScreen ? 22 : 20,
                  ),
                    (isLargeScreen ? 12 : isMediumScreen ? 10 : 8).w,
                  EText(
                    "Créer une entreprise",
                    color: Colors.white,
                    weight: FontWeight.w700,
                    size: isLargeScreen ? 18 : isMediumScreen ? 17 : 16,
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

  Widget _buildEmptyState(bool isLargeScreen, bool isMediumScreen) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isLargeScreen ? 48 : isMediumScreen ? 40 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation Lottie
            Container(
              height: Get.width * (isLargeScreen ? 0.4 : isMediumScreen ? 0.5 : 0.6),
              width: Get.width * (isLargeScreen ? 0.4 : isMediumScreen ? 0.5 : 0.6),
              child: Lottie.asset(
                'assets/lotties/empty.json',
                fit: BoxFit.contain,
              ),
            ),
            
            (isLargeScreen ? 48 : isMediumScreen ? 40 : 32).h,
            
            // Titre
            EText(
              "Aucune entreprise disponible",
              align: TextAlign.center,
              size: isLargeScreen ? 32 : isMediumScreen ? 28 : 24,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
            
            (isLargeScreen ? 24 : isMediumScreen ? 20 : 16).h,
            
            // Description
            EText(
              "Créez votre première entreprise pour commencer à recevoir des retours de vos clients",
              align: TextAlign.center,
              size: isLargeScreen ? 20 : isMediumScreen ? 18 : 16,
              color: Colors.white.withOpacity(0.8),
            ),
            
            (isLargeScreen ? 60 : isMediumScreen ? 50 : 40).h,
            
            // Bouton d'action
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 400 : isMediumScreen ? 350 : double.infinity,
              ),
              child: ElevatedButton.icon(
                onPressed: () => _showCreateEntrepriseDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isLargeScreen ? 20 : isMediumScreen ? 18 : 16
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  Icons.add_business_outlined,
                  size: isLargeScreen ? 24 : isMediumScreen ? 22 : 20,
                ),
                label: EText(
                  "Créer une entreprise",
                  size: isLargeScreen ? 18 : isMediumScreen ? 17 : 16,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntreprisesList(bool isLargeScreen, bool isMediumScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isLargeScreen ? 32 : isMediumScreen ? 24 : 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 1200 : isMediumScreen ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              (isLargeScreen ? 32 : isMediumScreen ? 28 : 24).h,
              
              // Titre de section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isLargeScreen ? 32 : isMediumScreen ? 24 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.color500.withOpacity(0.9),
                      AppColors.color500.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
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
                      size: isLargeScreen ? 56 : isMediumScreen ? 48 : 40,
                    ),
                    (isLargeScreen ? 24 : isMediumScreen ? 20 : 16).h,
                    EText(
                      "Gérez vos entreprises",
                      align: TextAlign.center,
                      size: isLargeScreen ? 28 : isMediumScreen ? 24 : 20,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    (isLargeScreen ? 12 : isMediumScreen ? 10 : 8).h,
                    EText(
                      "Téléchargez vos affiches et modifiez vos informations",
                      align: TextAlign.center,
                      size: isLargeScreen ? 20 : isMediumScreen ? 18 : 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
              
              (isLargeScreen ? 48 : isMediumScreen ? 40 : 32).h,
              
              // Liste des entreprises - Layout responsive
              isLargeScreen 
                ? _buildLargeScreenGrid()
                : isMediumScreen 
                  ? _buildMediumScreenGrid()
                  : _buildMobileList(),
              
              (isLargeScreen ? 60 : isMediumScreen ? 50 : 40).h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreenGrid() {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: utilisateur.entreprises.map((element) {
        return SizedBox(
          width: (1200 - 64 - 24) / 2, // 2 colonnes avec espacement et padding
          child: _buildEntrepriseCard(element, true, false),
        );
      }).toList(),
    );
  }

  Widget _buildMediumScreenGrid() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: utilisateur.entreprises.map((element) {
        return SizedBox(
          width: (900 - 48 - 20) / 2, // 2 colonnes avec espacement et padding
          child: _buildEntrepriseCard(element, false, true),
        );
      }).toList(),
    );
  }

  Widget _buildMobileList() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: utilisateur.entreprises.map((element) {
        return SizedBox(
          width: (Get.width - 40 - 16) / 2, // 2 colonnes avec espacement
          child: _buildEntrepriseCard(element, false, false),
        );
      }).toList(),
    );
  }

  Widget _buildEntrepriseCard(RealEntreprise element, [bool isLargeScreen = false, bool isMediumScreen = false]) {
    WidgetsToImageController controller = WidgetsToImageController();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: isLargeScreen ? 24 : isMediumScreen ? 22 : 20,
            offset: Offset(0, isLargeScreen ? 12 : isMediumScreen ? 11 : 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de l'entreprise
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
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
                topLeft: Radius.circular(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
                topRight: Radius.circular(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 16 : isMediumScreen ? 14 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.color500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(isLargeScreen ? 20 : isMediumScreen ? 18 : 16),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppColors.color500,
                    size: isLargeScreen ? 32 : isMediumScreen ? 28 : 24,
                  ),
                ),
                
                (isLargeScreen ? 20 : isMediumScreen ? 18 : 16).w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        element.nom,
                        size: isLargeScreen ? 28 : isMediumScreen ? 26 : 22,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      (isLargeScreen ? 12 : isMediumScreen ? 10 : 8).h,
                      EText(
                        "ID: ${element.id.toUpperCase()}",
                        size: isLargeScreen ? 18 : isMediumScreen ? 16 : 14,
                        color: Colors.white.withOpacity(0.8),
                        font: 'monospace',
                      ),
                    ],
                  ),
                ),
                     Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            insetPadding: EdgeInsets.all(16),
                            child: Container(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Titre
                                  EText(
                                    "Inviter un utilisateur",
                                    size: 20,
                                    weight: FontWeight.w700,
                                    color: Colors.grey[900],
                                  ),
                                  
                                  24.h,
                                  
                                  // Champ email
                                  ETextField(
                                    placeholder: "Adresse email",
                                    onChanged: (value) {
                                      // TODO: Gérer la saisie de l'email
                                    },
                                    phoneScallerFactor: phoneScallerFactor,
                                  ),
                                  
                                  24.h,
                                  
                                  // Boutons
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
                                          onTap: () {
                                            // TODO: Implémenter la validation
                                            Get.back();
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
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
             
                // Bouton d'édition
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Get.dialog(SetEntreprise(
                          index: utilisateur.entreprises.indexOf(element),
                          id: element.id,
                          nom: element.nom,
                          description: element.description,
                          selectedItems: RxList(element.categories),
                          sieges: RxList(element.sieges),
                          user: utilisateur,
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Affiche avec QR Code
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 32 : isMediumScreen ? 28 : 24),
            child: Column(
              children: [
                // Affiche
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isLargeScreen ? 20 : isMediumScreen ? 18 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: isLargeScreen ? 20 : isMediumScreen ? 18 : 15,
                        offset: Offset(0, isLargeScreen ? 10 : isMediumScreen ? 9 : 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isLargeScreen ? 20 : isMediumScreen ? 18 : 16),
                    child: WidgetsToImage(
                      controller: controller,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage(Assets.image("affiche.png")),
                            width: isLargeScreen ? 400 : isMediumScreen ? 350 : 300,
                          ),
                          
                          // QR Code
                          Positioned(
                            top: isLargeScreen ? 240.0 : isMediumScreen ? 210.0 : 180.0,
                            child: Container(
                              padding: EdgeInsets.all(isLargeScreen ? 12 : isMediumScreen ? 10 : 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(isLargeScreen ? 16 : isMediumScreen ? 14 : 12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: isLargeScreen ? 15 : isMediumScreen ? 12 : 10,
                                    offset: Offset(0, isLargeScreen ? 8 : isMediumScreen ? 6 : 5),
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
                                padding: EdgeInsets.all(isLargeScreen ? 8 : isMediumScreen ? 7 : 6),
                                size: isLargeScreen ? 200 : isMediumScreen ? 175 : 150,
                              ),
                            ),
                          ),
                          
                          // URL
                          Positioned(
                            bottom: isLargeScreen ? 15 : isMediumScreen ? 12 : 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: isLargeScreen ? 24 : isMediumScreen ? 22 : 20,
                                ),
                                (isLargeScreen ? 12 : isMediumScreen ? 10 : 8).w,
                                EText(
                                  "eboite.co/${element.id.toUpperCase()}",
                                  color: Colors.white,
                                  font: Fonts.poppinsBold,
                                  size: isLargeScreen ? 48 : isMediumScreen ? 44 : 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                (isLargeScreen ? 32 : isMediumScreen ? 28 : 24).h,
                
                // Bouton de téléchargement
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
                      padding: EdgeInsets.symmetric(
                        vertical: isLargeScreen ? 20 : isMediumScreen ? 18 : 16
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isLargeScreen ? 20 : isMediumScreen ? 18 : 16),
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: isLargeScreen ? 24 : isMediumScreen ? 22 : 20,
                    ),
                    label: EText(
                      "Télécharger l'affiche",
                      size: isLargeScreen ? 18 : isMediumScreen ? 17 : 16,
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
