import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
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
  var messages = (<Message>[]).obs;

  var inView = false.obs;

  var categories = <String>[].obs;
  var sieges = <Siege>[].obs;
  
  // Variables pour le filtrage par date
  var dateDebut = Rxn<DateTime>();
  var dateFin = Rxn<DateTime>();

  var tousLesCategories = ["Suggestion", "Plainte", "Idée", "Appréciation"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      waitAfter(333, () {
        inView.value = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DB
          .firestore(Collections.entreprises)
          .doc(widget.currentEntreprise.id)
          .collection(Collections.messages)
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<Message> tempMessages = [];
        if (snapshot.hasData) {
          for (var element in snapshot.data!.docs) {
            var msg = Message.fromMap(element.data());
            msg.id = element.id;
            if(msg.siege != null && widget.currentEntreprise.sieges.any((siege) => siege.nom == msg.siege)) {
              tempMessages.add(msg);
            }
          }
        }

        messages.value = tempMessages;
        categories.value = [...tousLesCategories];
        sieges.value = [...widget.currentEntreprise.sieges];

        if (snapshot.connectionState == ConnectionState.done) {
          print(messages.length);
        }

        return LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount =
              (width / 400).toInt() <= 0 ? 1 : (width / 400).toInt();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: ECircularProgressIndicator(),
                  )
                : Obx(
                    () => messages.isEmpty
                        ? SizedBox(
                            key: Key("empty"),
                            height: Get.height * 0.8,
                            child: Center(
                              child: EColumn(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Animation Lottie
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 400,
                                      maxWidth: 400,
                                    ),
                                    child: SizedBox(
                                      height: Get.width * 0.6,
                                      width: Get.width * 0.6,
                                      child: Lottie.asset(
                                        'assets/lotties/messages.json',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                  32.h,

                                  // Titre principal
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    child: EText(
                                      "Aucun message pour l'instant",
                                      align: TextAlign.center,
                                      size: 24,
                                      weight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),

                                  16.h,

                                  // Description
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    child: EText(
                                      "Les messages de vos clients apparaîtront ici. Soyez patient, ils arrivent bientôt !",
                                      align: TextAlign.center,
                                      size: 16,
                                      weight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  40.h,
                                ],
                              ),
                            ),
                          )
                        : DynamicHeightGridView(
                            physics: BouncingScrollPhysics(),
                            key: Key(messages.length.toString()),
                            itemCount: messages.length,
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            builder: (ctx, index) {
                              var element = messages[index];

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
                                        (index != 0 &&
                                                    messages[index]
                                                            .date
                                                            .split(" ")[0] ==
                                                        messages[index - 1]
                                                            .date
                                                            .split(" ")[0]) ||
                                                crossAxisCount > 1
                                            ? 0.h
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    top: index == 0 ? 9 : 0),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: const Color.fromARGB(
                                                        255, 224, 224, 224)),
                                                child: EText(
                                                  theDate(element),
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
                            }),

                    // ListView.builder(
                    //     key: Key(messages.length.toString()),
                    //     physics: BouncingScrollPhysics(),
                    //     itemCount: messages.length,
                    //     itemBuilder: (context, index) {
                    //       var element = messages[index];

                    //       return Obx(
                    //         () => AnimatedOpacity(
                    //           duration: (333 * index + 333).milliseconds,
                    //           opacity: inView.value ? 1 : 0,
                    //           child: AnimatedPadding(
                    //             duration: (333 * index + 333).milliseconds,
                    //             padding: EdgeInsets.only(
                    //                 top: inView.value ? 0 : 20),
                    //             child: Column(
                    //               children: [
                    //                 (index != 0 &&
                    //                         messages[index]
                    //                                 .date
                    //                                 .split(" ")[0] ==
                    //                             messages[index - 1]
                    //                                 .date
                    //                                 .split(" ")[0])
                    //                     ? 0.h
                    //                     : Container(
                    //                         margin: EdgeInsets.only(
                    //                             top: index == 0 ? 9 : 0),
                    //                         padding: EdgeInsets.symmetric(
                    //                             horizontal: 6),
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(3),
                    //                             color: const Color.fromARGB(
                    //                                 255, 224, 224, 224)),
                    //                         child: EText(
                    //                           theDate(element),
                    //                           size: 16,
                    //                           color: const Color.fromARGB(
                    //                               255, 43, 43, 43),
                    //                         ),
                    //                       ),
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     Custom.showDialog(MessageDetails(
                    //                       message: element,
                    //                       entrepriseID:
                    //                           widget.currentEntreprise.id,
                    //                     ));
                    //                   },
                    //                   child: MessageCard(element: element, entrepriseID: widget.currentEntreprise.id,),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                filtrer(tempMessages);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(Assets.icons("filtrer.png"), height: 25),
              ),
            ),
          );
        });
      },
    );
  }

  Future<dynamic> filtrer(tempMessages) {
    return Get.bottomSheet(
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(9),
          child: Obx(
            () => EColumn(children: [
              // Section Filtrage par date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.h,
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: EText(
                      "Période",
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                  ),
                  
                  // Sélection date de début
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EText(
                                "Date de début",
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                              8.h,
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: dateDebut.value ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    dateDebut.value = date;
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                                      8.w,
                                      EText(
                                        dateDebut.value != null 
                                          ? "${dateDebut.value!.day}/${dateDebut.value!.month}/${dateDebut.value!.year}"
                                          : "Sélectionner",
                                        color: dateDebut.value != null ? Colors.black : Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        16.w,
                        
                        // Sélection date de fin
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EText(
                                "Date de fin",
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                              8.h,
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: dateFin.value ?? DateTime.now(),
                                    firstDate: dateDebut.value ?? DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    dateFin.value = date;
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                                      8.w,
                                      EText(
                                        dateFin.value != null 
                                          ? "${dateFin.value!.day}/${dateFin.value!.month}/${dateFin.value!.year}"
                                          : "Sélectionner",
                                        color: dateFin.value != null ? Colors.black : Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bouton pour effacer les dates
                  if (dateDebut.value != null || dateFin.value != null) ...[
                    12.h,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          dateDebut.value = null;
                          dateFin.value = null;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.clear, size: 16, color: Colors.red[600]),
                              4.w,
                              EText(
                                "Effacer les dates",
                                size: 14,
                                color: Colors.red[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              widget.currentEntreprise.sieges.length < 2
                  ? 0.h
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.h,
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: EText(
                            "Cellules",
                            size: 28,
                            weight: FontWeight.bold,
                          ),
                        ),
                        ...widget.currentEntreprise.sieges.map((element) {
                          return CheckboxListTile(
                            value: sieges.any((siege) => siege.nom == element.nom),
                            onChanged: (value) {
                              if (!sieges.any((siege) => siege.nom == element.nom)) {
                                sieges.add(element);
                              } else {
                                sieges.removeWhere((siege) => siege.nom == element.nom);
                              }
                            },
                            title: EText(element.nom),
                          );
                        }),
                      ],
                    ),
              12.h,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: EText(
                  "Categories",
                  size: 28,
                  weight: FontWeight.bold,
                ),
              ),
              ...tousLesCategories.map((element) {
                return CheckboxListTile(
                  value: categories.contains(element),
                  onChanged: (value) {
                    if (!categories.contains(element)) {
                      categories.add(element);
                    } else {
                      categories.remove(element);
                    }
                  },
                  title: EText(element),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleButton(
                  radius: 12,
                  onTap: () {
                    Get.back();
                    waitAfter(333, () {
                      messages.value = tempMessages
                          .where((element) =>
                              categories.contains(element.categorie))
                          .toList();

                      if (widget.currentEntreprise.sieges.length > 2) {
                        messages.value = messages
                            .where((element) => sieges.any((siege) => siege.nom == element.siege))
                            .toList();
                      }
                      
                      // Filtrage par date
                      if (dateDebut.value != null || dateFin.value != null) {
                        messages.value = messages.where((element) {
                          try {
                            // Parser la date du message (format attendu: "dd/MM/yyyy" ou "yyyy-MM-dd")
                            DateTime messageDate;
                            if (element.date.contains('/')) {
                              // Format dd/MM/yyyy
                              List<String> parts = element.date.split('/');
                              messageDate = DateTime(
                                int.parse(parts[2]), // année
                                int.parse(parts[1]), // mois
                                int.parse(parts[0]), // jour
                              );
                            } else {
                              // Format yyyy-MM-dd ou autre format ISO
                              messageDate = DateTime.parse(element.date);
                            }
                            
                            bool isAfterStart = dateDebut.value == null || 
                                messageDate.isAfter(dateDebut.value!) || 
                                messageDate.isAtSameMomentAs(dateDebut.value!);
                            
                            bool isBeforeEnd = dateFin.value == null || 
                                messageDate.isBefore(dateFin.value!.add(Duration(days: 1))) || 
                                messageDate.isAtSameMomentAs(dateFin.value!);
                            
                            return isAfterStart && isBeforeEnd;
                          } catch (e) {
                            // Si la date ne peut pas être parsée, inclure le message
                            return true;
                          }
                        }).toList();
                      }
                    });
                  },
                  text: "Continuer",
                ),
              ),
            ]),
          ),
        ),
        isScrollControlled: true);
  }

  String theDate(Message element) {
    return GFunctions.isToday(element.date.split(" ")[0])
        ? "Aujourd'hui"
        : GFunctions.isYesterday(element.date.split(" ")[0])
            ? "Hier"
            : element.date.split(" ")[0].split("-").reversed.join("-");
  }
}

Map<String, Color> categorieColors = {
  "suggestion": Colors.green,
  "plainte": Colors.red,
  "idée": Color(0xff4cc9f0),
  "appréciation": Colors.teal
};
