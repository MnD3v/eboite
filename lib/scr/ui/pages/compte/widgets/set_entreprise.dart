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
      required this.description,
      required this.user});

  RxList<String> sieges;
  int? index;
  String nom;
  String description;
  final user;
  RxList<String> selectedItems;
  String id;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header avec gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.color500, AppColors.color400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.business,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  16.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EText(
                          index != null ? "Modifier l'entreprise" : "Nouvelle entreprise",
                          size: 24,
                          weight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        4.h,
                        EText(
                          "Configurez les informations de votre entreprise",
                          size: 14,
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenu scrollable
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: EColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations générales
                    _buildSectionHeader("Informations générales", Icons.info_outline),
                    16.h,
                    
                    // Nom de l'entreprise
                    _buildInputField(
                      label: "Nom de l'entreprise",
                      placeholder: "Entrez le nom de votre entreprise",
                      initialValue: nom,
                      onChanged: (text) => nom = text,
                      icon: Icons.business_outlined,
                    ),
                    20.h,
                    
                    // Description
                    _buildInputField(
                      label: "Description",
                      placeholder: "Décrivez l'activité de votre entreprise",
                      initialValue: description,
                      onChanged: (text) => description = text,
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    20.h,
                    
                    // ID (seulement pour nouvelle entreprise)
                    if (index == null) ...[
                      _buildInputField(
                        label: "Identifiant unique",
                        placeholder: "Entrez un ID unique pour votre entreprise",
                        initialValue: id,
                        onChanged: (text) => id = text.toLowerCase(),
                        icon: Icons.tag_outlined,
                        helperText: "Cet ID sera utilisé pour identifier votre entreprise",
                      ),
                      20.h,
                    ],
                    
                    // Section Cellules
                    _buildSectionHeader("Cellules de l'entreprise", Icons.location_city_outlined),
                    16.h,
                    
                    Obx(() => Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.color200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EText(
                            "Cellules configurées (${sieges.length})",
                            size: 14,
                            weight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          12.h,
                          if (sieges.isEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.color200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: AppColors.color400, size: 20),
                                  8.w,
                                  EText(
                                    "Aucune cellule configurée",
                                    color: AppColors.textColor.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sieges.map((element) => _buildSiegeChip(element)).toList(),
                            ),
                          12.h,
                          _buildAddSiegeButton(),
                        ],
                      ),
                    )),
                    20.h,
                    
                    // Section Types d'avis
                    _buildSectionHeader("Types d'avis acceptés", Icons.feedback_outlined),
                    16.h,
                    
                    Obx(() => Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.color200),
                      ),
                      child: Column(
                        children: [
                          EText(
                            "Sélectionnez les types d'avis que vous souhaitez recevoir",
                            size: 14,
                            color: AppColors.textColor.withOpacity(0.8),
                          ),
                          16.h,
                          ...["Suggestion", "Idée", "Plainte", "Appréciation"].map((element) => 
                            _buildCategoryCheckbox(element)
                          ).toList(),
                        ],
                      ),
                    )),
                    24.h,
                    
                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: SimpleOutlineButton(
                            onTap: () => Get.back(),
                            child: EText(
                              "Annuler",
                              color: AppColors.textColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        16.w,
                        Expanded(
                          flex: 2,
                          child: SimpleButton(
                            radius: 12,
                            onTap: _handleSave,
                            child: EText(
                              index != null ? "Modifier" : "Créer l'entreprise",
                              color: AppColors.white,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.color100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.color500, size: 20),
        ),
        12.w,
        EText(
          title,
          size: 18,
          weight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required String initialValue,
    required Function(String) onChanged,
    required IconData icon,
    int maxLines = 1,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EText(
          label,
          size: 14,
          weight: FontWeight.w600,
          color: AppColors.textColor,
        ),
        8.h,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.color200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ETextField(
            placeholder: placeholder,
            initialValue: initialValue,
            onChanged: onChanged,
            phoneScallerFactor: phoneScallerFactor,
            maxLines: maxLines,
          ),
        ),
        if (helperText != null) ...[
          8.h,
          EText(
            helperText,
            size: 12,
            color: AppColors.textColor.withOpacity(0.6),
          ),
        ],
      ],
    );
  }

  Widget _buildSiegeChip(String siege) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.color300),
        boxShadow: [
          BoxShadow(
            color: AppColors.color100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: EText(
              siege,
              color: AppColors.color500,
              weight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(TwoOptionsDialog(
                confirmFunction: () {
                  sieges.remove(siege);
                  Get.back();
                },
                body: "Voulez-vous vraiment supprimer cette cellule ?",
                confirmationText: "Supprimer",
                title: "Suppression",
              ));
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.color100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.close,
                color: AppColors.color500,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSiegeButton() {
    return GestureDetector(
      onTap: () {
        var siege = "";
        Custom.showDialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(24),
            child: EColumn(children: [
              Row(
                children: [
                  Icon(Icons.add_location_alt_outlined, color: AppColors.color500),
                  12.w,
                  EText(
                    "Ajouter une cellule",
                    size: 18,
                    weight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ],
              ),
              16.h,
              ETextField(
                placeholder: "Nom de la cellule",
                onChanged: (value) => siege = value,
                phoneScallerFactor: phoneScallerFactor,
              ),
              20.h,
              Row(
                children: [
                  Expanded(
                    child: SimpleOutlineButton(
                      onTap: () => Get.back(),
                      child: EText("Annuler", color: AppColors.textColor),
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: SimpleButton(
                      onTap: () {
                        if (siege.isEmpty) {
                          Toasts.error(Get.context!, description: "Veuillez saisir le nom de la cellule");
                          return;
                        }
                        sieges.add(siege);
                        Get.back();
                      },
                      child: EText("Ajouter", color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.color100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.color300, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.color500, size: 20),
            8.w,
            EText(
              "Ajouter une cellule",
              color: AppColors.color500,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCheckbox(String category) {
    final isSelected = selectedItems.contains(category);
    final categoryData = {
      "Suggestion": {
        "color": Color(0xFF007AFF), // Apple Blue
        "icon": Icons.lightbulb_outline,
        "description": "Proposer des améliorations"
      },
      "Idée": {
        "color": Color(0xFF5856D6), // Apple Purple
        "icon": Icons.psychology_outlined,
        "description": "Partager une nouvelle idée"
      },
      "Plainte": {
        "color": Color(0xFFFF3B30), // Apple Red
        "icon": Icons.report_problem_outlined,
        "description": "Signaler un problème"
      },
      "Appréciation": {
        "color": Color(0xFF34C759), // Apple Green
        "icon": Icons.favorite_outline,
        "description": "Exprimer sa satisfaction"
      },
    };
    
    final data = categoryData[category]!;
    final color = data["color"] as Color;
    final icon = data["icon"] as IconData;
    final description = data["description"] as String;
    
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          selectedItems.remove(category);
        } else {
          selectedItems.add(category);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Color(0xFFE5E5EA),
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Icône avec cercle de couleur
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              
              16.w,
              
              // Contenu textuel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EText(
                      category,
                      size: 17,
                      weight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                    4.h,
                    EText(
                      description,
                      size: 14,
                      color: AppColors.textColor.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
              
              // Indicateur de sélection
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Color(0xFFC7C7CC),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (nom.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez saisir le nom de l'entreprise");
      return;
    }
    if (id.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez saisir l'ID de l'entreprise");
      return;
    }
    if (selectedItems.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez sélectionner les types d'avis");
      return;
    }
    
    loading();

    var doc = DB.firestore(Collections.entreprises).doc(id);
    if ((await doc.get()).exists && index == null) {
      Get.back();
      Toasts.error(Get.context!, description: "ID déjà utilisé");
      return;
    }
    
    await doc.set(RealEntreprise(
      description: description,
      sieges: sieges,
      auteur: user.telephone.numero,
      nom: nom,
      id: id.toLowerCase(),
      categories: selectedItems,
    ).toMap());
    
    if (index == null) {
      user.entreprises.add(RealEntreprise(
        description: description,
        nom: nom,
        id: id,
        auteur: user.telephone.numero,
        categories: selectedItems,
        sieges: sieges,
      ));
    } else {
      user.entreprises[index] = RealEntreprise(
        description: description,
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
        message: index != null ? "L'entreprise a été modifiée avec succès" : "L'entreprise a été créée avec succès",
        duration: 2.seconds,
        backgroundColor: AppColors.color500,
        icon: Icon(Icons.check_circle, color: AppColors.white),
      ),
    );
  }
}
