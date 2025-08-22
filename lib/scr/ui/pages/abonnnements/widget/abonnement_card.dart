import 'package:flutter/cupertino.dart';
import 'package:flutter_paygateglobal/paygate/models/index.dart';
import 'package:flutter_paygateglobal/paygate/paygate.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/my_widgets.dart';

class AbonnementCard extends StatelessWidget {
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

  String userNumber = 'null';

  var user = Utilisateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: EColumn(
          children: [
            // standart, nbre avis par moi, descsription, selectionner,
            EText(
              "Abonnement $typeAbonnement",
              size: 30,
              color: Colors.orange.shade900,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EText(
                  "${price.toInt()} Fcfa",
                  size: 54,
                  weight: FontWeight.bold,
                ),
                EText(
                  " /mois",
                  size: 16,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.business_center_outlined),
                12.w,
                ETextRich(textSpans: [
                  ETextSpan(text: entreprisesMessage),
                  ETextSpan(
                    text: "$entreprises entreprises",
                    color: AppColors.color500,
                  ),
                ]),
              ],
            ),
            9.h,
         
            16.h,
            EText(description),
            16.h,
            SimpleButton(
              radius: 9,
              onTap: () async {
                Custom.showDialog(Dialog(
                  insetPadding: EdgeInsets.all(8),
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
                        "Vous êtes sur le point de payer un abonnement $typeAbonnement à ${(price * 12).toInt()} Fcfa",
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
                            width: Get.width / 2 - 40,
                            onTap: () {
                              Get.back();
                            },
                            text: "Annuler",
                          ),
                          SimpleButton(
                            radius: 9,
                            width: Get.width / 2 - 40,
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
                                amount: price*12,
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
                                    amount: price * 12,
                                    type: typeAbonnement,
                                    status: "en attente",
                                    date: DateTime.now().toString(),
                                    txReference:
                                        response.txReference ?? "null");
                                DB
                                    .firestore(Collections.paiements)
                                    .doc(idPaiement)
                                    .set(paiement.toMap());
                                Custom.showDialog(Dialog(
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
                                      type: typeAbonnement,
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
                ));

                // print(response.status);
              },
              text: "S'abonner",
            )
          ],
        ),
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
