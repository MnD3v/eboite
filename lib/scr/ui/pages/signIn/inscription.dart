// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/my_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 400 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo et branding
                    _buildHeader(),
                    
                    48.h,
                    
                    // Formulaire d'inscription
                    _buildSignupForm(context),
                    
                    32.h,
                    
                    // Lien connexion
                    _buildLoginLink(),
                    
                    24.h,
                    
                    // Sécurité
                    _buildSecurityNote(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: AssetImage(Assets.icons("logo-text.png")),
            fit: BoxFit.contain,
            height: 30,
          ),
        ),
        
        24.h,
        
        // Titre
        Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
        ),
        
        8.h,
        
        // Sous-titre
        Text(
          'Rejoignez eBoite dès aujourd\'hui',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Champ nom
          _buildNameField(),
          
          24.h,
          
          // Champ prénom
          _buildFirstNameField(),
          
          24.h,
          
          // Champ email
          _buildEmailField(),
          
          24.h,
          
          // Champ téléphone
          _buildPhoneField(),
          
          24.h,
          
          // Champ mot de passe
          _buildPasswordField(),
          
          24.h,
          
          // Champ répétition mot de passe
          _buildConfirmPasswordField(),
          
          32.h,
          
          // Bouton d'inscription
          _buildSignupButton(context),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            decoration: InputDecoration(
              hintText: "Entrez votre nom",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prénom',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            decoration: InputDecoration(
              hintText: "Entrez votre prénom",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adresse email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              utilisateur.email = value;
            },
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            decoration: InputDecoration(
              hintText: "Entrez votre adresse email",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Numéro de téléphone',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              utilisateur.telephone.numero = value;
            },
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            decoration: InputDecoration(
              hintText: "Entrez votre numéro complet (ex: +22890123456)",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: TextField(
              obscureText: passvisible_1.value,
              onChanged: (value) {
                utilisateur.password = value;
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
              decoration: InputDecoration(
                hintText: "Entrez votre mot de passe",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    passvisible_1.value = !passvisible_1.value;
                  },
                  child: Icon(
                    passvisible_1.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmer le mot de passe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        
        8.h,
        
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: TextField(
              obscureText: passvisible_2.value,
              onChanged: (value) {
                repeatPass = value;
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
              decoration: InputDecoration(
                hintText: "Répétez votre mot de passe",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    passvisible_2.value = !passvisible_2.value;
                  },
                  child: Icon(
                    passvisible_2.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading.value ? null : () => _handleSignup(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading.value
              ? LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.white,
                  size: 24,
                )
              : Text(
                  'Créer mon compte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
            Get.to(
              Connexion(),
              duration: 333.milliseconds,
              transition: Transition.rightToLeftWithFade,
              fullscreenDialog: true,
            );
          },
          child: Text(
            'Se connecter',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
          12.w,
          Expanded(
            child: Text(
              'Vos informations sont sécurisées et protégées',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignup(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    
    if (IsNullString(utilisateur.nom) ||
        IsNullString(utilisateur.prenom) ||
        IsNullString(utilisateur.email) ||
        !GFunctions.isEmail(utilisateur.email) ||
        IsNullString(utilisateur.telephone.numero) ||
        utilisateur.password.length < 6 ||
        utilisateur.password != repeatPass) {
      inscriptionProblemesDialog();
      return;
    }

    isLoading.value = true;
    
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: utilisateur.email,
        password: utilisateur.password,
      );
      
      await Utilisateur.setUser(utilisateur);
      
      isLoading.value = false;
      
      Get.off(HomePage());
      Toasts.success(context, description: "Compte créé avec succès");
      Utilisateur.refreshToken();
      
      waitAfter(1000, () {
        function();
      });
      
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      
      if (e.code == 'email-already-in-use') {
        Custom.showDialog(
          const WarningWidget(
            message: "Cette adresse email est déjà utilisée. Veuillez vous connecter !",
          ),
        );
      } else if (e.code == 'invalid-email') {
        Custom.showDialog(
          const WarningWidget(
            message: "Adresse email invalide",
          ),
        );
      }
    } on Exception {
      isLoading.value = false;
      Custom.showDialog(const WarningWidget(
        message: "Une erreur s'est produite.\nVérifiez votre connexion internet",
      ));
    }
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
    
    if (IsNullString(utilisateur.email)) {
      problems.add(_buildProblemItem('Veuillez saisir votre adresse email', isLargeScreen));
    } else if (!GFunctions.isEmail(utilisateur.email)) {
      problems.add(_buildProblemItem('Veuillez saisir une adresse email valide', isLargeScreen));
    }
    
    if (IsNullString(utilisateur.telephone.numero)) {
      problems.add(_buildProblemItem('Veuillez saisir votre numéro de téléphone', isLargeScreen));
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

