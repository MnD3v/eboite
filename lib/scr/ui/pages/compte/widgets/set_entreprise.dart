import 'dart:typed_data';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:image_picker/image_picker.dart';
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
      required this.user,
      this.notificationsSettings,
      this.existingLogoUrl});

  RxList<Siege> sieges;
  int? index;
  String nom;
  String description;
  final user;
  RxList<String> selectedItems;
  String id;
  NotificationSettings? notificationsSettings;
  String? existingLogoUrl;
  
  // Variables pour les notifications
  final RxBool notificationsEnabled = false.obs;
  final RxList<String> notificationEmails = <String>[].obs;
  
  // Variable pour l'image du logo (utilisation de Uint8List pour compatibilité web)
  final Rxn<Uint8List> logoBytes = Rxn<Uint8List>();
  @override
  Widget build(BuildContext context) {
    // Initialiser les valeurs si on est en mode modification
    if (index != null && notificationsSettings != null) {
      notificationsEnabled.value = notificationsSettings!.enabled;
      notificationEmails.value = List.from(notificationsSettings!.emails);
    }
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 700, maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
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
            // Header avec couleur FF2600
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFF2600),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.business,
                      color: Colors.white,
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
                          color: Colors.white,
                        ),
                        4.h,
                        EText(
                          "Configurez les informations de votre entreprise",
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
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

                    // Logo de l'entreprise
                    _buildSectionHeader("Logo de l'entreprise", Icons.image_outlined),
                    16.h,
                    
                    Obx(() => GestureDetector(
                      onTap: _pickLogo,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (logoBytes.value != null || existingLogoUrl != null)
                              ? Color(0xFFFF2600) 
                              : Colors.grey[300]!,
                            width: (logoBytes.value != null || existingLogoUrl != null) ? 2 : 1,
                          ),
                        ),
                        child: logoBytes.value == null && existingLogoUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF2600).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Color(0xFFFF2600),
                                    size: 40,
                                  ),
                                ),
                                16.h,
                                EText(
                                  "Cliquez pour ajouter un logo",
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                8.h,
                                EText(
                                  "Format recommandé: PNG ou JPG",
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: logoBytes.value != null
                                    ? Image.memory(
                                        logoBytes.value!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        existingLogoUrl!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            height: 150,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFFFF2600),
                                                strokeWidth: 2,
                                                value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / 
                                                    loadingProgress.expectedTotalBytes!
                                                  : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 150,
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.error_outline,
                                                  color: Colors.grey[400],
                                                  size: 40,
                                                ),
                                                8.h,
                                                EText(
                                                  "Erreur de chargement",
                                                  size: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                4.h,
                                                EText(
                                                  "Vérifiez la configuration CORS",
                                                  size: 10,
                                                  color: Colors.grey[500],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      logoBytes.value = null;
                                      existingLogoUrl = null;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Color(0xFFFF2600),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    )),
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
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EText(
                            "Cellules configurées (${sieges.length})",
                            size: 14,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          8.h,
                          // Message explicatif
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF2600).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color(0xFFFF2600).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xFFFF2600),
                                  size: 16,
                                ),
                                8.w,
                                Expanded(
                                  child: EText(
                                    "Lorsque votre entreprise a plusieurs départements ou déploie plusieurs programmes, vous pouvez tout départager ici.",
                                    size: 15,
                                    color: Colors.black.withOpacity(0.8),
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.h,
                          if (sieges.isEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Color(0xFFFF2600), size: 20),
                                  8.w,
                                  EText(
                                    "Aucune cellule configurée",
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sieges.map((element) => _buildCelluleChip(element)).toList(),
                            ),
                          12.h,
                          _buildAddCelluleButton(),
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
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          EText(
                            "Sélectionnez les types d'avis que vous souhaitez recevoir",
                            size: 14,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          16.h,
                          ...["Suggestion", "Idée", "Plainte", "Appréciation"].map((element) => 
                            _buildCategoryCheckbox(element)
                          ).toList(),
                        ],
                      ),
                    )),
                    24.h,
                    
                    // Section Notifications
                    _buildSectionHeader("Notifications par email", Icons.email_outlined),
                    16.h,
                    
                    Obx(() => Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Case à cocher pour activer les notifications
                          CheckboxListTile(
                            title: EText(
                              "Activer les notifications par email",
                              size: 16,
                              weight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            value: notificationsEnabled.value,
                            onChanged: (bool? value) {
                              notificationsEnabled.value = value ?? false;
                            },
                            activeColor: Color(0xFFFF2600),
                            contentPadding: EdgeInsets.zero,
                          ),
                          
                          // Liste des emails si activé
                          if (notificationsEnabled.value) ...[
                            16.h,
                            EText(
                              "Emails de notification",
                              size: 14,
                              weight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            12.h,
                            if (notificationEmails.isEmpty)
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Color(0xFFFF2600), size: 20),
                                    8.w,
                                    EText(
                                      "Aucun email configuré",
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: notificationEmails.map((email) => _buildEmailChip(email)).toList(),
                              ),
                            12.h,
                            _buildAddEmailButton(),
                          ],
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
                              color: Colors.black,
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
                              color: Colors.white,
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
            color: Color(0xFFFF2600).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFFF2600), size: 20),
        ),
        12.w,
        EText(
          title,
          size: 18,
          weight: FontWeight.w600,
          color: Colors.black,
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
          color: Colors.black,
        ),
        8.h,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
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
            color: Colors.grey[600],
          ),
        ],
      ],
    );
  }

  Widget _buildCelluleChip(Siege cellule) {
    return GestureDetector(
      onTap: () {
        _showEditCelluleDialog(cellule);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EText(
                    cellule.nom,
                    color: Color(0xFFFF2600),
                    weight: FontWeight.w500,
                  ),
                  if (cellule.emails.isNotEmpty) ...[
                    8.w,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF2600).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: EText(
                        "${cellule.emails.length} email${cellule.emails.length > 1 ? 's' : ''}",
                        color: Color(0xFFFF2600),
                        size: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(TwoOptionsDialog(
                  confirmFunction: () {
                    sieges.remove(cellule);
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
                  color: Color(0xFFFF2600),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCelluleButton() {
    return GestureDetector(
      onTap: () {
        _showAddCelluleDialog();
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
            Icon(Icons.add, color: Color(0xFFFF2600), size: 20),
            8.w,
            EText(
              "Ajouter une cellule",
              color: Color(0xFFFF2600),
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
        "color": Color(0xFFFF2600), // Rouge principal
        "icon": Icons.lightbulb_outline,
        "description": "Proposer des améliorations"
      },
      "Idée": {
        "color": Color(0xFFFF2600), // Rouge principal
        "icon": Icons.psychology_outlined,
        "description": "Partager une nouvelle idée"
      },
      "Plainte": {
        "color": Color(0xFFFF2600), // Rouge principal
        "icon": Icons.report_problem_outlined,
        "description": "Signaler un problème"
      },
      "Appréciation": {
        "color": Color(0xFFFF2600), // Rouge principal
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
          color: Colors.white,
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
                      color: Colors.black,
                    ),
                    4.h,
                    EText(
                      description,
                      size: 14,
                      color: Colors.black.withOpacity(0.6),
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
                        color: Colors.white,
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

  Widget _buildEmailChip(String email) {
    return Container(
      constraints: BoxConstraints(maxWidth: 600, ),
      decoration: BoxDecoration(
        color: Colors.white,
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
              email,
              color: Color(0xFFFF2600),
              weight: FontWeight.w500,
              size: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(TwoOptionsDialog(
                confirmFunction: () {
                  notificationEmails.remove(email);
                  Get.back();
                },
                body: "Voulez-vous vraiment supprimer cet email ?",
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
                color: Color(0xFFFF2600),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddEmailButton() {
    return GestureDetector(
      onTap: () {
        var email = "";
        Custom.showDialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: 600,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(24),
            child: EColumn(children: [
              Row(
                children: [
                  Icon(Icons.email_outlined, color: Color(0xFFFF2600)),
                  12.w,
                  EText(
                    "Ajouter un email",
                    size: 18,
                    weight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),
              16.h,
              ETextField(
                placeholder: "exemple@email.com",
                onChanged: (value) => email = value,
                phoneScallerFactor: phoneScallerFactor,
              ),
              20.h,
              Row(
                children: [
                  Expanded(
                    child: SimpleOutlineButton(
                      onTap: () => Get.back(),
                      child: EText("Annuler", color: Colors.black),
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: SimpleButton(
                      onTap: () {
                        if (email.isEmpty) {
                          Toasts.error(Get.context!, description: "Veuillez saisir une adresse email");
                          return;
                        }
                        if (!GFunctions.isEmail(email)) {
                          Toasts.error(Get.context!, description: "Veuillez saisir une adresse email valide");
                          return;
                        }
                        if (notificationEmails.contains(email)) {
                          Toasts.error(Get.context!, description: "Cette adresse email est déjà ajoutée");
                          return;
                        }
                        notificationEmails.add(email);
                        Get.back();
                      },
                      child: EText("Ajouter", color: Colors.white),
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
            Icon(Icons.add, color: Color(0xFFFF2600), size: 20),
            8.w,
            EText(
              "Ajouter un email",
              color: Color(0xFFFF2600),
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCelluleDialog() {
    String celluleNom = "";
    RxList<String> celluleEmails = <String>[].obs;
    
    Get.dialog(
      Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              EText(
                "Ajouter une cellule",
                size: 20,
                weight: FontWeight.w600,
              ),
              24.h,
              
              // Nom de la cellule
              EText("Nom de la cellule"),
              8.h,
              ETextField(
                placeholder: "Nom de la cellule",
                onChanged: (value) => celluleNom = value,
                phoneScallerFactor: phoneScallerFactor,
              ),
              
              24.h,
              
              // Section emails
              EText(
                "Emails de notification (optionnel)",
                size: 16,
                weight: FontWeight.w600,
              ),
              8.h,
              EText(
                "Vous pouvez configurer les emails maintenant ou plus tard",
                size: 12,
                color: Colors.grey[600],
              ),
              12.h,
              
              // Liste des emails
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: celluleEmails
                      .map(
                        (email) => GestureDetector(
                          onTap: () {
                            Get.dialog(TwoOptionsDialog(
                              confirmFunction: () {
                                celluleEmails.remove(email);
                                Get.back();
                              },
                              body: "Voulez-vous vraiment supprimer cet email ?",
                              confirmationText: "Supprimer",
                              title: "Suppression"
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                EText(
                                  email,
                                  color: Color(0xFFFF2600),
                                  size: 14,
                                ),
                                4.w,
                                Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFFFF2600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              
              12.h,
              
              // Bouton d'ajout d'email
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  var email = "";
                  Custom.showDialog(Dialog(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: EColumn(children: [
                          EText("Adresse email"),
                        ETextField(
                          placeholder: "exemple@email.com",
                          onChanged: (value) {
                            email = value;
                          },
                          phoneScallerFactor: phoneScallerFactor,
                        ),
                        12.h,
                        SimpleButton(
                          onTap: () {
                            if (email.isEmpty) {
                              Toasts.error(Get.context!,
                                  description: "Veuillez saisir une adresse email");
                              return;
                            }
                            if (!GFunctions.isEmail(email)) {
                              Toasts.error(Get.context!,
                                  description: "Veuillez saisir une adresse email valide");
                              return;
                            }
                            if (celluleEmails.contains(email)) {
                              Toasts.error(Get.context!,
                                  description: "Cette adresse email est déjà ajoutée");
                              return;
                            }
                            celluleEmails.add(email);
                            Get.back();
                          },
                          text: "Ajouter",
                        )
                      ]),
                    ),
                  ),
                  ));
                },
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
              
              24.h,
              
              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: SimpleOutlineButton(
                      onTap: () {
                        Get.back();
                      },
                      text: "Annuler",
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: SimpleButton(
                      onTap: () {
                        if (celluleNom.isEmpty) {
                          Toasts.error(Get.context!,
                              description: "Veuillez saisir le nom de la cellule");
                          return;
                        }
                        
                        // Créer la nouvelle cellule
                        sieges.add(Siege(
                          nom: celluleNom,
                          emails: celluleEmails.toList(),
                        ));
                        Get.back();
                      },
                      text: "Créer la cellule",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _showEditCelluleDialog(Siege cellule) {
    String celluleNom = cellule.nom;
    RxList<String> celluleEmails = cellule.emails.obs;
    
    Get.dialog(
      Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              EText(
                "Modifier la cellule",
                size: 20,
                weight: FontWeight.w600,
              ),
              24.h,
              
              // Nom de la cellule
              EText("Nom de la cellule"),
              8.h,
              ETextField(
                placeholder: "Nom de la cellule",
                initialValue: celluleNom,
                onChanged: (value) => celluleNom = value,
                phoneScallerFactor: phoneScallerFactor,
              ),
              
              24.h,
              
              // Section emails
              EText(
                "Emails de notification",
                size: 16,
                weight: FontWeight.w600,
              ),
              12.h,
              
              // Liste des emails
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: celluleEmails
                      .map(
                        (email) => GestureDetector(
                          onTap: () {
                            Get.dialog(TwoOptionsDialog(
                              confirmFunction: () {
                                celluleEmails.remove(email);
                                Get.back();
                              },
                              body: "Voulez-vous vraiment supprimer cet email ?",
                              confirmationText: "Supprimer",
                              title: "Suppression"
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                EText(
                                  email,
                                  color: Color(0xFFFF2600),
                                  size: 14,
                                ),
                                4.w,
                                Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFFFF2600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              
              12.h,
              
              // Bouton d'ajout d'email
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  var email = "";
                  Custom.showDialog(Dialog(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: EColumn(children: [
                          EText("Adresse email"),
                        ETextField(
                          placeholder: "exemple@email.com",
                          onChanged: (value) {
                            email = value;
                          },
                          phoneScallerFactor: phoneScallerFactor,
                        ),
                        12.h,
                        SimpleButton(
                          onTap: () {
                            if (email.isEmpty) {
                              Toasts.error(Get.context!,
                                  description: "Veuillez saisir une adresse email");
                              return;
                            }
                            if (!GFunctions.isEmail(email)) {
                              Toasts.error(Get.context!,
                                  description: "Veuillez saisir une adresse email valide");
                              return;
                            }
                            if (celluleEmails.contains(email)) {
                              Toasts.error(Get.context!,
                                  description: "Cette adresse email est déjà ajoutée");
                              return;
                            }
                            celluleEmails.add(email);
                            Get.back();
                          },
                          text: "Ajouter",
                        )
                      ]),
                    ),
                  ),
                  ));
                },
                child: Icon(Icons.add, color: Color(0xFFFF2600), size: 20),
              ),
              
              24.h,
              
              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: SimpleOutlineButton(
                      onTap: () {
                        Get.back();
                      },
                      text: "Annuler",
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: SimpleButton(
                      onTap: () {
                        if (celluleNom.isEmpty) {
                          Toasts.error(Get.context!,
                              description: "Veuillez saisir le nom de la cellule");
                          return;
                        }
                        
                        // Mettre à jour la cellule
                        int index = sieges.indexOf(cellule);
                        if (index != -1) {
                          sieges[index] = Siege(
                            nom: celluleNom,
                            emails: celluleEmails.toList(),
                          );
                        }
                        Get.back();
                      },
                      text: "Sauvegarder",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Future<void> _pickLogo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Lire les bytes de manière asynchrone (compatible web et mobile)
        final bytes = await image.readAsBytes();
        logoBytes.value = bytes;
      }
    } catch (e) {
      Toasts.error(Get.context!, description: "Erreur lors de la sélection de l'image");
    }
  }

  Future<String?> _uploadLogo() async {
    if (logoBytes.value == null) return null;
    
    try {
      // Upload via FStorage.putData (compatible web et mobile)
      final logoUrl = await FStorage.putData(logoBytes.value!);
      return logoUrl;
    } catch (e) {
      print('Erreur lors de l\'upload du logo: $e');
      return null;
    }
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
    
    // Validation des notifications si activées
    if (notificationsEnabled.value && notificationEmails.isEmpty) {
      Toasts.error(Get.context!, description: "Veuillez ajouter au moins un email de notification");
      return;
    }
    
    loading();

    var doc = DB.firestore(Collections.entreprises).doc(id);
    if ((await doc.get()).exists && index == null) {
      Get.back();
      Toasts.error(Get.context!, description: "ID déjà utilisé");
      return;
    }
    
    // Upload du logo vers Firebase Storage si un fichier a été sélectionné
    String? logoUrl = existingLogoUrl; // Conserver le logo existant par défaut
    if (logoBytes.value != null) {
      logoUrl = await _uploadLogo();
      if (logoUrl == null) {
        Get.back();
        Toasts.error(Get.context!, description: "Erreur lors de l'upload du logo");
        return;
      }
    }
    
    // Créer les paramètres de notification
    NotificationSettings? notificationSettings;
    if (notificationsEnabled.value) {
      notificationSettings = NotificationSettings(
        enabled: true,
        emails: List.from(notificationEmails),
      );
    }
    
    await doc.set(RealEntreprise(
      description: description,
      sieges: sieges.toList(),
      auteur: user.telephone.numero,
      nom: nom,
      id: id.toLowerCase(),
      logo: logoUrl,
      categories: selectedItems,
      notificationsSettings: notificationSettings,
    ).toMap());
    
    if (index == null) {
      user.entreprises.add(RealEntreprise(
        description: description,
        nom: nom,
        id: id,
        auteur: user.telephone.numero,
        logo: logoUrl,
        categories: selectedItems,
        sieges: sieges.toList(),
        notificationsSettings: notificationSettings,
      ));
    } else {
      user.entreprises[index] = RealEntreprise(
        description: description,
        nom: nom,
        id: id,
        auteur: user.telephone.numero,
        logo: logoUrl,
        categories: selectedItems,
        sieges: sieges.toList(),
        notificationsSettings: notificationSettings,
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
        backgroundColor: Color(0xFFFF2600),
        icon: Icon(Icons.check_circle, color: Colors.white),
      ),
    );
  }
}
