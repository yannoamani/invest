
import 'package:dio/dio.dart';
import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/providers/userProvider.dart';
import 'package:invest_mobile/widget/customButton.dart';
import 'package:invest_mobile/widget/formWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../util/method.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final old_password = TextEditingController();
  final password = TextEditingController();
  final password_confirmation = TextEditingController();
  bool loading = false;
  void updatePassword() async {
    setState(() {
      loading = true;
    });
    var token =
        Provider.of<LoginInfo>(context, listen: false).userToken.toString();
    var user_id = Provider.of<UserProvider>(context, listen: false)
        .investisseur
        .id
        .toString();
    String url = "https://backend.invest-ci.com/api/updateCompte";
    try {
      Uri uri = Uri.parse(url);
      var response = await Dio().post(url,
          options: Options(headers: <String, String>{
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': "Bearer $token"
          }),
          data: FormData.fromMap({
            'old_password': old_password.text,
            'password': password.text,
            'password_confirmation': password_confirmation.text,
          }));
      int statusCode = response.statusCode!;
      var responseBody = response.data;
      // print(responseBody.toString());
      if (statusCode == 200) {
        if (responseBody['status']) {
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Modifié avec succès",
                  style: customFonts(14, Colors.white, FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("ERROR1 :" + responseBody['message'],
                  style: customFonts(14, Colors.white, FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1)));
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("ERROR2: " + responseBody['message'],
                  style: customFonts(14, Colors.white, FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1)));
        });
      }
    } on DioError catch (e) {
      print(e.response);
      setState(() {
        loading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Renseignez correctement les informations",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
        title: Text("Changer le mot de passe",
            style: customFonts(20, Colors.black, FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(h * 0.01),
                color: Colors.grey,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: h * 0.001,
                  ),
                  Text(
                    "Mot de passe",
                    style: customFonts(14, Colors.black, FontWeight.bold),
                  )
                ])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: h * 0.02),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),
                    FormWidget(
                        h: h,
                        label: "Ancien mot de passe",
                        intText: "",
                        controllerText: old_password,
                        type: TextInputType.visiblePassword,
                        useIcon: true),
                    SizedBox(height: h * 0.02),
                    FormWidget(
                        h: h,
                        label: "Nouveau mot de passe",
                        intText: "",
                        controllerText: password,
                        type: TextInputType.visiblePassword,
                        useIcon: true),
                    SizedBox(height: h * 0.01),
                    Text("Doit contenir:",
                        style: customFonts(16, Colors.grey, FontWeight.bold)),
                    SizedBox(height: h * 0.01),
                    verifyField(h, "Une majuscule"),
                    SizedBox(height: h * 0.01),
                    verifyField(h, "Un chiffre"),
                    SizedBox(height: h * 0.01),
                    verifyField(h, "Un caractère spécial"),
                    SizedBox(height: h * 0.01),
                    FormWidget(
                        h: h,
                        label: "Confirme le mot de passe",
                        intText: "",
                        controllerText: password_confirmation,
                        type: TextInputType.visiblePassword,
                        useIcon: true),
                    SizedBox(height: h * 0.06),
                    CustomButton(
                        h: h,
                        label: "Confirmer",
                        touch: () {
                          updatePassword();
                        },
                        colorBtn: Colors.black,
                        textColor: Colors.white)
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Row verifyField(double h, String libelle) {
    return Row(children: [
      const Icon(Icons.check_circle, color: Colors.green, size: 16),
      SizedBox(width: h * 0.02),
      Text(libelle, style: customFonts(14, Colors.green, FontWeight.bold))
    ]);
  }
}
