import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/abonnnements/widget/abonnement_card.dart';

class AbonnementsListe extends StatelessWidget {
  const AbonnementsListe({super.key, this.onlyPremium});
  final bool? onlyPremium;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Nos abonnements",
          style: TextStyle(
            fontSize: isLargeScreen ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 32 : 16,
            vertical: 24,
          ),
          child: Column(
            children: [
              // Header section
              _buildHeader(isLargeScreen),
              
              48.h,
              
              // Pricing cards
              _buildPricingCards(isLargeScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Column(
      children: [
        Text(
          'Choisissez votre plan',
          style: TextStyle(
            fontSize: isLargeScreen ? 36 : 28,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        16.h,
        
        Text(
          'Sélectionnez l\'abonnement qui correspond le mieux à vos besoins',
          style: TextStyle(
            fontSize: isLargeScreen ? 18 : 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPricingCards(bool isLargeScreen) {
    return isLargeScreen
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AbonnementCard(
                  price: 2000,
                  entreprises: 1,
                  entreprisesMessage: "Maximum de ",
                  typeAbonnement: "Standard",
                  description: "Commencez en toute simplicité avec 200 retours par an. L'essentiel pour tester et grandir sans stress.",
                ),
              ),
              
              24.w,
              
              Expanded(
                child: AbonnementCard(
                  price: 3000,
                  entreprises: 5,
                  entreprisesMessage: "Jusqu'à ",
                  typeAbonnement: "Premium",
                  description: "Passez à la vitesse supérieure avec 3000 avis par an. Obtenez une vision claire et massive de votre impact.",
                ),
              ),
            ],
          )
        : Column(
            children: [
              if (onlyPremium != true) ...[
                AbonnementCard(
                  price: 2000,
                  entreprises: 1,
                  entreprisesMessage: "Maximum de ",
                  typeAbonnement: "Standard",
                  description: "Commencez en toute simplicité avec 200 retours par an. L'essentiel pour tester et grandir sans stress.",
                ),
                
                24.h,
              ],
              
              AbonnementCard(
                price: 3000,
                entreprises: 5,
                entreprisesMessage: "Jusqu'à ",
                typeAbonnement: "Premium",
                description: "Passez à la vitesse supérieure avec 3000 avis par an. Obtenez une vision claire et massive de votre impact.",
              ),
            ],
          );
  }

}
