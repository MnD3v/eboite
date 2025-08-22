import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/widget/abonnement_card.dart';

class AbonnementsListe extends StatelessWidget {
  const AbonnementsListe({super.key, this.onlyPremium});
  final bool? onlyPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.image("bg.png")), fit: BoxFit.cover)),
      child: EScaffold(
        color: Colors.transparent,
        appBar: AppBar(
          title: BigTitleText("Liste des abonnements"),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: EColumn(children: [
       onlyPremium == true? 0.h:     AbonnementCard(
              price: 2000,
              entreprises: 1,
              entreprisesMessage: "Maximum de ",
              typeAbonnement: "Standard",
              description:
                  "Commencez en toute simplicité avec 200 retours par an. L’essentiel pour tester et grandir sans stress.",
            ),
            AbonnementCard(
              price: 3000,
              entreprises: 5,
              entreprisesMessage: "Jusqu'à ",
              typeAbonnement: "Premium",
              description:
                  "Passez à la vitesse supérieure avec 3000 avis par an. Obtenez une vision claire et massive de votre impact.",
            ),
          ]),
        ),
      ),
    );
  }
}
