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

    return EScaffold(
      color: const Color(0xFFF8F9FA), // Very light grey for a clean background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: EText(
            "Mon compte",
            size: 28,
            font: Fonts.poppinsBold,
            weight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings_outlined,
                    color: Colors.black87, size: 24),
                tooltip: "Paramètres",
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 48 : 24,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : 600,
                ),
                child: Column(
                  children: [
                    _buildProfileCard(context),
                    const SizedBox(height: 24),
                    _buildEntreprisesCard(context),
                    const SizedBox(height: 24),
                    _buildMenuSection(context),
                    const SizedBox(height: 32),
                    _buildLogoutButton(context),
                    const SizedBox(height: 40),
                    _buildFooter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Get.to(ViewInfos()),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.color500,
                        AppColors.color500.withOpacity(0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.color500.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(() {
                    final user = Utilisateur.currentUser.value;
                    if (user != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EText(
                            "${user.nom} ${user.prenom}",
                            size: 20,
                            weight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              EText(
                                "${user.telephone.indicatif} ${user.telephone.numero}",
                                size: 14,
                                color: Colors.grey[600],
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EText(
                            "Se connecter",
                            size: 20,
                            weight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 4),
                          EText(
                            "Accédez à votre espace personnel",
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ],
                      );
                    }
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntreprisesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            final user = Utilisateur.currentUser.value;
            if (user != null) {
              if (user.abonnement.isNul ||
                  DateTime.parse(user.abonnement!.limite)
                      .isBefore(DateTime.now())) {
                Get.to(AbonnementsListe());
              } else {
                Get.to(ViewUser(utilisateur: user));
              }
            } else {
              Get.to(Connexion());
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.business_rounded,
                      color: Colors.blueGrey[800], size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        "Mes Entreprises",
                        size: 18,
                        weight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 6),
                      EText(
                        "Gérez vos activités professionnelles",
                        size: 14,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: "Conditions générales",
            onTap: () =>
                launchUrl(Uri.parse("https://www.eboite.co/privacy-policy")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: "Politique de confidentialité",
            onTap: () =>
                launchUrl(Uri.parse("https://www.eboite.co/privacy-policy")),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: EText(
                  title,
                  size: 16,
                  weight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Obx(() {
      if (Utilisateur.currentUser.value == null) return const SizedBox.shrink();
      return Center(
        child: TextButton(
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
                Toasts.success(context, description: "Déconnexion réussie");
              },
              body: "Voulez-vous vraiment vous déconnecter ?",
              title: "Déconnexion",
            ));
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.red.withOpacity(0.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout_rounded, size: 18),
              const SizedBox(width: 8),
              EText("Se déconnecter",
                  color: Colors.red, weight: FontWeight.w600, size: 15),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Opacity(
          opacity: 0.3,
          child: Image(
            image: AssetImage(Assets.icons("logo-text.png")),
            height: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        EText(
          "v1.0.0+4",
          color: Colors.grey[400],
          size: 12,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}
