import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/providers/userProvider.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/detailsPack.dart';

class DetailsPack extends StatefulWidget {
  const DetailsPack({Key? key}) : super(key: key);
  _DetailsPack createState() => _DetailsPack();
}

class _DetailsPack extends State<DetailsPack> {
  String? _selectedQte;
  double count = 0;
  @override
  void initState() {
    test();
    super.initState();
  }

  void test() {}

  Widget build(BuildContext context) {
    count = Provider.of<DetailsPackProv>(context).tranche != 0
        ? Provider.of<DetailsPackProv>(context).prodRestant /
            Provider.of<DetailsPackProv>(context).tranche
        : 0;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String image = Provider.of<DetailsPackProv>(context).img;
    final List<String> _fruits = [];
    for (var i = 0; i < count; i++) {
      _fruits.add((Provider.of<DetailsPackProv>(context).tranche +
              (i * Provider.of<DetailsPackProv>(context).tranche))
          .toString());
    }

    if (count == 0) {
      Provider.of<DetailsPackProv>(context).qteFranchise();
    }

    return Scaffold(
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: h / 2,
            width: w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://backend.invest-ci.com/public/' + image),
                    fit: BoxFit.cover)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(h * 0.04),
            height: h / 1.5,
            width: w,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                color: Colors.white),
            child: Consumer<DetailsPackProv>(
              builder: (context, value, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value.libelle,
                          style:
                              customFonts(24, Colors.black, FontWeight.bold)),
                      Container(
                        padding: EdgeInsets.all(h * 0.005),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: value.prodRestant != 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                            value.prodRestant != 0
                                ? "Disponible"
                                : "Indisponible",
                            style:
                                customFonts(17, Colors.black, FontWeight.bold)),
                      )
                    ],
                  ),
                  SizedBox(height: h * 0.03),
                  // COUT PACKAGE
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Coût package:",
                            style:
                                customFonts(20, Colors.grey, FontWeight.bold)),
                        Text(value.cout.toString() + ' Fcfa',
                            style:
                                customFonts(20, Colors.grey, FontWeight.bold))
                      ]),
                  SizedBox(height: h * 0.03),
                  // GAIN
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gain:",
                            style:
                                customFonts(20, Colors.grey, FontWeight.bold)),
                        Text(value.gain.toString() + ' Fcfa',
                            style:
                                customFonts(20, Colors.grey, FontWeight.bold))
                      ]),
                  SizedBox(height: h * 0.03),
                  // NOMBRE DE PIECE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nombre de pièce:",
                          style: customFonts(20, Colors.grey, FontWeight.bold)),
                      Text(value.prodRestant.toString(),
                          style: customFonts(20, Colors.grey, FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: h * 0.03),
                  // DATE D'ECOULEMNT OU FRANCHISE
                  value.period != 'null'
                      // DATE D'ECOULEMENT
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Délai d'ecoulement:",
                                style: customFonts(
                                    20, Colors.grey, FontWeight.bold)),
                            Text('${value.period.toString()} + Jours',
                                style: customFonts(
                                    20, Colors.grey, FontWeight.bold))
                          ],
                        )
                      // FRANCHISE
                      : Row(
                          children: [
                            Text("Franchise",
                                style: customFonts(
                                    20, Colors.grey, FontWeight.bold)),
                          ],
                        ),
                  // SizedBox(height: h * 0.03),
                  count != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nombre desiré: ",
                                style: customFonts(
                                    20, Colors.grey, FontWeight.bold)),
                            DropdownButton(
                                value: _selectedQte,
                                elevation: 10,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedQte = newValue;
                                  });
                                  context.read<DetailsPackProv>().qte =
                                      _selectedQte;
                                },
                                items: _fruits
                                    .map((fruit) => DropdownMenuItem<String>(
                                        value: fruit, child: Text(fruit)))
                                    .toList())
                          ],
                        )
                      : Container(),
                  SizedBox(height: h * 0.02),
                  value.prodRestant != 0
                      ? Consumer<LoginInfo>(
                          builder: (context, value, child) => ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            child: MaterialButton(
                              onPressed: () {
                                if (context
                                            .read<UserProvider>()
                                            .investisseur
                                            .identity
                                            .length ==
                                        0 ||
                                    context
                                            .read<UserProvider>()
                                            .investisseur
                                            .phone
                                            .length ==
                                        0 ||
                                    context
                                            .read<UserProvider>()
                                            .investisseur
                                            .bankcard
                                            .length ==
                                        0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Pièce d'identité + Numéro de téléphone + Numéro de carte bancaire requis pour pouvoir effectuer des opérations. Allez dans Mon compte > Modifier pour les ajouter",
                                              style: customFonts(
                                                  14,
                                                  Colors.white,
                                                  FontWeight.bold)),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(
                                              milliseconds: 2500)));
                                } else {
                                  context
                                      .read<DetailsPackProv>()
                                      .achat(value.userToken, value.userId)
                                      .whenComplete(() {
                                    if (context.read<DetailsPackProv>().error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  context
                                                      .read<DetailsPackProv>()
                                                      .errorMessage,
                                                  style: customFonts(
                                                      14,
                                                      Colors.white,
                                                      FontWeight.bold)),
                                              backgroundColor: Colors.red,
                                              duration:
                                                  const Duration(seconds: 1)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Souscription reussie",
                                                  style: customFonts(
                                                      14,
                                                      Colors.white,
                                                      FontWeight.bold)),
                                              backgroundColor: Colors.green,
                                              duration: const Duration(
                                                  milliseconds: 500)));
                                      Navigator.of(context).pop();
                                    }
                                  });
                                }
                              },
                              child: context
                                      .watch<DetailsPackProv>()
                                      .buttonClick
                                  ? const SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  : Text("Souscrire",
                                      style: customFonts(
                                          17, Colors.white, FontWeight.w200)),
                              color: Colors.black,
                              minWidth: double.infinity,
                              height: h * 0.1,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(h * 0.005),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text('Pièce epuisé',
                              style: customFonts(
                                  17, Colors.white, FontWeight.bold)),
                        ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.05, top: h * 0.04),
            child: Container(
                height: h * 0.06,
                width: h * 0.06,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 24)),
          ),
        ),
      ]),
    );
  }
}
