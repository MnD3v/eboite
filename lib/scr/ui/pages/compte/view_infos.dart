import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/abonnements_liste.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/set_entreprise.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/widgets/view_entreprises.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';

class ViewInfos extends StatelessWidget {
  ViewInfos({super.key});

  var user = Utilisateur.currentUser.value!;
  var sieges = (<String>[]).obs;

  @override
  Widget build(BuildContext context) {
    var utilisateur = Utilisateur.currentUser.value!;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white),
      child: EScaffold(
          color: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: EText(
              "Informations",
              size: 24,
              weight: FontWeight.bold,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EColumn(children: [
       12.h,
              BigTitleText(
                "Suppression de compte",
                color: const Color.fromARGB(255, 255, 17, 0),
              ),
              EText(
                  "Attention : La suppression de votre compte est définitive. Toutes vos données seront effacées et ne pourront pas être récupérées. Cette action est irréversible. Êtes-vous sûr de vouloir continuer ?"),
              12.h,
              SimpleButton(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => TwoOptionsDialog(
                          confirmFunction: () async {
                            loading();
                            await DB
                                .firestore(Collections.utilistateurs)
                                .doc(utilisateur.id)
                                .delete();
                            Get.back();
                            Get.off(Connexion());
                          },
                          body: "Voulez-vous vraiment supprimer ce compte",
                          confirmationText: "Supprimer",
                          title: "Suppression"));
                },
                text: "Supprimer le compte",
              )
            ]),
          )),
    );
  }
}
