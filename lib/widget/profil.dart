import 'dart:async';

import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invest_mobile/widget/notifCard.dart';
import 'package:invest_mobile/widget/profilcard.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../routes/route.dart';
import '../util/method.dart';
import 'customButton.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Text("Profil",
                style: customFonts(24, Colors.white, FontWeight.bold))),
        body: Consumer<LoginInfo>(
          builder: (context, value, child) => !value.isOnline
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
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.01, vertical: h * 0.01),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NotifCard(),
                          Text("MES INFORMATIONS",
                              style: customFonts(
                                  14, Colors.grey, FontWeight.bold)),
                          SizedBox(height: h * 0.01),
                          ProfilCard(),
                          _customBtn(h, "Modifier", Icons.edit, () {
                            Navigator.of(context)
                                .pushNamed(MyRoute.profilDetail);
                          }),
                          _customBtn(
                              h, "Changer le mot de passe", Icons.password, () {
                            Navigator.of(context)
                                .pushNamed(MyRoute.changePassword);
                          }),
                          SizedBox(height: h * 0.01),
                          Text("MON COMPTE INVEST",
                              style: customFonts(
                                  14, Colors.grey, FontWeight.bold)),
                          SizedBox(height: h * 0.01),
                          _customBtn(
                              h, "Portefeuille", Icons.account_balance_wallet,
                              () {
                            Navigator.of(context).pushNamed(MyRoute.portefeuil);
                          }),
                          _customBtn(h, "Transaction", Icons.paid, () {
                            Navigator.of(context)
                                .pushNamed(MyRoute.transaction);
                          }),
                          SizedBox(height: h * 0.01),
                          Text("ZONE DANGEREUSE",
                              style: customFonts(
                                  14, Colors.redAccent, FontWeight.bold)),
                          SizedBox(height: h * 0.01),
                          _customBtn(h, "Deconnexion", Icons.logout, () {
                            context.read<LoginInfo>().logout().then((value) {
                              Timer(Duration(seconds: 1), () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    MyRoute.begin,
                                    (Route<dynamic> route) => false);
                              });
                            });
                          })
                        ]),
                  ),
                ),
        ));
  }

  Card _customBtn(double h, String libelle, IconData icone, Function tap) {
    return Card(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: MaterialButton(
          onPressed: () {
            tap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icone, color: Colors.black, size: 35),
                  SizedBox(width: h * 0.02),
                  Text(libelle,
                      style: customFonts(16, Colors.black, FontWeight.bold))
                ],
              ),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ))
            ],
          ),
          color: Colors.white,
          minWidth: double.infinity,
          height: h * 0.1,
        ),
      ),
    );
  }
}
