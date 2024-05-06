import 'package:invest_mobile/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/route.dart';
import '../util/method.dart';

class Othen extends StatelessWidget {
  const Othen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.06),
          height: h,
          width: w,
          child: Column(
            children: [
              SizedBox(height: h * 0.18),
              SvgPicture.asset("images/svg/verifie.svg",
                  height: 128, width: 128),
              SizedBox(
                height: h * 0.05,
              ),
              Text("Authentification",
                  style: customFonts(25, Colors.black, FontWeight.bold)),
              SizedBox(height: h * 0.03),
              Container(
                padding: EdgeInsets.all(h * 0.02),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _otForm(true, false, context),
                      _otForm(false, false, context),
                      _otForm(false, false, context),
                      _otForm(false, true, context)
                    ],
                  ),
                  SizedBox(height: h * 0.18),
                  CustomButton(
                      h: h,
                      label: "Continuer",
                      touch: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MyRoute.homePage, (Route<dynamic> route) => false);
                      },
                      colorBtn: Colors.black,
                      textColor: Colors.white)
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _otForm(bool first, last, BuildContext context) {
    return SizedBox(
      height: 75,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
            autofocus: first ? true : false,
            obscureText: true,
            showCursor: false,
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }
            },
            keyboardType: TextInputType.number,
            readOnly: false,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: customFonts(
                20, const Color.fromARGB(255, 83, 83, 83), FontWeight.bold),
            decoration: const InputDecoration(
              counter: Offstage(),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              filled: true,
              fillColor: Color.fromARGB(255, 253, 253, 253),
            )),
      ),
    );
  }
}
