import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewInfos extends StatelessWidget {
  ViewInfos({super.key});

  final RxList<String> sieges = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 800;
    
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: EScaffold(
        color: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: EText(
            "Informations du compte",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 600 : double.infinity,
              ),
              child: Obx(() {
                var utilisateur = Utilisateur.currentUser.value!;
                return EColumn(
                  children: [
                    16.h,
                    
                    // Section Informations personnelles
                    _buildSectionCard(
                      title: "Informations personnelles",
                      icon: Icons.person_outline,
                      children: [
                        _buildInfoRow("Nom", utilisateur.nom),
                        _buildInfoRow("Prénom", utilisateur.prenom),
                        _buildInfoRow("Email", utilisateur.email),
                        _buildInfoRow("Téléphone", "${utilisateur.telephone.indicatif} ${utilisateur.telephone.numero}"),
                        if (utilisateur.country != null) _buildInfoRow("Pays", utilisateur.country!),
                      ],
                      actionButton: _buildEditButton("Modifier", () => _showEditInfoDialog()),
                    ),
                    
                    24.h,
                    
                    // Section Mot de passe
                    _buildSectionCard(
                      title: "Sécurité",
                      icon: Icons.lock_outline,
                      children: [
                        _buildInfoRow("Mot de passe", "••••••••", isPassword: true),
                      ],
                      actionButton: _buildEditButton("Changer", () => _showChangePasswordDialog()),
                    ),
                    
                    24.h,
                    
                  // Section Abonnement
                  if (utilisateur.abonnement != null)
                    _buildSectionCard(
                      title: "Abonnement",
                      icon: Icons.card_membership_outlined,
                      children: [
                        _buildInfoRow("Type", utilisateur.abonnement!.type),
                        _buildInfoRow("Limite", utilisateur.abonnement!.limite),
                        _buildInfoRow("Date", utilisateur.abonnement!.date),
                      ],
                      actionButton: _buildEditButton("Gérer", () => Get.to(AbonnementsListe())),
                    ),
                    
                    24.h,
                    
                    // Section Suppression de compte
                    _buildDangerSection(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? actionButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF2600).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Color(0xFFFF2600), size: 20),
                ),
                12.w,
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                if (actionButton != null) actionButton,
              ],
            ),
            16.h,
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          16.w,
          Expanded(
            child: Text(
              isPassword ? "••••••••" : value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFFF2600),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDangerSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.warning_outlined, color: Colors.red[600], size: 20),
                ),
                12.w,
                Text(
                  "Zone dangereuse",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[800],
                  ),
                ),
              ],
            ),
            16.h,
            Text(
              "Attention : La suppression de votre compte est définitive. Toutes vos données seront effacées et ne pourront pas être récupérées. Cette action est irréversible.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[700],
                height: 1.5,
              ),
            ),
            16.h,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDeleteAccountDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Supprimer le compte",
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

  void _showEditInfoDialog() {
    var utilisateur = Utilisateur.currentUser.value!;
    String nom = utilisateur.nom;
    String prenom = utilisateur.prenom;
    String email = utilisateur.email;
    String numero = utilisateur.telephone.numero;
    String indicatif = utilisateur.telephone.indicatif;
    String? country = utilisateur.country;
    var isSaving = false.obs;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
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
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF2600).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.edit_outlined, color: Color(0xFFFF2600), size: 24),
                    ),
                    16.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Modifier les informations",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[900],
                            ),
                          ),
                          4.h,
                          Text(
                            "Mettez à jour vos informations personnelles",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close, color: Colors.grey[600], size: 20),
                      ),
                    ),
                  ],
                ),
                
                32.h,
                
                // Formulaire
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEditField("Nom", nom, (value) => nom = value),
                      16.h,
                      _buildEditField("Prénom", prenom, (value) => prenom = value),
                      16.h,
                      _buildEditField("Email", email, (value) => email = value, isEmail: true),
                      16.h,
                      _buildEditField("Numéro de téléphone", numero, (value) => numero = value, isPhone: true),
                      16.h,
                      _buildEditField("Pays", country ?? "", (value) => country = value),
                    ],
                  ),
                ),
                
                32.h,
                
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
                          onPressed: isSaving.value ? null : () => _saveUserInfo(nom, prenom, email, numero, indicatif, country, isSaving),
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
                          child: isSaving.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Enregistrer',
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

  Widget _buildEditField(String label, String initialValue, Function(String) onChanged, {bool isEmail = false, bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: TextEditingController(text: initialValue),
            keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveUserInfo(String nom, String prenom, String email, String numero, String indicatif, String? country, RxBool isSaving) async {
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty || numero.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez remplir tous les champs obligatoires");
      return;
    }

    if (!GFunctions.isEmail(email)) {
      Toasts.error(Get.context!, description: "Entrez une adresse email valide");
      return;
    }

    isSaving.value = true;
    
    try {
      var utilisateur = Utilisateur.currentUser.value!;
      var updatedUser = utilisateur.copyWith(
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: Telephone(numero: numero, indicatif: indicatif),
        country: country,
      );
      
      await Utilisateur.setUser(updatedUser);
      
      isSaving.value = false;
      Get.back();
      Toasts.success(Get.context!, description: "Informations mises à jour avec succès");
      
    } catch (e) {
      isSaving.value = false;
      Toasts.error(Get.context!, description: "Erreur lors de la mise à jour");
    }
  }

  void _showChangePasswordDialog() {
    String currentPassword = "";
    String newPassword = "";
    String confirmPassword = "";
    var isChanging = false.obs;
    var showCurrentPassword = false.obs;
    var showNewPassword = false.obs;
    var showConfirmPassword = false.obs;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
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
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF2600).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.lock_reset_outlined, color: Color(0xFFFF2600), size: 24),
                    ),
                    16.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Changer le mot de passe",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[900],
                            ),
                          ),
                          4.h,
                          Text(
                            "Sécurisez votre compte avec un nouveau mot de passe",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close, color: Colors.grey[600], size: 20),
                      ),
                    ),
                  ],
                ),
                
                32.h,
                
                // Formulaire
                Column(
                  children: [
                    _buildPasswordField("Mot de passe actuel", currentPassword, (value) => currentPassword = value, showCurrentPassword),
                    16.h,
                    _buildPasswordField("Nouveau mot de passe", newPassword, (value) => newPassword = value, showNewPassword),
                    16.h,
                    _buildPasswordField("Confirmer le mot de passe", confirmPassword, (value) => confirmPassword = value, showConfirmPassword),
                  ],
                ),
                
                32.h,
                
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
                          onPressed: isChanging.value ? null : () => _changePassword(currentPassword, newPassword, confirmPassword, isChanging),
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
                          child: isChanging.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Changer',
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

  Widget _buildPasswordField(String label, String value, Function(String) onChanged, RxBool showPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: TextEditingController(text: value),
              obscureText: !showPassword.value,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: GestureDetector(
                  onTap: () => showPassword.value = !showPassword.value,
                  child: Icon(
                    showPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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

  Future<void> _changePassword(String currentPassword, String newPassword, String confirmPassword, RxBool isChanging) async {
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez remplir tous les champs");
      return;
    }

    if (newPassword.length < 6) {
      Toasts.error(Get.context!, description: "Le nouveau mot de passe doit contenir au moins 6 caractères");
      return;
    }

    if (newPassword != confirmPassword) {
      Toasts.error(Get.context!, description: "Les mots de passe ne correspondent pas");
      return;
    }

    isChanging.value = true;
    
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Réauthentifier l'utilisateur
        var credential = EmailAuthProvider.credential(
          email: Utilisateur.currentUser.value!.email,
          password: currentPassword,
        );
        
        await user.reauthenticateWithCredential(credential);
        
        // Changer le mot de passe
        await user.updatePassword(newPassword);
        
        // Mettre à jour dans Firestore
        var updatedUser = Utilisateur.currentUser.value!.copyWith(password: newPassword);
        await Utilisateur.setUser(updatedUser);
        
        isChanging.value = false;
        Get.back();
        Toasts.success(Get.context!, description: "Mot de passe changé avec succès");
      }
      
    } on FirebaseAuthException catch (e) {
      isChanging.value = false;
      
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Le mot de passe actuel que vous avez saisi est incorrect. Veuillez vérifier et réessayer.';
          break;
        case 'weak-password':
          errorMessage = 'Le nouveau mot de passe est trop faible. Il doit contenir au moins 6 caractères.';
          break;
        case 'requires-recent-login':
          errorMessage = 'Pour des raisons de sécurité, veuillez vous reconnecter avant de changer votre mot de passe.';
          break;
        default:
          errorMessage = 'Erreur lors du changement de mot de passe. Veuillez réessayer.';
      }
      
      Toasts.error(Get.context!, description: errorMessage);
      
    } catch (e) {
      isChanging.value = false;
      Toasts.error(Get.context!, description: "Une erreur s'est produite");
    }
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
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
                // Icône d'alerte
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.warning_outlined, color: Colors.red[600], size: 32),
                ),
                
                24.h,
                
                // Titre
                Text(
                  'Supprimer le compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.red[800],
                  ),
                ),
                
                8.h,
                
                // Message
                Text(
                  'Cette action est irréversible. Toutes vos données seront définitivement supprimées :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                
                16.h,
                
                // Liste des données supprimées
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDeleteItem("• Vos informations personnelles"),
                      _buildDeleteItem("• Toutes vos entreprises"),
                      _buildDeleteItem("• Tous les messages reçus"),
                      _buildDeleteItem("• Votre historique d'activité"),
                      _buildDeleteItem("• Vos paramètres et préférences"),
                    ],
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
                      child: ElevatedButton(
                        onPressed: () => _deleteAccount(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Supprimer définitivement',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      loading();
      
      var utilisateur = Utilisateur.currentUser.value!;
      
      // Supprimer de Firestore
      await DB.firestore(Collections.utilistateurs).doc(utilisateur.email).delete();
      
      // Supprimer le compte Firebase Auth
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      
      Get.back(); // Fermer le loading
      Get.back(); // Fermer le dialog
      Get.off(Connexion()); // Retour à la connexion
      
      Toasts.success(Get.context!, description: "Compte supprimé avec succès");
      
    } catch (e) {
      Get.back(); // Fermer le loading
      Toasts.error(Get.context!, description: "Erreur lors de la suppression du compte");
    }
  }
}
