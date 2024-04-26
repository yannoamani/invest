import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/routes/route.dart';
import 'package:invest_mobile/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/method.dart';

class BeginScreen extends StatelessWidget {
  const BeginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(w * 0.08, h * 0.05, w * 0.08, h * 0.04),
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              "images/image/log.jpeg",
              scale: 2.5,
            ),
            SizedBox(height: h * 0.3),
            Consumer<LoginInfo>(builder: (context, user, _) {
              return !user.isOnline
                  ? CustomButton(
                      h: h,
                      label: "Se connecter",
                      touch: () {
                        Navigator.of(context).pushNamed(MyRoute.loginPage);
                      },
                      colorBtn: Colors.white,
                      textColor: Colors.black)
                  : CustomButton(
                      h: h,
                      label: "Accueil",
                      touch: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MyRoute.homePage, (Route<dynamic> route) => false);
                      },
                      colorBtn: Colors.white,
                      textColor: Colors.black);
            }),
            SizedBox(height: h * 0.02),
            CustomButton(
                h: h,
                label: "S'inscrire",
                touch: () {
                  Navigator.of(context).pushNamed(MyRoute.signIn);
                },
                colorBtn: Colors.white,
                textColor: Colors.black),
            SizedBox(height: h * 0.02),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MyRoute.homePage, (Route<dynamic> route) => false);
                    },
                    child: Text("Voir les packages",
                        style: customFonts(17, Colors.white, FontWeight.bold)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
