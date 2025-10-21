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
    var isLargeScreen = screenWidth > 1200;
    var isMediumScreen = screenWidth > 800 && screenWidth <= 1200;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: EScaffold(
        color: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: EText(
            "Mon compte",
            size: 22,
            font: Fonts.poppinsBold,
            weight: FontWeight.w700,
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
                horizontal: isLargeScreen ? 48 : isMediumScreen ? 32 : 20,
                vertical: isLargeScreen ? 40 : isMediumScreen ? 28 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 1200 : isMediumScreen ? 900 : double.infinity,
                  ),
                  child: isLargeScreen 
                    ? _buildLargeScreenLayout(isLargeScreen, isMediumScreen, context)
                    : _buildMobileLayout(isLargeScreen, isMediumScreen, context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout(bool isLargeScreen, bool isMediumScreen, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne gauche - Profil et Plus
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileSection(isLargeScreen, isMediumScreen),
              
              (isLargeScreen ? 32 : 24).h,
              
              _buildPlusSection(isLargeScreen, isMediumScreen),
              
              (isLargeScreen ? 40 : 32).h,
              
              _buildLogoutSection(context, isLargeScreen),
            ],
          ),
        ),
        
        (isLargeScreen ? 32 : 24).w,
        
        // Colonne droite - Entreprises et Footer
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildEntreprisesSection(isLargeScreen, isMediumScreen),
              
              (isLargeScreen ? 40 : 32).h,
              
              _buildFooter(isLargeScreen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isLargeScreen, bool isMediumScreen, BuildContext context) {
    return Column(
      children: [
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
                              EText(
                                "${Utilisateur.currentUser.value!.nom} ${Utilisateur.currentUser.value!.prenom}",
                                size: isLargeScreen ? 26 : 22,
                                weight: FontWeight.w700,
                                color: Colors.grey[800],
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
                                  EText(
                                    "${Utilisateur.currentUser.value!.telephone.indicatif} ${Utilisateur.currentUser.value!.telephone.numero}",
                                    size: isLargeScreen ? 18 : 16,
                                    color: Colors.grey[600],
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EText(
                                "Me connecter / M'inscrire",
                                size: isLargeScreen ? 24 : 20,
                                weight: FontWeight.w700,
                                color: AppColors.color500,
                              ),
                              (isLargeScreen ? 12 : 8).h,
                              EText(
                                "Accédez à votre compte",
                                size: isLargeScreen ? 16 : 14,
                                color: Colors.grey[600],
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
        child: isLargeScreen 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EText(
                  "Entreprises",
                  size: isLargeScreen ? 28 : 24,
                  weight: FontWeight.w700,
                  color: AppColors.color500,
                ),
                (isLargeScreen ? 16 : 12).h,
                EText(
                  "Créez, modifiez et gérez vos entreprises",
                  size: isLargeScreen ? 18 : 16,
                  color: Colors.white.withOpacity(0.9),
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
                        EText(
                          "Gérer mes entreprises",
                          color: Colors.black,
                          weight: FontWeight.w700,
                          size: isLargeScreen ? 18 : 16,
                        ),
                      ],
                    ),
                  ),
                ),
                (isLargeScreen ? 24 : 20).h,
                // Icône entreprise centrée
                Center(
                  child: Container(
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
                ),
              ],
            )
          : Row(
              children: [
                // Contenu textuel
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        "Entreprises",
                        size: isLargeScreen ? 28 : 24,
                        weight: FontWeight.w700,
                        color: AppColors.color500,
                      ),
                      (isLargeScreen ? 16 : 12).h,
                      EText(
                        "Créez, modifiez et gérez vos entreprises",
                        size: isLargeScreen ? 18 : 16,
                        color: Colors.white.withOpacity(0.9),
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
                              EText(
                                "Gérer mes entreprises",
                                color: Colors.black,
                                weight: FontWeight.w700,
                                size: isLargeScreen ? 18 : 16,
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
        EText(
          "Plus",
          size: isLargeScreen ? 28 : 24,
          weight: FontWeight.w700,
          color: Colors.white,
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
                      EText(
                        title,
                        size: isLargeScreen ? 20 : 18,
                        weight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      (isLargeScreen ? 6 : 4).h,
                      EText(
                        subtitle,
                        size: isLargeScreen ? 16 : 14,
                        color: Colors.grey[600],
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
          : SimpleButton(
            color: const Color.fromARGB(255, 255, 17, 0),
            onTap: () {
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
            
            child: EText(
              "Se déconnecter",
              size: isLargeScreen ? 20 : 18,
              weight: FontWeight.w600,
              color: Colors.white,
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
        EText(
          "v1.0.0+4",
          color: Colors.white.withOpacity(0.7),
          size: isLargeScreen ? 16 : 14,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}


