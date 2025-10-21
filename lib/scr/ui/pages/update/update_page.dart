import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              60.h,
              
              // Carte principale de mise à jour
              Container(
                padding: EdgeInsets.all(32),
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
                    // Icône de mise à jour
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.color500.withOpacity(0.1),
                            AppColors.color500.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.color500.withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.system_update_rounded,
                        color: AppColors.color500,
                        size: 64,
                      ),
                    ),
                    
                    32.h,
                    
                    // Titre principal
                    Text(
                      "Une mise à jour est disponible !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                        height: 1.2,
                      ),
                    ),
                    
                    16.h,
                    
                    // Description
                    Text(
                      "Votre application est actuellement obsolète. Veuillez télécharger la dernière mise à jour disponible pour bénéficier des nouvelles fonctionnalités et améliorations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    
                    24.h,
                    
                    // Informations de téléchargement
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.color500.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.color500.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            color: AppColors.color500,
                            size: 24,
                          ),
                          12.w,
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Taille de téléchargement: ",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: "5,7 Mo",
                                  style: TextStyle(
                                    color: AppColors.color500,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              32.h,
              
              // Boutons d'action
              Column(
                children: [
                  // Bouton de téléchargement principal
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        loading();
                        var q = await DB.firestore(Collections.keys).doc('update').get();

                        var update = Update.fromMap(q.data()!);
                        Get.back();
                        launchUrl(Uri.parse(
                            update.link??'https://play.google.com/store/apps/details?id=com.equilibre.sboite'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      icon: Icon(
                        Icons.download_rounded,
                        size: 24,
                      ),
                      label: Text(
                        "Télécharger maintenant",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Bouton optionnel "Plus tard"
                  if (update.optionel == true) ...[
                    16.h,
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          loading();
                          var sharp = await SharedPreferences.getInstance();
                          var firstOpen = sharp.getBool('firstOpen');
                          await Future.delayed(1.seconds);
                          var user = FirebaseAuth.instance.currentUser;
                          if (user.isNotNul) {
                              await Utilisateur.getUser(user!.email!);
                            await Utilisateur.refreshToken();
                            waitAfter(999, () {
                              Get.back();
                              Get.off(
                                HomePage(),
                                transition: Transition.rightToLeftWithFade,
                                duration: 333.milliseconds,
                              );
                              sharp.setBool('firstOpen', true);
                              waitAfter(333, () {
                                if (currentId != null) {
                                  var notificationData = id_datas[currentId];
                                  if (notificationData == null) {
                                    print("error");
                                    Get.to(const ErrorPage());
                                  } else {
                                    goToDetailPage(
                                        notificationData: notificationData);
                                  }
                                }
                              });
                            });
                          } else {
                              Get.back();

                            Get.off(Connexion());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 1,
                        ),
                        icon: Icon(
                          Icons.schedule_rounded,
                          size: 20,
                        ),
                        label: Text(
                          "Plus tard",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              40.h,
              
              // Informations supplémentaires
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        8.w,
                        Text(
                          "Pourquoi mettre à jour ?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    
                    16.h,
                    
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.color500,
                          size: 18,
                        ),
                        8.w,
                        Expanded(
                          child: Text(
                            "Nouvelles fonctionnalités",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    8.h,
                    
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.color500,
                          size: 18,
                        ),
                        8.w,
                        Expanded(
                          child: Text(
                            "Corrections de bugs",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    8.h,
                    
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.color500,
                          size: 18,
                        ),
                        8.w,
                        Expanded(
                          child: Text(
                            "Amélioration des performances",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              40.h,
            ],
          ),
        ),
      ),
    );
  }
}
