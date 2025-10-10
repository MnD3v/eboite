import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/set_entreprise.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ViewUser extends StatelessWidget {
  ViewUser({super.key, required this.utilisateur});

  var sieges = (<String>[]).obs;
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
      title: Text(
        "Mes entreprises",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
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
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showCreateEntrepriseDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    Text(
                      "Créer une entreprise",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
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
            Text(
              "Aucune entreprise disponible",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            
            16.h,
            
            // Description
            Text(
              "Créez votre première entreprise pour commencer à recevoir des retours de vos clients",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            
            40.h,
            
            // Bouton d'action
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showCreateEntrepriseDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  Icons.add_business_outlined,
                  size: 20,
                ),
                label: Text(
                  "Créer une entreprise",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          24.h,
          
          // Titre de section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
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
                Text(
                  "Gérez vos entreprises",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                8.h,
                Text(
                  "Téléchargez vos affiches et modifiez vos informations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          32.h,
          
          // Liste des entreprises
          ...utilisateur.entreprises.map((element) {
            return _buildEntrepriseCard(element);
          }).toList(),
          
          40.h,
        ],
      ),
    );
  }

  Widget _buildEntrepriseCard(dynamic element) {
    WidgetsToImageController controller = WidgetsToImageController();
    
    return Container(
      margin: EdgeInsets.only(bottom: 24),
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
          // Header de l'entreprise
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
            child: Row(
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
                    size: 24,
                  ),
                ),
                
                16.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element.nom,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      8.h,
                      Text(
                        "ID: ${element.id.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
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
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Affiche
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: WidgetsToImage(
                      controller: controller,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage(Assets.image("affiche.png")),
                            width: 300,
                          ),
                          
                          // QR Code
                          Positioned(
                            top: 180.0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
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
                          
                          // URL
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(
                      Icons.download_rounded,
                      size: 20,
                    ),
                    label: Text(
                      "Télécharger l'affiche",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
              
              Text(
                "Limite d'abonnement",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              
              16.h,
              
              Text(
                "Avec votre abonnement Standard, vous pouvez créer une seule entreprise.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              8.h,
              
              Text(
                "Pour créer plusieurs entreprises, passez à l'abonnement Premium.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
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
                  child: Text(
                    "Changer d'abonnement",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
