import 'package:flutter/cupertino.dart';
import 'package:flutter_paygateglobal/paygate/models/index.dart';
import 'package:flutter_paygateglobal/paygate/paygate.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/my_widgets.dart';

class AbonnementCard extends StatefulWidget {
  final double price;
  final typeAbonnement;
  final String description;
  final int entreprises;
  final String entreprisesMessage;
  AbonnementCard({
    super.key,
    required this.entreprisesMessage,
    required this.entreprises,
    required this.description,
    required this.price,
    required this.typeAbonnement,
  });

  @override
  State<AbonnementCard> createState() => _AbonnementCardState();
}

class _AbonnementCardState extends State<AbonnementCard> {
  String userNumber = 'null';
  late Utilisateur user;
  @override
  void initState() {
    super.initState();
    user = Utilisateur.currentUser.value!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 800;
    var isPremium = widget.typeAbonnement == "Premium";

    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium ? Color(0xFFFF2600).withOpacity(0.3) : Colors.grey[200]!,
          width: isPremium ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPremium 
                ? Color(0xFFFF2600).withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge populaire pour Premium
          if (isPremium) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFF2600),
                borderRadius: BorderRadius.circular(20),
              ),
              child: EText(
                'Populaire',
                color: Colors.white,
                size: 12,
                weight: FontWeight.w600,
              ),
            ),
            
            16.h,
          ],
          
          // Titre de l'abonnement
          EText(
            "Abonnement ${widget.typeAbonnement}",
            size: isLargeScreen ? 28 : 24,
            weight: FontWeight.w700,
            color: Colors.grey[900],
          ),
          
          8.h,
          
          // Prix
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              EText(
                "${widget.price.toInt()} Fcfa",
                size: isLargeScreen ? 48 : 40,
                weight: FontWeight.w800,
                color: Colors.grey[900],
              ),
              
              8.w,
              
              EText(
                "/mois",
                size: isLargeScreen ? 16 : 14,
                weight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ],
          ),
          
          24.h,
          
          // Description
          EText(
            widget.description,
            size: isLargeScreen ? 16 : 14,
            color: Colors.grey[600],
          ),
          
          24.h,
          
          // Fonctionnalités
          _buildFeatureItem('Nombre d\'entreprises', '${widget.entreprises}', isLargeScreen),
          _buildFeatureItem('Avis par an', isPremium ? '3000' : '200', isLargeScreen),
          _buildFeatureItem('Support', isPremium ? 'Prioritaire' : 'Email', isLargeScreen),
          
          32.h,
          
          // Bouton d'abonnement
          LayoutBuilder(
          
            builder:  (context, constraint) {
              return Container(
                width: double.infinity,
                height: isLargeScreen ? 56 : 48,
                child: ElevatedButton(
                  onPressed: () async {
                    Custom.showDialog(Dialog(
                      insetPadding: EdgeInsets.all(8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 700),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: EColumn(children: [
                            Center(
                              child: EText(
                                'Payement',
                                weight: FontWeight.bold,
                                size: 38,
                              ),
                            ),
                            20.h,
                            EText(
                              "Vous êtes sur le point de payer un abonnement ${widget.typeAbonnement} à ${(widget.price * 12).toInt()} Fcfa",
                              align: TextAlign.center,
                            ),
                            20.h,
                            ETextField(
                                number: true,
                                placeholder: "Numéro de paiement",
                                onChanged: (value) {
                                  userNumber = value;
                                },
                                phoneScallerFactor: phoneScallerFactor),
                            20.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SimpleOutlineButton(
                                  radius: 9,
                                  width: constraint.maxWidth / 2 - 40,
                                  onTap: () {
                                    Get.back();
                                  },
                                  text: "Annuler",
                                ),
                                SimpleButton(
                                  radius: 9,
                                  width: constraint.maxWidth / 2 - 40,
                                  onTap: () async {
                                    if (verifierOperateur(userNumber) == null) {
                                      Toasts.error(context,
                                          description:
                                              "Le numero de telephone est invalide");
                                      return;
                                    }
                                    Get.back();
                                    loading();
                                    NewTransactionResponse response =
                                        await Paygate.payV1(
                                      amount: widget.price*12,
                                      provider: verifierOperateur(userNumber) ??
                                          PaygateProvider
                                              .tmoney, // required : PaygateProvider.moovMoney or PaygateProvider.tMoney
                        
                                      description:
                                          'My awesome transaction', // optional : description of the transaction
                                      phoneNumber:
                                          userNumber, // required : phone number of the user
                                    );
                                    Get.back();
                                    print(response.status);
                                    var idPaiement =
                                        "${user.telephone.numero}_${DateTime.now()}";
                                    if (response.status ==
                                        NewTransactionResponseStatus.success) {
                                      var paiement = Paiement(
                                          id: idPaiement,
                                          auteur: user.telephone.numero,
                                          paiementNumero: userNumber,
                                          amount: widget.price * 12,
                                          type: widget.typeAbonnement,
                                          status: "en attente",
                                          date: DateTime.now().toString(),
                                          txReference:
                                              response.txReference ?? "null");
                                      DB
                                          .firestore(Collections.paiements)
                                          .doc(idPaiement)
                                          .set(paiement.toMap());
                                      Custom.showDialog(Dialog(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: 700),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: EColumn(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  BigTitleText(
                                                    "Paiement",
                                                    size: 34,
                                                  ),
                                                  12.h,
                                                  ETextRich(textSpans: [
                                                    ETextSpan(
                                                        text:
                                                            "Veuillez confirmer votre paiement sur votre telephone"),
                                                  ]),
                                                  12.h,
                                                  verifierOperateur(userNumber) ==
                                                          PaygateProvider.moovMoney
                                                      ? ETextRich(textSpans: [
                                                          ETextSpan(
                                                              text: "NB:",
                                                              color:
                                                                  AppColors.color500),
                                                          ETextSpan(
                                                              text:
                                                                  " si vous ne recevez pas de notification, il se peut que votre solde soit insuffisant, veuillez verifier votre solde sur votre compte Moov Money",
                                                              color: Colors.black54)
                                                        ])
                                                      : 0.h,
                                                  12.h,
                                                  SimpleButton(
                                                    radius: 12,
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    text: "D'accord",
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ));
                        
                                      // Verification du paiement
                                      // On attend la confirmation du paiement
                                      Transaction transaction =
                                          await response.verify();
                                      while (!transaction.done &&
                                          !transaction.canceled &&
                                          !transaction.error) {
                                        print(transaction.status);
                                        transaction = await response.verify();
                                        await Future.delayed(3000.milliseconds);
                                        if (transaction.done) {
                                          var limiteAbonnement =
                                              DateTime.now().add(365.days).toString();
                        
                                          user.abonnement = Abonnement(
                                            opinionRecieved: 0,
                                            type: widget.typeAbonnement,
                                            limite: limiteAbonnement,
                                            date: DateTime.now().toString(),
                                          );
                                          // On met à jour l'abonnement de l'utilisateur
                                          paiement.status = "done";
                                          DB
                                              .firestore(Collections.paiements)
                                              .doc(paiement.id)
                                              .set(paiement.toMap());
                                                // On met à jour l'abonnement de l'utilisateur
                        
                                          Utilisateur.setUser(user);
                                          if (Get.isDialogOpen ?? false) {
                                            Get.back();
                                          }
                                          Custom.showDialog(Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: EColumn(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      Assets.icons("done.png"),
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                    BigTitleText(
                                                      "Paiement",
                                                      size: 34,
                                                    ),
                                                    12.h,
                                                    ETextRich(textSpans: [
                                                      ETextSpan(
                                                          text:
                                                              "Votre paiement a été effectué avec succès"),
                                                    ]),
                                                    12.h,
                                                    SimpleButton(
                                                      radius: 12,
                                                      onTap: () {
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      text: "D'accord",
                                                    )
                                                  ]),
                                            ),
                                          ));
                                        }
                                      }
                                      // Verification du paiement
                                      // On attend la confirmation du paiement
                                    } else {
                                      Custom.showDialog(Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: EColumn(children: [
                                            Center(
                                                child: BigTitleText(
                                              "Erreur",
                                              size: 32,
                                            )),
                                            12.h,
                                            ETextRich(textSpans: [
                                              ETextSpan(
                                                  text:
                                                      "Une erreur est survenue lors de votre paiement")
                                            ]),
                                            12.h,
                                            SimpleButton(
                                              radius: 12,
                                              onTap: () {
                                                Get.back();
                                              },
                                              text: "D'accord",
                                            )
                                          ]),
                                        ),
                                      ));
                                    }
                                  },
                                  text: 'Confirmer',
                                )
                              ],
                            )
                          ]),
                        ),
                      ),
                    ));
              
                    // print(response.status);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPremium ? Color(0xFFFF2600) : Colors.grey[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: EText(
                    "S'abonner",
                    size: isLargeScreen ? 16 : 14,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String label, String value, bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLargeScreen ? 12 : 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green[600],
            size: isLargeScreen ? 20 : 18,
          ),
          
          12.w,
          
          Expanded(
            child: EText(
              '$label: $value',
              size: isLargeScreen ? 14 : 13,
              weight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

PaygateProvider? verifierOperateur(String numero) {
  // On enlève les espaces éventuels
  numero = numero.replaceAll(' ', '');

  // Vérifie si le numéro contient exactement 8 chiffres
  if (!RegExp(r'^\d{8}$').hasMatch(numero)) {
    return null;
  }

  // On extrait les deux premiers chiffres (préfixe)
  String prefixe = numero.substring(0, 2);

  // Listes des préfixes
  List<String> moov = ['96', '97', '98', '99', '78', '79'];
  List<String> togocel = ['90', '91', '92', '93', '70', '71', '72'];

  if (moov.contains(prefixe)) {
    return PaygateProvider.moovMoney;
  } else if (togocel.contains(prefixe)) {
    return PaygateProvider.tmoney;
  } else {
    return null;
  }
}
