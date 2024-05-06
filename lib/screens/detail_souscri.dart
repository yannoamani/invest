import 'package:invest_mobile/providers/messous_provider.dart';
import 'package:flutter/material.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class DetailsSouscription extends StatefulWidget {
  const DetailsSouscription({super.key});

  @override
  State<DetailsSouscription> createState() => _DetailsSouscriptionState();
}

class _DetailsSouscriptionState extends State<DetailsSouscription> {
  int touchedIndex = -1;
  bool _tooglerecap = false;
  List<Color> colors = [
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Details souscription",
            style: customFonts(20, Colors.black, FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<MesSousProvider>(
        builder: (context, value, child) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(h * 0.01),
                    child: Stack(
                      // overflow: Overflow.visible,
                      children: [
                        // CARTE RESUME DE LA SOUSCRIPTION
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(h * 0.01))),
                          child: Container(
                            padding: EdgeInsets.all(h * 0.01),
                            height: h / 2.65,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(h * 0.01))),
                            child: Column(
                              children: [
                                Text(value.libelle,
                                    style: customFonts(
                                        22, Colors.black, FontWeight.bold)),
                                SizedBox(height: h * 0.02),
                                // COUT DU PACKAGE
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Cout du package",
                                          style: customFonts(16, Colors.grey,
                                              FontWeight.bold)),
                                      Text("${value.coutpackage} cfa",
                                          style: customFonts(
                                              25, Colors.grey, FontWeight.bold))
                                    ]),
                                SizedBox(height: h * 0.01),
                                // DATE D'ECOULEMENT
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date écoulement",
                                          style: customFonts(16, Colors.grey,
                                              FontWeight.bold)),
                                      Text(value.ecoulement.substring(0, 10),
                                          style: customFonts(
                                              16, Colors.grey, FontWeight.bold))
                                    ]),
                                SizedBox(height: h * 0.02),
                                // PROGRESSION
                                Stack(
                                  children: [
                                    SizedBox(
                                        width: w * 0.9,
                                        height: h * 0.06,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(200)),
                                          child: LinearProgressIndicator(
                                            value: progressPercentage(
                                                value.recu, value.montant),
                                            color: progressPercentage(
                                                        value.recu,
                                                        value.montant) <
                                                    0.5
                                                ? Colors.red
                                                : progressPercentage(
                                                                value.recu,
                                                                value
                                                                    .montant) >=
                                                            0.5 &&
                                                        progressPercentage(
                                                                value.recu,
                                                                value.montant) <
                                                            0.8
                                                    ? Colors.yellow
                                                    : Colors.green,
                                            backgroundColor: progressPercentage(
                                                        value.recu,
                                                        value.montant) <
                                                    0.5
                                                ? const Color.fromARGB(
                                                    117, 244, 67, 54)
                                                : progressPercentage(
                                                                value.recu,
                                                                value
                                                                    .montant) >=
                                                            0.5 &&
                                                        progressPercentage(
                                                                value.recu,
                                                                value.montant) <
                                                            0.8
                                                    ? const Color.fromARGB(
                                                        109, 255, 235, 59)
                                                    : const Color.fromARGB(
                                                        106, 76, 175, 79),
                                            semanticsValue: "Début",
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("${value.recu} CFA",
                                                style: customFonts(
                                                    20,
                                                    Colors.black,
                                                    FontWeight.bold)),
                                            Text(
                                              "${value.montant} cfa",
                                              style: customFonts(
                                                  15,
                                                  Colors.black,
                                                  FontWeight.w600),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                                SizedBox(height: h * 0.01),
                                // RECU - A RECEVOIR
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Reçu",
                                          style: customFonts(16, Colors.grey,
                                              FontWeight.bold)),
                                      Text("A recevoir",
                                          style: customFonts(16, Colors.grey,
                                              FontWeight.bold)),
                                    ]),
                                SizedBox(height: h * 0.02),
                                // RESTANT
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Restant",
                                          style: customFonts(16, Colors.grey,
                                              FontWeight.bold)),
                                      Row(children: [
                                        const Icon(
                                          Icons.remove_circle,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: h * 0.01),
                                        Text("${value.restant} cfa",
                                            style: customFonts(16, Colors.red,
                                                FontWeight.bold)),
                                      ])
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  Padding(
                    padding: EdgeInsets.all(h * 0.01),
                    child: Text("Rapport de versement",
                        style: customFonts(14, Colors.black, FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tooglerecap = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                                color: !_tooglerecap
                                    ? const Color.fromARGB(255, 202, 201, 201)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Graphe",
                              style: customFonts(
                                  17, Colors.black, FontWeight.w600),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tooglerecap = true;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                                color: _tooglerecap
                                    ? const Color.fromARGB(255, 202, 201, 201)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Liste",
                              style: customFonts(
                                  17, Colors.black, FontWeight.w600),
                            )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // GRAPHE
            SliverToBoxAdapter(
                child: value.rapport.isEmpty
                    ? Container()
                    : _tooglerecap
                        ? Container()
                        : Container(
                            width: w * 0.9,
                            height: h * 0.35,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                right: 10, left: 10, top: 65),
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: [
                                // PIE CHART
                                Expanded(
                                    child: PieChart(
                                  mainPiechatData(value.rapport),
                                  swapAnimationDuration: const Duration(
                                      milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                )),
                                const SizedBox(height: 90),
                              ],
                            ))),
            // LISTE
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                          padding: EdgeInsets.all(h * 0.01),
                          child: !_tooglerecap
                              ? Container()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border: Border.all(color: Colors.green)),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.receipt,
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                    title: Text(
                                        "${value.rapport[index]["cout"]} cfa",
                                        style: customFonts(
                                            24, Colors.grey, FontWeight.bold)),
                                    subtitle: Text(
                                        value.rapport[index]["created_at"]
                                            .toString()
                                            .substring(0, 10),
                                        style: customFonts(
                                            15, Colors.grey, FontWeight.bold)),
                                  ),
                                ),
                        ),
                    childCount: !_tooglerecap ? 1 : value.rapport.length))
          ],
        ),
      ),
    );
  }

  PieChartData mainPiechatData(rapports) {
    return PieChartData(
      // sections: pieSections(rapports),
      sections: List.generate(rapports.length, (index) {
        final element = rapports[index];
        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 15.0 : 10.0;
        final radius = isTouched ? 80.0 : 70.0;
        final widgetSize = isTouched ? 5.0 : 30.0;
        final numb = "${index + 1}";
        const shadows = [Shadow(color: Colors.black, blurRadius: 0.5)];
        return PieChartSectionData(
          title: '${element['cout']} fcfa ',
          color: colors[index],
          // color: Color.fromARGB(255, 104, 140, 95),
          value: element['cout'].toDouble(),
          radius: radius,
          titlePositionPercentageOffset: 0.6,
          borderSide: isTouched
              ? const BorderSide(color: Colors.grey, width: 1)
              : const BorderSide(color: Colors.grey, width: 0.5),
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 5, 5, 5),
            shadows: shadows,
          ),
          badgeWidget: _Badge(
            numb,
            size: widgetSize,
            borderColor: colors[index],
          ),
          badgePositionPercentageOffset: 1.04,
        );
      }),
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      startDegreeOffset: 90,
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: 50,
    );
  }

  double progressPercentage(actual, target) {
    double percentage = 0;
    percentage = actual / target;
    return percentage;
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.number, {
    required this.size,
    required this.borderColor,
  });
  final String number;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Text(number)),
    );
  }
}
