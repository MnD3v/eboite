import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/ai/ai_resume.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/widgets/message_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/real_state/models/entreprise.dart';
import 'package:my_widgets/real_state/models/message.dart';

class Messages extends StatefulWidget {
  Messages({super.key, required this.currentEntreprise});
  final RealEntreprise currentEntreprise;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // Filters
  var selectedCategory = "Tout".obs;
  var searchQuery = "".obs;
  final TextEditingController searchController = TextEditingController();

  // Advanced Filters
  var sieges = <Siege>[].obs;
  var dateDebut = Rxn<DateTime>();
  var dateFin = Rxn<DateTime>();

  // Animation
  var inView = true.obs;

  // Enterprise Management
  late Rx<RealEntreprise> _currentEntreprise;

  final List<String> categories = [
    "Tout",
    "Suggestion",
    "Plainte",
    "Idée",
    "Appréciation"
  ];

  @override
  void initState() {
    super.initState();
    _currentEntreprise = widget.currentEntreprise.obs;
    // Initialize sieges with all sieges of current enterprise
    sieges.value = [..._currentEntreprise.value.sieges];

    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FA), // Light grey background for modern look
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: EText("Messages",
            size: 24, weight: FontWeight.bold, color: Colors.black),
        centerTitle: false,
        actions: [
          Obx(() => IconButton(
                onPressed: () => _showAdvancedFilters(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (dateDebut.value != null || dateFin.value != null)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.tune_rounded,
                      color: (dateDebut.value != null || dateFin.value != null)
                          ? Colors.blue
                          : Colors.black87,
                      size: 20),
                ),
              )),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search and Category Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                // Search Bar and Enterprise Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildEnterpriseSelector(),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Rechercher...",
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: categories.map((category) {
                      return Obx(() {
                        final isSelected = selectedCategory.value == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              selectedCategory.value = category;
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2))
                                      ]
                                    : null,
                              ),
                              child: EText(
                                category,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                weight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                size: 14,
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: Obx(() => StreamBuilder(
                  stream: DB
                      .firestore(Collections.entreprises)
                      .doc(_currentEntreprise.value.id)
                      .collection(Collections.messages)
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.black, size: 40));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Process data
                    List<Message> allMessages = [];
                    for (var element in snapshot.data!.docs) {
                      var msg = Message.fromMap(element.data());
                      msg.id = element.id;
                      if(_currentEntreprise.value.sieges.isEmpty){
                        allMessages.add(msg);
                      }
                      if (msg.siege != null &&
                          _currentEntreprise.value.sieges
                              .any((siege) => siege.nom == msg.siege)) {
                        allMessages.add(msg);
                      }
                    }

                    // Apply Filters
                    return Obx(() {
                      print(allMessages.length);
                      var displayMessages = allMessages.where((msg) {
                        // Category Filter
                        if (selectedCategory.value != "Tout" &&
                            msg.categorie.toLowerCase() !=
                                selectedCategory.value.toLowerCase()) {
                          return false;
                        }

                        // Search Filter
                        if (searchQuery.value.isNotEmpty) {
                          final query = searchQuery.value.toLowerCase();
                          if (!msg.message.toLowerCase().contains(query) &&
                              !msg.categorie.toLowerCase().contains(query)) {
                            return false;
                          }
                        }

                        // Date Filter
                        if (dateDebut.value != null || dateFin.value != null) {
                          try {
                            DateTime messageDate;
                            if (msg.date.contains('/')) {
                              List<String> parts = msg.date.split('/');
                              messageDate = DateTime(int.parse(parts[2]),
                                  int.parse(parts[1]), int.parse(parts[0]));
                            } else {
                              messageDate = DateTime.parse(msg.date);
                            }

                            if (dateDebut.value != null) {
                              final start = DateTime(dateDebut.value!.year,
                                  dateDebut.value!.month, dateDebut.value!.day);
                              if (messageDate.isBefore(start)) return false;
                            }
                            if (dateFin.value != null) {
                              final end = DateTime(
                                  dateFin.value!.year,
                                  dateFin.value!.month,
                                  dateFin.value!.day,
                                  23,
                                  59,
                                  59);
                              if (messageDate.isAfter(end)) return false;
                            }
                          } catch (e) {
                            return true; // Keep if date parse fails
                          }
                        }

                        // Siege Filter
                        if (_currentEntreprise.value.sieges.length > 1) {
                          if (!sieges.any((s) => s.nom == msg.siege))
                            return false;
                        }

                        return true;
                      }).toList();

                      if (displayMessages.isEmpty) {
                        return _buildEmptyState(isFiltered: true.obs.value);
                      }

                      return LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 1200
                            ? 4
                            : constraints.maxWidth > 800
                                ? 3
                                : constraints.maxWidth > 600
                                    ? 2
                                    : 1;
                        return DynamicHeightGridView(
                            physics: const BouncingScrollPhysics(),
                            key: Key(displayMessages.length.toString()),
                            itemCount: displayMessages.length,
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            builder: (ctx, index) {
                              var element = displayMessages[index];
                              bool showHeader = index == 0 ||
                                  displayMessages[index].date.split(" ")[0] !=
                                      displayMessages[index - 1]
                                          .date
                                          .split(" ")[0];

                              return Obx(
                                () => AnimatedOpacity(
                                  duration: (333 * index + 333).milliseconds,
                                  opacity: inView.value ? 1 : 0,
                                  child: AnimatedPadding(
                                    duration: (333 * index + 333).milliseconds,
                                    padding: EdgeInsets.only(
                                        top: inView.value ? 0 : 20),
                                    child: Column(
                                      children: [
                                        if (showHeader)
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: index == 0 ? 9 : 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: const Color.fromARGB(
                                                    255, 224, 224, 224)),
                                            child: EText(
                                              _formatDateHeader(element),
                                              size: 16,
                                              color: const Color.fromARGB(
                                                  255, 43, 43, 43),
                                            ),
                                          ),
                                        GestureDetector(
                                          onTap: () {
                                            Custom.showDialog(MessageDetails(
                                              message: element,
                                              entrepriseID:
                                                  widget.currentEntreprise.id,
                                            ));
                                          },
                                          child: MessageCard(
                                            element: element,
                                            entrepriseID:
                                                widget.currentEntreprise.id,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      });
                    });
                  },
                )),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AiResume(entreprise: _currentEntreprise.value));
        },
        child: Image.asset(
          Assets.icons("ai.png"),
          color: Colors.white,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildEnterpriseSelector() {
    return Obx(() {
      final user = Utilisateur.currentUser.value;
      if (user == null || user.entreprises.length <= 1)
        return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(right: 12),
        child: PopupMenuButton<RealEntreprise>(
          offset: const Offset(0, 45),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business_rounded,
                    size: 20, color: Colors.black87),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: EText(
                    _currentEntreprise.value.nom,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: Colors.black54),
              ],
            ),
          ),
          onSelected: (RealEntreprise value) {
            _currentEntreprise.value = value;
            sieges.value = [...value.sieges];
          },
          itemBuilder: (BuildContext context) {
            return user.entreprises.map((RealEntreprise choice) {
              final isSelected = choice.id == _currentEntreprise.value.id;
              return PopupMenuItem<RealEntreprise>(
                value: choice,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.color500.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.business_rounded,
                          size: 18,
                          color: isSelected
                              ? AppColors.color500
                              : Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        choice.nom,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_rounded,
                          color: AppColors.color500, size: 18),
                  ],
                ),
              );
            }).toList();
          },
        ),
      );
    });
  }

  Widget _buildDateHeader(Message element) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(indent: 16, endIndent: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: EText(
              _formatDateHeader(element),
              size: 12,
              weight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const Expanded(child: Divider(indent: 16, endIndent: 16)),
        ],
      ),
    );
  }

  String _formatDateHeader(Message element) {
    try {
      final datePart = element.date.split(" ")[0];
      if (GFunctions.isToday(datePart)) return "Aujourd'hui";
      if (GFunctions.isYesterday(datePart)) return "Hier";
      return datePart.split("-").reversed.join("/");
    } catch (e) {
      return element.date;
    }
  }

  Widget _buildEmptyState({bool isFiltered = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/messages.json',
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          EText(
            isFiltered ? "Aucun résultat trouvé" : "Aucun message",
            size: 20,
            weight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 8),
          EText(
            isFiltered
                ? "Essayez de modifier vos filtres"
                : "Vos messages apparaîtront ici",
            size: 14,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilters() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              EText("Filtres avancés", size: 24, weight: FontWeight.bold),
              const SizedBox(height: 24),

              // Date Range
              EText("Période", size: 16, weight: FontWeight.w600),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector("Du", dateDebut.value,
                        (date) => dateDebut.value = date),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateSelector(
                        "Au", dateFin.value, (date) => dateFin.value = date),
                  ),
                ],
              ),

              if (dateDebut.value != null || dateFin.value != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      dateDebut.value = null;
                      dateFin.value = null;
                    },
                    icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                    label:
                        EText("Effacer les dates", color: Colors.red, size: 14),
                  ),
                ),
              ],

              // Sieges
              if (_currentEntreprise.value.sieges.length > 1) ...[
                const SizedBox(height: 24),
                EText("Cellules", size: 16, weight: FontWeight.w600),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _currentEntreprise.value.sieges.map((siege) {
                    final isSelected = sieges.any((s) => s.nom == siege.nom);
                    return FilterChip(
                      label: Text(siege.nom),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          sieges.add(siege);
                        } else {
                          sieges.removeWhere((s) => s.nom == siege.nom);
                        }
                      },
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: SimpleButton(
                  text: "Appliquer",
                  onTap: () => Get.back(),
                  radius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDateSelector(
      String label, DateTime? date, Function(DateTime) onSelect) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : "Sélectionner",
                  style: TextStyle(
                    color: date != null ? Colors.black : Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
