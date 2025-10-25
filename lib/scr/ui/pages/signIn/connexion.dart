import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/inscription.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/my_widgets.dart';

// ignore: must_be_immutable
class Connexion extends StatelessWidget {
  Connexion({
    super.key,
  });
  String email = '';

  String pass = '';

  var passvisible = false.obs;

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
                    
                    // Formulaire de connexion
                    _buildLoginForm(context),
                    
                    32.h,
                    
                    // Lien inscription
                    _buildSignupLink(),
                    
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
          'Connexion',
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
          'Accédez à votre compte eBoite',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
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
          // Champ email
          _buildEmailField(),
          
          24.h,
          
          // Champ mot de passe
          _buildPasswordField(),
          
          32.h,
          
          // Bouton de connexion
          _buildLoginButton(context),
          
          24.h,
          
          // Mot de passe oublié
          _buildForgotPassword(),
        ],
      ),
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
              email = value;
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
              obscureText: !passvisible.value,
              onChanged: (value) {
                pass = value;
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
                    passvisible.value = !passvisible.value;
                  },
                  child: Icon(
                    passvisible.value
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

  Widget _buildLoginButton(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading.value ? null : () => _handleLogin(context),
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
                  'Se connecter',
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

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          _showForgotPasswordDialog();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Mot de passe oublié ?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(Inscription(function: () {}));
          },
          child: Text(
            'Créer un compte',
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

  Future<void> _handleLogin(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    
    if (!GFunctions.isEmail(email)) {
      Toasts.error(context, description: "Entrez une adresse email valide");
      return;
    }
    
    if (pass.length < 6) {
      Toasts.error(context, description: "Le mot de passe doit contenir au moins 6 caractères");
      return;
    }

    isLoading.value = true;
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      
      // Récupérer les données utilisateur depuis Firestore
      var q = await DB
          .firestore(Collections.utilistateurs)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
          
      if (q.docs.isNotEmpty) {
        var utilisateur = Utilisateur.fromMap(q.docs.first.data());
        Utilisateur.currentUser.value = utilisateur;
        
        isLoading.value = false;
        
        Get.off(HomePage());
        Toasts.success(context, description: "Connexion réussie");
        Utilisateur.refreshToken();
      } else {
        isLoading.value = false;
        Custom.showDialog(const WarningWidget(
          message: 'Aucun compte associé à cette adresse email.\nVeuillez créer un compte',
        ));
      }
      
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      
      if (e.code == "network-request-failed") {
        Custom.showDialog(const WarningWidget(
          message: 'Échec de connexion.\nVérifiez votre connexion internet',
        ));
      } else if (e.code == 'invalid-credential') {
        Custom.showDialog(const WarningWidget(
          message: 'Email ou mot de passe incorrect',
        ));
      } else if (e.code == 'user-not-found') {
        Custom.showDialog(const WarningWidget(
          message: 'Aucun compte trouvé avec cette adresse email',
        ));
      }
    } on Exception {
      isLoading.value = false;
      Custom.showDialog(const WarningWidget(
        message: "Une erreur s'est produite.\nVérifiez votre connexion internet",
      ));
    }
  }

  void _showForgotPasswordDialog() {
    String resetEmail = email; // Utilise l'email déjà saisi si disponible
    var isSending = false.obs;
    
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF2600).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.lock_reset_outlined,
                    color: Color(0xFFFF2600),
                    size: 32,
                  ),
                ),
                
                24.h,
                
                // Titre
                Text(
                  'Mot de passe oublié',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                
                8.h,
                
                // Description
                Text(
                  'Entrez votre adresse email pour recevoir un lien de réinitialisation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                
                32.h,
                
                // Champ email
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
                    controller: TextEditingController(text: resetEmail),
                    onChanged: (value) {
                      resetEmail = value;
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                    decoration: InputDecoration(
                      hintText: "Votre adresse email",
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
                
                24.h,
                
                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    
                    16.w,
                    
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: isSending.value ? null : () => _sendResetEmail(resetEmail, isSending),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF2600),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isSending.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Envoyer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetEmail(String email, RxBool isSending) async {
    if (!GFunctions.isEmail(email)) {
      Toasts.error(Get.context!, description: "Entrez une adresse email valide");
      return;
    }

    isSending.value = true;
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      isSending.value = false;
      Get.back(); // Fermer le dialog
      
      // Afficher un message de succès
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône de succès
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[600],
                      size: 32,
                    ),
                  ),
                  
                  24.h,
                  
                  // Titre
                  Text(
                    'Email envoyé !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                  ),
                  
                  8.h,
                  
                  // Message
                  Text(
                    'Un email de réinitialisation a été envoyé à $email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  
                  16.h,
                  
                  Text(
                    'Vérifiez votre boîte de réception et suivez les instructions pour réinitialiser votre mot de passe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                  
                  8.h,
                  
                  Text(
                    '💡 Si vous ne recevez pas l\'email, vérifiez votre dossier spam/courrier indésirable.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF2600),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  24.h,
                  
                  // Bouton OK
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Compris',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      isSending.value = false;
      
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Aucun compte trouvé avec cette adresse email';
          break;
        case 'invalid-email':
          errorMessage = 'Adresse email invalide';
          break;
        case 'too-many-requests':
          errorMessage = 'Trop de tentatives. Veuillez réessayer plus tard';
          break;
        default:
          errorMessage = 'Erreur lors de l\'envoi de l\'email de réinitialisation';
      }
      
      Toasts.error(Get.context!, description: errorMessage);
      
    } on Exception {
      isSending.value = false;
      Toasts.error(Get.context!, description: "Une erreur s'est produite. Vérifiez votre connexion internet");
    }
  }
}

