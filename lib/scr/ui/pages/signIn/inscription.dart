// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';

class Inscription extends StatelessWidget {
  Inscription({
    super.key,
    required this.function,
  });

  bool? deconnected;
  final function;
  Utilisateur utilisateur = Utilisateur.empty;

  var currentRegion = Rx<String?>(null);

  var passvisible_1 = true.obs;

  var passvisible_2 = true.obs;

  String repeatPass = "";

  var isLoading = false.obs;

  var country = "TG";

  @override
  Widget build(BuildContext context) {
    var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isLargeScreen = screenWidth > 800;
    var isMediumScreen = screenWidth > 600 && screenWidth <= 800;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.color500.withOpacity(0.1),
            AppColors.color500.withOpacity(0.05),
          ],
        ),
      ),
      child: EScaffold(
        appBar: AppBar(
          title: Text(
            "Inscription",
            style: TextStyle(
              fontSize: isLargeScreen ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(
                      Connexion(
                        // function: function,
                      ),
                      duration: 333.milliseconds,
                      transition: Transition.rightToLeftWithFade,
                      fullscreenDialog: true);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24 : 20, 
                    vertical: isLargeScreen ? 16 : 12
                  ),
                  backgroundColor: AppColors.color500.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: isLargeScreen ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color500,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(
          () => IgnorePointer(
            ignoring: isLoading.value,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 500 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Espacement adaptatif pour centrer verticalement sur grands écrans
                     
                          
                          // Logo et titre
                          Container(
                            padding: EdgeInsets.all(isLargeScreen ? 40 : 32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(isLargeScreen ? 28 : 24),
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
                                // Logo avec effet de profondeur
                                Hero(
                                  tag: "launch_icon",
                                  child: Image(
                                    image: AssetImage(Assets.icons("account_2.png")),
                                    height: isLargeScreen ? 80 : 60,
                                  ),
                                ),
                                
                                
                                // Titre principal
                                Text(
                                  "M'inscrire",
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 32 : 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                
                                (isLargeScreen ? 12 : 8).h,
                                
                                // Sous-titre
                                Text(
                                  'Créez votre compte eBoite',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 18 : 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          (isLargeScreen ? 40 : 32).h,
                          
                          // Formulaire d'inscription
                          Container(
                            padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(isLargeScreen ? 28 : 24),
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
                                // Champ nom
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      utilisateur.nom = value;
                                    },
                                    style: TextStyle(
                                      fontSize: isLargeScreen ? 18 : 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Votre nom",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: isLargeScreen ? 18 : 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isLargeScreen ? 24 : 20,
                                        vertical: isLargeScreen ? 20 : 16,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 24 : 20).h,
                                
                                // Champ prénom
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      utilisateur.prenom = value;
                                    },
                                    style: TextStyle(
                                      fontSize: isLargeScreen ? 18 : 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Votre prénom",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: isLargeScreen ? 18 : 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isLargeScreen ? 24 : 20,
                                        vertical: isLargeScreen ? 20 : 16,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 24 : 20).h,
                                
                                // Champ téléphone
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(isLargeScreen ? 20 : 16),
                                        decoration: BoxDecoration(
                                          color: AppColors.color500.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isLargeScreen ? 18 : 16),
                                            bottomLeft: Radius.circular(isLargeScreen ? 18 : 16),
                                          ),
                                        ),
                                        child: ChooseCountryCode(
                                          onChanged: (value) {
                                            utilisateur.telephone.indicatif = value.dialCode!;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          onChanged: (value) {
                                            utilisateur.telephone.numero = value;
                                          },
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 18 : 16,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Votre numéro de téléphone",
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: isLargeScreen ? 18 : 16,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: isLargeScreen ? 24 : 20,
                                              vertical: isLargeScreen ? 20 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                (isLargeScreen ? 24 : 20).h,
                                
                                // Champ mot de passe
                                Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            obscureText: passvisible_1.value,
                                            onChanged: (value) {
                                              utilisateur.password = value;
                                            },
                                            style: TextStyle(
                                              fontSize: isLargeScreen ? 18 : 16,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Votre mot de passe",
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: isLargeScreen ? 18 : 16,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: isLargeScreen ? 24 : 20,
                                                vertical: isLargeScreen ? 20 : 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(isLargeScreen ? 20 : 16),
                                          decoration: BoxDecoration(
                                            color: AppColors.color500.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(isLargeScreen ? 18 : 16),
                                              bottomRight: Radius.circular(isLargeScreen ? 18 : 16),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              passvisible_1.value = !passvisible_1.value;
                                            },
                                            child: Icon(
                                              !passvisible_1.value
                                                  ? CupertinoIcons.eye_slash_fill
                                                  : CupertinoIcons.eye_fill,
                                              color: AppColors.color500,
                                              size: isLargeScreen ? 24 : 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 24 : 20).h,
                                
                                // Champ répétition mot de passe
                                Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            obscureText: passvisible_2.value,
                                            onChanged: (value) {
                                              repeatPass = value;
                                            },
                                            style: TextStyle(
                                              fontSize: isLargeScreen ? 18 : 16,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Répéter votre mot de passe",
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: isLargeScreen ? 18 : 16,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: isLargeScreen ? 24 : 20,
                                                vertical: isLargeScreen ? 20 : 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(isLargeScreen ? 20 : 16),
                                          decoration: BoxDecoration(
                                            color: AppColors.color500.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(isLargeScreen ? 18 : 16),
                                              bottomRight: Radius.circular(isLargeScreen ? 18 : 16),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              passvisible_2.value = !passvisible_2.value;
                                            },
                                            child: Icon(
                                              !passvisible_2.value
                                                  ? CupertinoIcons.eye_slash_fill
                                                  : CupertinoIcons.eye_fill,
                                              color: AppColors.color500,
                                              size: isLargeScreen ? 24 : 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 40 : 32).h,
                                
                                // Bouton d'inscription
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (IsNullString(utilisateur.nom) ||
                                          IsNullString(utilisateur.prenom) ||
                                          !GFunctions.isPhoneNumber(
                                              country: utilisateur.telephone.indicatif,
                                              numero: utilisateur.telephone.numero) ||
                                          utilisateur.password.length < 6 ||
                                          utilisateur.password != repeatPass) {
                                        inscriptionProblemesDialog();
                                      } else {
                                        try {
                                          isLoading.value = true;

                                          try {
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email:
                                                  "${utilisateur.telephone.numero}@gmail.com",
                                              password: utilisateur.password,
                                            );
                                            utilisateur.country = country;
                                            await Utilisateur.setUser(utilisateur);

                                            isLoading.value = false;

                                            Get.off(HomePage());
                                            Toasts.success(context,
                                                description:
                                                    "Vous vous êtes connecté avec succès");
                                                Utilisateur.refreshToken();
                                            waitAfter(1000, () {
                                              function();
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'email-already-in-use') {
                                              Custom.showDialog(
                                                const WarningWidget(
                                                  message:
                                                      "Numero déjà utilisé. Veuillez vous connecter !",
                                                ),
                                              );
                                              isLoading.value = false;
                                            }
                                          }
                                        } on Exception {
                                          Custom.showDialog(const WarningWidget(
                                            message:
                                                "Une erreur s'est produite. veuillez verifier votre connexion internet",
                                          ));
                                          isLoading.value = false;
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.color500,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: isLargeScreen ? 22 : 18
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: Obx(
                                      () => isLoading.value
                                          ? SizedBox(
                                              height: isLargeScreen ? 30 : 25,
                                              width: isLargeScreen ? 30 : 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 1.3,
                                              ),
                                            )
                                          : Text(
                                              "M'inscrire",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: isLargeScreen ? 18 : 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          (isLargeScreen ? 60 : 40).h,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  inscriptionProblemesDialog() {
    var screenWidth = MediaQuery.of(Get.context!).size.width;
    var isLargeScreen = screenWidth > 800;
    
    return Custom.showDialog(Dialog(
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône d'alerte
            Container(
              padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red[500],
                size: isLargeScreen ? 48 : 40,
              ),
            ),
            
            (isLargeScreen ? 32 : 24).h,
            
            // Titre
            Text(
              'Problèmes détectés',
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            
            (isLargeScreen ? 20 : 16).h,
            
            // Liste des problèmes
            ..._buildProblemList(),
            
            (isLargeScreen ? 32 : 24).h,
            
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
                  padding: EdgeInsets.symmetric(
                    vertical: isLargeScreen ? 20 : 16
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isLargeScreen ? 18 : 16),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  List<Widget> _buildProblemList() {
    var screenWidth = MediaQuery.of(Get.context!).size.width;
    var isLargeScreen = screenWidth > 800;
    
    List<Widget> problems = [];
    
    if (IsNullString(utilisateur.nom)) {
      problems.add(_buildProblemItem('Veuillez saisir votre nom', isLargeScreen));
    }
    
    if (IsNullString(utilisateur.prenom)) {
      problems.add(_buildProblemItem('Veuillez saisir votre prénom', isLargeScreen));
    }
    
    if (!GFunctions.isPhoneNumber(
        country: utilisateur.telephone.indicatif,
        numero: utilisateur.telephone.numero)) {
      problems.add(_buildProblemItem('Veuillez saisir un numéro valide', isLargeScreen));
    }
    
    if (utilisateur.password.length < 6) {
      problems.add(_buildProblemItem(
          'Le mot de passe doit être supérieur ou égal à 6 caractères', isLargeScreen));
    }
    
    if (utilisateur.password != repeatPass) {
      problems.add(_buildProblemItem('Les mots de passe doivent être identiques', isLargeScreen));
    }
    
    return problems;
  }

  Widget _buildProblemItem(String message, bool isLargeScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isLargeScreen ? 16 : 12),
      padding: EdgeInsets.all(isLargeScreen ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(isLargeScreen ? 14 : 12),
        border: Border.all(
          color: Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[500],
            size: isLargeScreen ? 24 : 20,
          ),
          (isLargeScreen ? 16 : 12).w,
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: isLargeScreen ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
