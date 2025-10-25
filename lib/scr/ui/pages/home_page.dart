import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/utils/assets.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/set_entreprise.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/messages.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/statistiques/statistiques.dart';
import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';
import 'package:my_widgets/my_widgets.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var progress = "Initialisation...".obs;
  String nommage = "";
  String dossier = "";
  List<String> separates = <String>[];
  File? file;
  bool simple = true;
  var type = Rx<String?>(null);
  var currentEntreprise = Rx<RealEntreprise?>(null);
  var pageController = PageController();
  var currentPage = 0.obs;
  var categories = <String>[].obs;

  @override
  void initState() {
    try {
      currentEntreprise.value = Utilisateur.currentUser.value!.entreprises[0];
      print(currentEntreprise.value);
    } catch (e) {}
    super.initState();
  }

  var user = Utilisateur.currentUser.value!;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DB
          .firestore(Collections.utilistateurs)
          .doc(user.telephone.numero)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {}
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.data != null && snapshot.data!.data() != null) {
          Utilisateur.currentUser.value = Utilisateur.fromMap(snapshot.data!.data()!);
          currentEntreprise.value = Utilisateur.currentUser.value!.entreprises.isEmpty 
              ? null 
              : Utilisateur.currentUser.value!.entreprises[0];
        }
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: EScaffold(
            color: Colors.white,
            appBar: _buildAppBar(),
            body: Obx(
              () => Utilisateur.currentUser.value!.abonnement.isNul ||
                      DateTime.parse(Utilisateur.currentUser.value!.abonnement!.limite).isBefore(DateTime.now())
                  ? _buildSubscriptionExpiredView()
                  : Utilisateur.currentUser.value!.entreprises.isEmpty
                      ? _buildNoEntrepriseView()
                      : _buildMainContent(),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image(
          image: AssetImage(Assets.icons('logo-text.png')),
          height: 30,
        ),
      ),
      actions: [
        // Bouton statistiques
        Container(
          margin: EdgeInsets.only(right: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.to(Statistiques());
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        
        // Bouton profil
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Get.to(Compte());
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.color500,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionExpiredView() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32),
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
              // Icône d'abonnement
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: Colors.red[500],
                  size: 48,
                ),
              ),
              
              24.h,
              
              // Titre
              EText(
                "Abonnement expiré",
                size: 25,
              font: Fonts.poppinsBold,
              ),
              
              12.h,
              
              // Description
              Text(
                "Vous n'avez aucun abonnement en cours. Renouvelez votre abonnement pour continuer à utiliser l'application.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              32.h,
              
              // Bouton d'action
             SimpleButton(
              width: 200,
                onTap: () {
                  Get.to(AbonnementsListe());
                },
               
               
                child: EText(
                  "Acheter un abonnement",
                  font: Fonts.poppinsBold,
               color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoEntrepriseView() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32),
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
              // Image d'entreprise
              Container(
                height: Get.width * 0.5,
                width: Get.width * 0.5,
                child: Image.asset(
                  Assets.image("entreprise.png"),
                  fit: BoxFit.contain,
                ),
              ),
              
              24.h,
              
              // Titre
              Text(
                "Aucune entreprise",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              
              12.h,
              
              // Description
              Text(
                "Créez votre première entreprise pour commencer à recevoir des retours de vos clients.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              32.h,
              
              // Bouton d'action
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: createEntreprise,
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
      ),
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Contenu principal
        Padding(
          padding: EdgeInsets.only(
            top: Utilisateur.currentUser.value!.entreprises.length < 2 ? 0 : 90.0,
          ),
          child: Obx(() => Messages(
            key: Key(currentEntreprise.value!.id),
            currentEntreprise: currentEntreprise.value!,
          )),
        ),
        
        // Sélecteur d'entreprises (si plusieurs entreprises)
        if (Utilisateur.currentUser.value!.entreprises.length >= 2)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildEntrepriseSelector(),
          ),
      ],
    );
  }

  Widget _buildEntrepriseSelector() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
     
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Utilisateur.currentUser.value!.entreprises.map((element) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      currentEntreprise.value = element;
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: currentEntreprise.value!.id == element.id
                              ? AppColors.color500
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: currentEntreprise.value!.id == element.id
                                ? AppColors.color500
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: currentEntreprise.value!.id == element.id
                              ? [
                                  BoxShadow(
                                    color: AppColors.color500.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          element.nom,
                          style: TextStyle(
                            color: currentEntreprise.value!.id == element.id
                                ? Colors.white
                                : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> filtrer() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicateur de glissement
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                24.h,
                
                // Titre
                Text(
                  "Filtrer les messages",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                
                24.h,
                
                // Options de filtrage
                ...["Suggestion", "Plainte", "Idée", "Appreciation"].map((element) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      value: categories.contains(element),
                      onChanged: (value) {
                        if (!categories.contains(element)) {
                          categories.add(element);
                        } else {
                          categories.remove(element);
                        }
                      },
                      title: Text(
                        element,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      activeColor: AppColors.color500,
                      checkColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                }).toList(),
                
                24.h,
                
                // Bouton de confirmation
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
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
                      "Continuer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                16.h,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createEntreprise() {
    String nom = "";
    String description = "";
    final selectedItems = <String>[].obs;
    String id = "";

    Utilisateur.currentUser.value!.abonnement.isNul ||
            DateTime.parse(Utilisateur.currentUser.value!.abonnement!.limite).isBefore(DateTime.now())
        ? Get.to(AbonnementsListe())
        : null;

    if (user.abonnement!.type == 'Standard' && user.entreprises.isNotEmpty) {
      Custom.showDialog(Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: EColumn(crossAxisAlignment: CrossAxisAlignment.center, children: [
            BigTitleText("Abonnement"),
            12.h,
            ETextRich(textSpans: [
              ETextSpan(text: "Avec votre abonnement Standard, vous pouvez créer "),
              ETextSpan(text: "une seule entreprise.", color: AppColors.color500),
            ]),
            ETextRich(
              textSpans: [
                ETextSpan(text: "Pour créer plusieurs entreprises, passez à "),
                ETextSpan(text: "l'abonnement Premium.", color: AppColors.color500)
              ],
            ),
            12.h,
            SimpleOutlineButton(
              radius: 9,
              onTap: () {
                Get.back();
                Get.to(AbonnementsListe(onlyPremium: true));
              },
              text: "Changer d'abonnement",
            )
          ]),
        ),
      ));
      return;
    }
    var sieges = (<Siege>[]).obs;

    Get.dialog(SetEntreprise(
      description: description,
      nom: nom,
      id: id,
      user: user,
      selectedItems: selectedItems,
      sieges: sieges,
    ));
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.ready,
    required this.pageController,
    required this.currentPage,
  });

  final RxBool ready;
  final PageController pageController;
  final RxInt currentPage;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 70,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Colors.black12, width: .6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavigationButton(
              function: () {
                pageController.animateToPage(0,
                    duration: 333.milliseconds, curve: Curves.decelerate);
                currentPage.value = 0;
              },
              currentPage: currentPage.value,
              page: 0,
              label: 'Accueil',
              selectedIcon: 'home_s.png',
              unselectedIcon: 'home_us.png',
            ),
            BottomNavigationButton(
              function: () {
                pageController.animateToPage(1,
                    duration: 333.milliseconds, curve: Curves.decelerate);
                currentPage.value = 1;
              },
              currentPage: currentPage.value,
              page: 1,
              label: 'Compte',
              selectedIcon: 'account_s.png',
              unselectedIcon: 'account_us.png',
            ),
          ],
        ),
      ),
    );
  }
}

class Boite {
  static var types = [
    null,
    "Suggestions",
    "Plaintes",
    "Idées",
    "Appreciations"
  ];
}
