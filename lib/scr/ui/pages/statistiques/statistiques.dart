import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:lottie/lottie.dart';
import 'package:my_widgets/real_state/models/message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistiques extends StatelessWidget {
  Statistiques({super.key});

  final List<List<FeedbackData>> allChartData = <List<FeedbackData>>[];

  final utilisateur = Utilisateur.currentUser.value!;
  
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLargeScreen = screenWidth > 1200;
    var isMediumScreen = screenWidth > 800 && screenWidth <= 1200;
    
    return EScaffold(
      color: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: EText(
          'Statistiques & Analyses',
          font: Fonts.poppinsBold,
          size: isLargeScreen ? 28 : 24,
          color: Colors.grey[900],
        ),
        centerTitle: false,
        toolbarHeight: isLargeScreen ? 80 : 65,
      ),
      body: utilisateur.entreprises.isEmpty 
        ? _buildEmptyState(isLargeScreen, isMediumScreen)
        : FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot)) {
                return _buildLoadingState(isLargeScreen);
              }
              return _buildStatisticsContent(isLargeScreen, isMediumScreen);
            },
          ),
    );
  }

  Widget _buildEmptyState(bool isLargeScreen, bool isMediumScreen) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isLargeScreen ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation Lottie
            Container(
              height: isLargeScreen ? 400 : Get.width * 0.6,
              width: isLargeScreen ? 400 : Get.width * 0.6,
              constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
              child: Lottie.asset(
                'assets/lotties/empty.json',
                fit: BoxFit.contain,
              ),
            ),
            
            (isLargeScreen ? 48 : 32).h,
            
            // Titre
            EText(
              "Aucune entreprise disponible",
              align: TextAlign.center,
              size: isLargeScreen ? 32 : 24,
              weight: FontWeight.w700,
              color: Colors.grey[900],
            ),
            
            (isLargeScreen ? 24 : 16).h,
            
            // Description
            EText(
              "Créez une entreprise pour commencer à analyser vos statistiques",
              align: TextAlign.center,
              size: isLargeScreen ? 20 : 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isLargeScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ECircularProgressIndicator(),
          (isLargeScreen ? 32 : 24).h,
          EText(
            "Chargement des statistiques...",
            size: isLargeScreen ? 20 : 16,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(bool isLargeScreen, bool isMediumScreen) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(isLargeScreen ? 32 : 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 1400 : double.infinity,
          ),
          child: Column(
            children: [
              (isLargeScreen ? 32 : 24).h,
              
              // Header avec métriques globales
              _buildGlobalMetrics(isLargeScreen, isMediumScreen),
              
              (isLargeScreen ? 40 : 32).h,
              
              // Graphiques par entreprise - Layout responsive
           
                _buildMobileCharts(),
              
              (isLargeScreen ? 60 : 40).h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalMetrics(bool isLargeScreen, bool isMediumScreen) {
    final totalFeedbacks = allChartData.fold(0, (sum, chartData) => sum + somme(chartData.map((e) => e.value).toList()));
    final totalEntreprises = utilisateur.entreprises.length;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLargeScreen ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: AppColors.color500,
                size: isLargeScreen ? 32 : 28,
              ),
              (isLargeScreen ? 16 : 12).w,
              EText(
                "Vue d'ensemble",
                size: isLargeScreen ? 28 : 24,
                weight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ],
          ),
          
          (isLargeScreen ? 32 : 24).h,
          
          // Métriques en grille responsive
          Row(
            children: [
              Expanded(child: _buildMetricCard("Entreprises", totalEntreprises.toString(), Icons.business, isLargeScreen)),
              (isLargeScreen ? 24 : 16).w,
              Expanded(child: _buildMetricCard("Retours totaux", totalFeedbacks.toString(), Icons.feedback, isLargeScreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(isLargeScreen ? 16 : 12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.color500,
            size: isLargeScreen ? 32 : 28,
          ),
          (isLargeScreen ? 16 : 12).h,
          EText(
            value,
            size: isLargeScreen ? 32 : 28,
            weight: FontWeight.w700,
            color: Colors.grey[900],
          ),
          (isLargeScreen ? 8 : 6).h,
          EText(
            title,
            size: isLargeScreen ? 16 : 14,
            color: Colors.grey[600],
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLargeScreenCharts(bool isLargeScreen) {
    return Column(
      children: [
        // Première ligne - 2 graphiques côte à côte
        if (allChartData.length >= 2)
          Row(
            children: [
              Expanded(child: _buildEnterpriseChart(allChartData[0], isLargeScreen)),
              32.w,
              Expanded(child: _buildEnterpriseChart(allChartData[1], isLargeScreen)),
            ],
          ),
        
        // Graphiques restants
        ...allChartData.skip(2).map((chartData) {
          return Column(
            children: [
              32.h,
              _buildEnterpriseChart(chartData, isLargeScreen),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMediumScreenCharts() {
    return Column(
      children: allChartData.map((chartData) {
        return Column(
          children: [
            _buildEnterpriseChart(chartData, false),
            if (allChartData.indexOf(chartData) < allChartData.length - 1)
              24.h,
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMobileCharts() {
    return Column(
      children: allChartData.map((chartData) {
        return Column(
          children: [
            _buildEnterpriseChart(chartData, false),
            if (allChartData.indexOf(chartData) < allChartData.length - 1)
              24.h,
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEnterpriseChart(List<FeedbackData> chartData, bool isLargeScreen) {
    final entrepriseIndex = allChartData.indexOf(chartData);
    final entreprise = Utilisateur.currentUser.value!.entreprises[entrepriseIndex];
    final totalFeedbacks = somme(chartData.map((e) => e.value).toList());
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLargeScreen ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de l'entreprise
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isLargeScreen ? 20 : 16),
                topRight: Radius.circular(isLargeScreen ? 20 : 16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 12 : 10),
                  decoration: BoxDecoration(
                    color: AppColors.color500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(isLargeScreen ? 12 : 10),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppColors.color500,
                    size: isLargeScreen ? 24 : 20,
                  ),
                ),
                
                (isLargeScreen ? 16 : 12).w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        entreprise.nom,
                        size: isLargeScreen ? 20 : 18,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      (isLargeScreen ? 6 : 4).h,
                      EText(
                        "$totalFeedbacks retours au total",
                        size: isLargeScreen ? 14 : 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 8 : 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(isLargeScreen ? 8 : 6),
                  ),
                  child: Icon(
                    Icons.pie_chart,
                    color: Colors.white,
                    size: isLargeScreen ? 18 : 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Graphique
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
            child: totalFeedbacks == 0
                ? _buildNoDataState(isLargeScreen)
                : _buildChart(chartData, isLargeScreen),
          ),
          
          // Légende des statistiques
          if (totalFeedbacks > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 24 : 20, vertical: isLargeScreen ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(isLargeScreen ? 20 : 16),
                  bottomRight: Radius.circular(isLargeScreen ? 20 : 16),
                ),
              ),
              child: _buildStatisticsLegend(chartData, isLargeScreen),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoDataState(bool isLargeScreen) {
    return Container(
      height: isLargeScreen ? 250 : 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: isLargeScreen ? 80 : 64,
            color: Colors.grey[400],
          ),
          (isLargeScreen ? 20 : 16).h,
          EText(
            "Aucun feedback pour le moment",
            size: isLargeScreen ? 20 : 18,
            weight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          (isLargeScreen ? 12 : 8).h,
          EText(
            "Les statistiques apparaîtront ici",
            size: isLargeScreen ? 16 : 14,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<FeedbackData> chartData, bool isLargeScreen) {
    return Container(
      height: isLargeScreen ? 400 : 350,
      child: SfCircularChart(
        title: ChartTitle(
          text: 'Répartition des feedbacks',
          textStyle: TextStyle(
            fontSize: isLargeScreen ? 20 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            fontSize: isLargeScreen ? 16 : 14,
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
                fontSize: isLargeScreen ? 14 : 12,
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

  Widget _buildStatisticsLegend(List<FeedbackData> chartData, bool isLargeScreen) {
    return Wrap(
      spacing: isLargeScreen ? 20 : 16,
      runSpacing: isLargeScreen ? 16 : 12,
      children: chartData.map((data) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 16 : 12, 
            vertical: isLargeScreen ? 12 : 8
          ),
          decoration: BoxDecoration(
            color: _getCategoryColor(data.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(isLargeScreen ? 24 : 20),
            border: Border.all(
              color: _getCategoryColor(data.category).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isLargeScreen ? 14 : 12,
                height: isLargeScreen ? 14 : 12,
                decoration: BoxDecoration(
                  color: _getCategoryColor(data.category),
                  shape: BoxShape.circle,
                ),
              ),
              (isLargeScreen ? 10 : 8).w,
              EText(
                "${data.category}: ${data.value}",
                size: isLargeScreen ? 16 : 14,
                weight: FontWeight.w600,
                color: _getCategoryColor(data.category),
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
