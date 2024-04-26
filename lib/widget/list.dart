import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/routes/route.dart';
import 'package:invest_mobile/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/messousProvider.dart';
import '../util/method.dart';

class Suscrib extends StatefulWidget {
  const Suscrib({Key? key}) : super(key: key);
  State<Suscrib> createState() => _SuscribState();
}

class _SuscribState extends State<Suscrib> {
  List? packs;
  bool load = false;
  void initState() {
    loadPack();
    super.initState();
  }

  void loadPack() async {
    setState(() {
      load = true;
    });

    await Provider.of<MesSousProvider>(context, listen: false).loadSous(
        Provider.of<LoginInfo>(context, listen: false).userId,
        Provider.of<LoginInfo>(context, listen: false).userToken.toString());
    packs = await context.read<MesSousProvider>().pack;

    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    context.read<MesSousProvider>().pack;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text("Souscription",
              style: customFonts(24, Colors.white, FontWeight.bold))),
      body: !Provider.of<LoginInfo>(context, listen: false).isOnline
          ? Column(
              children: [
                SizedBox(
                  height: h * 0.08,
                ),
                Text("Connecter vous pour acceder au service!!!",
                    textAlign: TextAlign.center,
                    style: customFonts(20, Colors.black, FontWeight.bold)),
                SizedBox(height: h * 0.05),
                SvgPicture.asset("images/svg/login.svg",
                    height: 128, width: 128),
                SizedBox(height: h * 0.2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: h * 0.04),
                  child: CustomButton(
                      h: h,
                      label: "Se connecter",
                      touch: () {
                        Navigator.of(context).pushNamed(MyRoute.loginPage);
                      },
                      colorBtn: Colors.black,
                      textColor: Colors.white),
                )
              ],
            )
          : load
              ? SpinKitFadingCircle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 25,
                )
              : packs!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Vous n'avez pas encore fait de souscription",
                            textAlign: TextAlign.center,
                            style:
                                customFonts(20, Colors.black, FontWeight.bold)),
                        Image.asset("images/image/noresult.png",
                            height: 150, width: 150),
                      ],
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: ((context, index) => MaterialButton(
                          onPressed: () {
                            List rapport = packs![index]["rapport"];
                            int received = 0;

                            print(rapport
                                .map((e) => received = e['cout'] + received));

                            int count_vente = packs![index]["package"]
                                    ["cout_vente"] *
                                packs![index]["nb_pieces"];
                            int cout_achat = packs![index]["package"]
                                    ["cout_acquisition"] *
                                packs![index]["nb_pieces"];
                            context.read<MesSousProvider>().coutpackage =
                                cout_achat;
                            context.read<MesSousProvider>().montant =
                                count_vente;
                            context.read<MesSousProvider>().rapport =
                                packs![index]["rapport"];
                            context.read<MesSousProvider>().recu = received;
                            context.read<MesSousProvider>().restant =
                                count_vente - received;
                            context.read<MesSousProvider>().ecoulement =
                                packs![index]["date_validite"];
                            context.read<MesSousProvider>().libelle =
                                packs![index]["package"]["libelle"];
                            Navigator.of(context)
                                .pushNamed(MyRoute.detailSouscription);
                          },
                          child: customItem(
                              h,
                              packs![index]["package"]["libelle"],
                              packs![index]["package"]["type"]["libelle"],
                              packs![index]["package"]["cout_acquisition"] *
                                  packs![index]["nb_pieces"],
                              packs![index]["date_validite"],
                              packs![index]["consommed"]))),
                      separatorBuilder: ((context, index) => Divider(
                            thickness: 2.0,
                            color: Colors.grey[300],
                          )),
                      itemCount: packs!.length),
    );
  }
}

Widget customItem(double h, String libelle, String type, int gain,
        String nb_jour, int conso) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: h * 0.014, right: h * 0.01),
                  child: CircleAvatar(
                    radius: h * 0.007,
                    backgroundColor: Colors.blue,
                  ))
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(libelle,
                  style: customFonts(20, Colors.black, FontWeight.w300)),
              SizedBox(height: h * 0.002),
              Text(type, style: customFonts(15, Colors.grey, FontWeight.w100)),
              Text("Coût du package: $gain Fcfa",
                  style: customFonts(15, Colors.grey, FontWeight.w100)),
              SizedBox(height: h * 0.008),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(h * 0.005),
                    alignment: Alignment.center,
                    decoration: conso == 0
                        ? BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(h * 0.02)))
                        : BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(h * 0.02))),
                    child: conso == 0
                        ? Text("En cours",
                            style: customFonts(
                                14,
                                Color.fromARGB(255, 136, 136, 136),
                                FontWeight.bold))
                        : Text("Terminé",
                            style: customFonts(
                                14,
                                Color.fromARGB(255, 144, 144, 144),
                                FontWeight.bold)),
                  ),
                  SizedBox(width: h * 0.018),
                  Container(
                    padding: EdgeInsets.all(h * 0.005),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            BorderRadius.all(Radius.circular(h * 0.02))),
                    child: Text("Date limite : $nb_jour ",
                        style: customFonts(14, Colors.grey, FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        ),
        // Expanded(
        //   flex: 3,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.only(top: h * 0.05),
        //         child: Text("$nb_jour",
        //             textAlign: TextAlign.center,
        //             style: customFonts(14, Colors.grey, FontWeight.w200)),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
