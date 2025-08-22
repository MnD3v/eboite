import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/inscription.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/scaffold.dart';

// ignore: must_be_immutable
class Connexion extends StatelessWidget {
  Connexion({
    super.key,
  });
  String telephone = '';

  String pass = '';

  var passvisible = false.obs;

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Connexion",
            style: TextStyle(
              fontSize: isLargeScreen ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () {
                  Get.to(Inscription(function: () {}));
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
                  "Inscription",
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
                          if (isLargeScreen) 
                            SizedBox(height: screenHeight * 0.1)
                          else
                            0.h,
                          
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
                                Container(
                                  padding: EdgeInsets.all(isLargeScreen ? 28 : 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.color500.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.color500.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Hero(
                                    tag: "launch_icon",
                                    child: Image(
                                      image: AssetImage(Assets.icons("logo.png")),
                                      height: isLargeScreen ? 80 : 60,
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 32 : 24).h,
                                
                                // Titre principal
                                Text(
                                  'Connectez-vous',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 32 : 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                
                                (isLargeScreen ? 12 : 8).h,
                                
                                // Sous-titre
                                Text(
                                  'Accédez à votre compte eBoite',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 18 : 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          (isLargeScreen ? 40 : 32).h,
                          
                          // Formulaire de connexion
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
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          onChanged: (value) {
                                            telephone = value;
                                          },
                                          style: TextStyle(
                                            fontSize: isLargeScreen ? 18 : 16,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Numéro de téléphone",
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
                                            obscureText: passvisible.value ? false : true,
                                            onChanged: (value) {
                                              pass = value;
                                            },
                                            style: TextStyle(
                                              fontSize: isLargeScreen ? 18 : 16,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Mot de passe",
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
                                              passvisible.value = !passvisible.value;
                                            },
                                            child: Icon(
                                              passvisible.value
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
                                
                                // Bouton de connexion
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (!GFunctions.isPhoneNumber(
                                          country: country, numero: telephone)) {
                                        Toasts.error(context,
                                            description: "Entrez un numero valide");
                                        return;
                                      }
                                      if (pass.length < 6) {
                                        Toasts.error(context,
                                            description:
                                                "Le mot de passe doit contenir aumoins 6 caracteres");
                                        return;
                                      }

                                      isLoading.value = true;
                                      try {
                                        var q = await DB
                                            .firestore(Collections.utilistateurs)
                                            .doc(telephone)
                                            .get();
                                        if (q.exists) {
                                          var utilisateur = Utilisateur.fromMap(q.data()!);
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: "$telephone@gmail.com",
                                                    password: pass);
                                            Utilisateur.currentUser.value = utilisateur;

                                            isLoading.value = false;

                                            Get.off(HomePage());
                                            Toasts.success(context,
                                                description:
                                                    "Vous vous êtes connecté avec succès");
                                            Utilisateur.refreshToken();
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == "network-request-failed") {
                                              isLoading.value = false;

                                              Custom.showDialog(const WarningWidget(
                                                message:
                                                    'Echec de connexion.\nVeuillez verifier votre connexion internet',
                                              ));
                                            } else if (e.code == 'invalid-credential') {
                                              isLoading.value = false;

                                              Custom.showDialog(const WarningWidget(
                                                message: 'Mot de passe incorrect',
                                              ));
                                            }
                                          }
                                        } else {
                                          isLoading.value = false;
                                          Custom.showDialog(
                                            const WarningWidget(
                                              message:
                                                  'Pas de compte associé à ce numero. Veuillez creer un compte',
                                            ),
                                          );
                                        }
                                      } on Exception {
                                        isLoading.value = false;
                                        Custom.showDialog(const WarningWidget(
                                          message:
                                              "Une erreur s'est produite. veuillez verifier votre connexion internet",
                                        ));
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
                                          ? LoadingAnimationWidget.threeRotatingDots(
                                              color: Colors.white,
                                              size: isLargeScreen ? 36 : 30,
                                            )
                                          : Text(
                                              'Me connecter',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: isLargeScreen ? 18 : 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                
                                (isLargeScreen ? 32 : 24).h,
                                
                                // Lien mot de passe oublié
                                TextButton(
                                  onPressed: () {
                                    forgotPassword(context);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isLargeScreen ? 20 : 16, 
                                      vertical: isLargeScreen ? 12 : 8
                                    ),
                                  ),
                                  child: Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(
                                      color: AppColors.color500,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isLargeScreen ? 18 : 16,
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

  void forgotPassword(context) async {
    if (GFunctions.isPhoneNumber(country: country, numero: telephone)) {
      try {
        var q =
            await DB.firestore(Collections.utilistateurs).doc(telephone).get();
        if (q.exists) {
          isLoading.value = true;
          await Utilisateur.getUser(telephone);

          var utilisateur = Utilisateur.fromMap(q.data()!);

          var auth = FirebaseAuth.instance;

          await auth.verifyPhoneNumber(
            phoneNumber: '+228${utilisateur.telephone}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              isLoading.value = false;

              Custom.showDialog(const WarningWidget(
                message:
                    'Erreur lors de la verification du numero, veuillez réessayer plus tard',
              ));
            },
            codeSent: (String verificationId, int? resendToken) async {
              isLoading.value = false;

              // Get.to(Verification(
              //     verificationId: verificationId, utilisateur: utilisateur));
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } else {
          isLoading.value = false;

          Custom.showDialog(const WarningWidget(
            message:
                'Pas de compte associé à ce numero. veuillez creer un compte',
          ));
        }
      } on Exception {
        isLoading.value = false;

        Custom.showDialog(const WarningWidget(
          message:
              "Une erreur s'est produite. veuillez verifier votre connexion internet",
        ));
      }
    } else {
      Toasts.error(
        context,
        description: "Entrez un numero valide",
      );
    }
  }
}

class ChooseCountryCode extends StatelessWidget {
  const ChooseCountryCode({
    super.key,
    required this.onChanged,
  });
  final onChanged;
  @override
  Widget build(BuildContext context) {
    var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;

    return CountryCodePicker(
      flagWidth: 25,
      onChanged: onChanged,
      initialSelection: 'TG',
      favorite: const ['+228', 'TG'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      textStyle: TextStyle(
        fontSize: 20 * .7 / phoneScallerFactor,
        color: AppColors.color500,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.only(right: 6),
    );
  }
}
