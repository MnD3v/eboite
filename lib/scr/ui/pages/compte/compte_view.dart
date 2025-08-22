import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/view_infos.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/view_entreprises.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:url_launcher/url_launcher.dart';

class Compte extends StatelessWidget {
  const Compte({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isLargeScreen = screenWidth > 1200;
    var isMediumScreen = screenWidth > 800 && screenWidth <= 1200;
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.image("bg.png")),
          fit: BoxFit.cover,
        ),
      ),
      child: EScaffold(
        color: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Mon compte",
            style: TextStyle(
              fontSize: isLargeScreen ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(isLargeScreen ? 10 : 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: isLargeScreen ? 24 : 20,
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 40 : 20,
                vertical: isLargeScreen ? 32 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 800 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      // Espacement adaptatif pour centrer verticalement sur grands écrans
                      if (isLargeScreen) 
                        SizedBox(height: screenHeight * 0.05)
                      else
                        0.h,
                      
                      // Section profil utilisateur
                      _buildProfileSection(isLargeScreen, isMediumScreen),
                      
                      (isLargeScreen ? 32 : 24).h,
                      
                      // Section entreprises
                      _buildEntreprisesSection(isLargeScreen, isMediumScreen),
                      
                      (isLargeScreen ? 40 : 32).h,
                      
                      // Section plus
                      _buildPlusSection(isLargeScreen, isMediumScreen),
                      
                      (isLargeScreen ? 40 : 32).h,
                      
                      // Section déconnexion
                      _buildLogoutSection(context, isLargeScreen),
                      
                      (isLargeScreen ? 60 : 40).h,
                      
                      // Footer
                      _buildFooter(isLargeScreen),
                      
                      (isLargeScreen ? 60 : 40).h,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isLargeScreen, bool isMediumScreen) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isLargeScreen ? 28 : 24),
          onTap: () {
            Get.to(ViewInfos());
          },
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
            child: Row(
              children: [
                // Avatar utilisateur
                Container(
                  width: isLargeScreen ? 90 : 70,
                  height: isLargeScreen ? 90 : 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.color500,
                        AppColors.color500.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.color500.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: isLargeScreen ? 40 : 32,
                  ),
                ),
                
                (isLargeScreen ? 28 : 20).w,
                
                // Informations utilisateur
                Expanded(
                  child: Obx(
                    () => Utilisateur.currentUser.value != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${Utilisateur.currentUser.value!.nom} ${Utilisateur.currentUser.value!.prenom}",
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 26 : 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                ),
                              ),
                              (isLargeScreen ? 12 : 8).h,
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Colors.grey[600],
                                    size: isLargeScreen ? 20 : 18,
                                  ),
                                  (isLargeScreen ? 10 : 8).w,
                                  Text(
                                    "${Utilisateur.currentUser.value!.telephone.indicatif} ${Utilisateur.currentUser.value!.telephone.numero}",
                                    style: TextStyle(
                                      fontSize: isLargeScreen ? 18 : 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Me connecter / M'inscrire",
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 24 : 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.color500,
                                ),
                              ),
                              (isLargeScreen ? 12 : 8).h,
                              Text(
                                "Accédez à votre compte",
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 16 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                // Flèche
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 10 : 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: isLargeScreen ? 20 : 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntreprisesSection(bool isLargeScreen, bool isMediumScreen) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(isLargeScreen ? 28 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: Offset(0, 15),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
        child: Row(
          children: [
            // Contenu textuel
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Entreprises",
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.color500,
                    ),
                  ),
                  (isLargeScreen ? 16 : 12).h,
                  Text(
                    "Créez, modifiez et gérez vos entreprises",
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                  (isLargeScreen ? 28 : 20).h,
                  GestureDetector(
                    onTap: () {
                      Utilisateur.currentUser.value!.abonnement.isNul ||
                              DateTime.parse(Utilisateur.currentUser.value!.abonnement!.limite).isBefore(DateTime.now())
                          ? Get.to(AbonnementsListe())
                          : Get.to(ViewUser(utilisateur: Utilisateur.currentUser.value!));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 24 : 20, 
                        vertical: isLargeScreen ? 16 : 12
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business_outlined,
                            color: Colors.black,
                            size: isLargeScreen ? 20 : 18,
                          ),
                          (isLargeScreen ? 10 : 8).w,
                          Text(
                            "Gérer mes entreprises",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: isLargeScreen ? 18 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            (isLargeScreen ? 28 : 20).w,
            
            // Icône entreprise
            Container(
              width: isLargeScreen ? 100 : 80,
              height: isLargeScreen ? 100 : 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
              ),
              child: Icon(
                Icons.business,
                color: Colors.white,
                size: isLargeScreen ? 48 : 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlusSection(bool isLargeScreen, bool isMediumScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Plus",
          style: TextStyle(
            fontSize: isLargeScreen ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        (isLargeScreen ? 28 : 20).h,
        
        _buildPlusElement(
          icon: Icons.description_outlined,
          title: "Conditions générales d'utilisation",
          subtitle: "Lire nos conditions",
          onTap: () {
            launchUrl(Uri.parse("https://www.eboite.co/privacy-policy"));
          },
          isLargeScreen: isLargeScreen,
        ),
        
        (isLargeScreen ? 20 : 16).h,
        
        _buildPlusElement(
          icon: Icons.security_outlined,
          title: "Protection de données",
          subtitle: "Votre vie privée",
          onTap: () {
            launchUrl(Uri.parse("https://www.eboite.co/privacy-policy"));
          },
          isLargeScreen: isLargeScreen,
        ),
      ],
    );
  }

  Widget _buildPlusElement({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isLargeScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
            child: Row(
              children: [
                // Icône
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 16 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.color500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isLargeScreen ? 20 : 16),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.color500,
                    size: isLargeScreen ? 28 : 24,
                  ),
                ),
                
                (isLargeScreen ? 20 : 16).w,
                
                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 20 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      (isLargeScreen ? 6 : 4).h,
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flèche
                Icon(
                  Icons.arrow_forward_ios,
                  size: isLargeScreen ? 20 : 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isLargeScreen) {
    return Obx(
      () => Utilisateur.currentUser.value == null
          ? SizedBox.shrink()
          : Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Custom.showDialog(TwoOptionsDialog(
                    confirmationText: "Me déconnecter",
                    confirmFunction: () {
                      FirebaseAuth.instance.signOut();
                      Utilisateur.currentUser.value = null;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Connexion()),
                        (route) => false,
                      );
                      Toasts.success(context, description: "Vous vous êtes déconnecté avec succès");
                    },
                    body: "Voulez-vous vraiment vous déconnecter ?",
                    title: "Déconnexion",
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[500],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isLargeScreen ? 22 : 18
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
                  ),
                  elevation: 3,
                ),
                icon: Icon(
                  Icons.logout_rounded,
                  size: isLargeScreen ? 26 : 22,
                ),
                label: Text(
                  "Se déconnecter",
                  style: TextStyle(
                    fontSize: isLargeScreen ? 20 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildFooter(bool isLargeScreen) {
    return Column(
      children: [
        // Logo
        Container(
          padding: EdgeInsets.all(isLargeScreen ? 28 : 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
          ),
          child: Image(
            image: AssetImage(Assets.icons("logo-text.png")),
            height: isLargeScreen ? 45 : 35,
            color: Colors.white,
          ),
        ),
        
        (isLargeScreen ? 20 : 16).h,
        
        // Version
        Text(
          "v1.0.0+4",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: isLargeScreen ? 16 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}


