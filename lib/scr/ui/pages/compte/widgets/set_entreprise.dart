import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/real_state/models/entreprise.dart';

class SetEntreprise extends StatelessWidget {
  SetEntreprise(
      {super.key,
      this.index,
      required this.id,
      required this.nom,
      required this.selectedItems,
      required this.sieges,
      required this.user});

  RxList<String> sieges;
  int? index;
  String nom;
  final user;
  RxList<String> selectedItems;
  String id;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: EColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EText(
              "Ajouter une entreprise",
              size: 28,
              weight: FontWeight.bold,
            ),
            12.h,
            EText("Nom"),
            ETextField(
                placeholder: "Entrez le nom de l'entreprise",
                initialValue: nom,
                onChanged: (text) {
                  nom = text;
                },
                phoneScallerFactor: phoneScallerFactor),
            12.h,
            index != null ? 0.h : EText("ID"),
            index != null
                ? 0.h
                : ETextField(
                    placeholder: "Entrez l'ID de l'entreprise",
                    initialValue: id,
                    onChanged: (text) {
                      id = text.toLowerCase();
                    },
                    phoneScallerFactor: phoneScallerFactor),
            index != null ? 0.h : 12.h,
            EText("Cellules"),
            Obx(
              () => Wrap(
                spacing: 12,
                children: sieges
                    .map(
                      (element) => 
                      
                      GestureDetector(
                            onTap: (){
                              Get.dialog(TwoOptionsDialog(confirmFunction: (){
                                sieges.remove(element);
                                Get.back();
                              }, body: "Voulez-vous vraiment supprimer cette variable ?", confirmationText: "Supprimer", title: "Suppression"));
                            },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(9)),
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                          child: EText(
                            element,
                            color: AppColors.color500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            12.h,
            FloatingActionButton(
              onPressed: () {
                var siege = "";
                Custom.showDialog(Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: EColumn(children: [
                      EText("Nom de la cellule"),
                      ETextField(
                          onChanged: (value) {
                            siege = value;
                          },
                          phoneScallerFactor: phoneScallerFactor),
                      12.h,
                      SimpleButton(
                        onTap: () {
                          if (siege == "") {
                            Toasts.error(context,
                                description:
                                    "Veuillez ajouter le titre de la cellule");
                            return;
                          }
                          sieges.add(siege);
                          Get.back();
                        },
                        text: "Ajouter",
                      )
                    ]),
                  ),
                ));
              },
              child: Icon(Icons.add, color: AppColors.white),
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Colonne des cases à cocher
                  ...["Suggestion", "Idée", "Plainte", "Appréciation"]
                      .map(
                        (element) => CheckboxListTile(
                          title: EText(element),
                          value: selectedItems.contains(element),
                          onChanged: (bool? value) {
                            if (value!) {
                              selectedItems.add(element);
                            } else {
                              selectedItems.remove(element);
                            }
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            SimpleButton(
              radius: 6,
              onTap: () async {
                if (nom.isEmpty) {
                  Toasts.error(context,
                      description: "Veuillez saisir le nom de l'entreprise");
                  return;
                }
                if (id.isEmpty) {
                  Toasts.error(context,
                      description: "Veuillez saisir l'id de l'entreprise");
                  return;
                }
                if (selectedItems.isEmpty) {
                  Toasts.error(context,
                      description: "Veuillez selectionner les types d'avis");
                  return;
                }
                loading();

                if (index != null) {}

                var doc = DB.firestore(Collections.entreprises).doc(id);
                if ((await doc.get()).exists && index == null) {
                  Get.back();
                  Toasts.error(context, description: "ID déjà utilisé");
                  return;
                }
                await doc.set(RealEntreprise(
                        sieges: sieges,
                        auteur: user.telephone.numero,
                        nom: nom,
                        id: id.toLowerCase(),
                        categories: selectedItems)
                    .toMap());
                if (index == null) {
                  user.entreprises.add(RealEntreprise(
                    nom: nom,
                    id: id,
                    auteur: user.telephone.numero,
                    categories: selectedItems,
                    sieges: sieges,
                  ));
                } else {
                  user.entreprises[index] = RealEntreprise(
                    nom: nom,
                    id: id,
                    auteur: user.telephone.numero,
                    categories: selectedItems,
                    sieges: sieges,
                  );
                }

                await Utilisateur.setUser(user);
                Get.back();
                Get.back();
                Get.showSnackbar(
                  GetSnackBar(
                    title: "Succès",
                    message: "L'entreprise est crée avec succès",
                    duration: 2.seconds,
                  ),
                );
              },
              child: EText(
                "Enregistrer",
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
