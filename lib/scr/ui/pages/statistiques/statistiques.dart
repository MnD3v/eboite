import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/real_state/models/message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistiques extends StatelessWidget {
  Statistiques({super.key});

  var allChartData = <List<FeedbackData>>[];

  final utilisateur = Utilisateur.currentUser.value!;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: EScaffold(
        color: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Statistiques & Analyses',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
        body: utilisateur.entreprises.isEmpty 
          ? _buildEmptyState()
          : FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return _buildLoadingState();
                }
                return _buildStatisticsContent();
              },
            ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation Lottie
            Container(
              height: Get.width * 0.6,
              width: Get.width * 0.6,
              child: Lottie.asset(
                'assets/lotties/empty.json',
                fit: BoxFit.contain,
              ),
            ),
            
            32.h,
            
            // Titre
            Text(
              "Aucune entreprise disponible",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            
            16.h,
            
            // Description
            Text(
              "Créez une entreprise pour commencer à analyser vos statistiques",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.threeRotatingDots(
            color: AppColors.color500,
            size: 50,
          ),
          24.h,
          Text(
            "Chargement des statistiques...",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          24.h,
          
          // Titre principal
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.color500.withOpacity(0.9),
                  AppColors.color500.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.color500.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                16.h,
                Text(
                  "Vue d'ensemble de vos entreprises",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                8.h,
                Text(
                  "Analysez les retours de vos clients",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          32.h,
          
          // Graphiques par entreprise
          ...allChartData.map((chartData) {
            return _buildEnterpriseChart(chartData);
          }).toList(),
          
          40.h,
        ],
      ),
    );
  }

  Widget _buildEnterpriseChart(List<FeedbackData> chartData) {
    final entrepriseIndex = allChartData.indexOf(chartData);
    final entreprise = Utilisateur.currentUser.value!.entreprises[entrepriseIndex];
    final totalFeedbacks = somme(chartData.map((e) => e.value).toList());
    
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de l'entreprise
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.color500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppColors.color500,
                    size: 24,
                  ),
                ),
                
                16.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entreprise.nom,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      8.h,
                      Text(
                        "$totalFeedbacks retours au total",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.pie_chart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Graphique
          Container(
            padding: EdgeInsets.all(24),
            child: totalFeedbacks == 0
                ? _buildNoDataState()
                : _buildChart(chartData),
          ),
          
          // Légende des statistiques
          if (totalFeedbacks > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: _buildStatisticsLegend(chartData),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          16.h,
          Text(
            "Aucun feedback pour le moment",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          8.h,
          Text(
            "Les statistiques apparaîtront ici",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<FeedbackData> chartData) {
    return Container(
      height: 350,
      child: SfCircularChart(
        title: ChartTitle(
          text: 'Répartition des feedbacks',
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        series: <CircularSeries>[
          PieSeries<FeedbackData, String>(
            dataSource: chartData,
            xValueMapper: (FeedbackData data, _) => data.category,
            yValueMapper: (FeedbackData data, _) => data.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
                length: '15%',
                width: 2,
              ),
            ),
            enableTooltip: true,
            explode: true,
            explodeIndex: 1,
            pointColorMapper: (FeedbackData data, _) => _getCategoryColor(data.category),
          )
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y',
        ),
      ),
    );
  }

  Widget _buildStatisticsLegend(List<FeedbackData> chartData) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: chartData.map((data) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getCategoryColor(data.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getCategoryColor(data.category).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getCategoryColor(data.category),
                  shape: BoxShape.circle,
                ),
              ),
              8.w,
              Text(
                "${data.category}: ${data.value}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getCategoryColor(data.category),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "suggestion":
        return Colors.green;
      case "plainte":
        return Colors.red;
      case "idée":
        return Color(0xff4cc9f0);
      case "appréciation":
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  getData() async {
    allChartData.clear();
    var entreprises = Utilisateur.currentUser.value!.entreprises
        .map((toElement) => toElement.id)
        .toList();

    for (var element in entreprises) {
      var q = await DB
          .firestore(Collections.entreprises)
          .doc(element)
          .collection(Collections.messages)
          .get();
      var data = {
        "Suggestion": 0,
        "Plainte": 0,
        "Idée": 0,
        "Appréciation": 0,
      };
      for (var e in q.docs) {
        var msg = Message.fromMap(e.data());
        data[msg.categorie] = data[msg.categorie]! + 1;
      }

      var chartData = data.keys.map((element) {
        return FeedbackData(element, data[element]!);
      }).toList();

      allChartData.add(chartData);
    }
  }
}

class FeedbackData {
  FeedbackData(this.category, this.value);
  final String category;
  final int value;
}

int somme(List<int> nombres) {
  int somme = 0;
  for (int nombre in nombres) {
    somme += nombre;
  }
  return somme;
}
