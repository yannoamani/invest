import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invest_mobile/providers/loginInfo.dart';
import 'package:invest_mobile/providers/userProvider.dart';
import 'package:invest_mobile/widget/customButton.dart';
import 'package:invest_mobile/widget/formWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../util/method.dart';

class DetailsProfil extends StatefulWidget {
  const DetailsProfil({Key? key}) : super(key: key);
  _DetailsProfil createState() => _DetailsProfil();
}

class _DetailsProfil extends State<DetailsProfil> {
  bool loading = false;
  final nom = TextEditingController();
  final prenoms = TextEditingController();
  final phone = TextEditingController();
  final localisation = TextEditingController();
  final email = TextEditingController();
  final bankcard = TextEditingController();
  var identity;

  void detailsRequest() async {
    setState(() {
      loading = true;
    });
    var token =
        Provider.of<LoginInfo>(context, listen: false).userToken.toString();
    var user = Provider.of<UserProvider>(context, listen: false).investisseur;
    String url = "https://backend.invest-ci.com/api/update";
    try {
      Map<String, dynamic> body = {
        'id': user.id,
        'nom': nom.text,
        'prenoms': prenoms.text,
        'phone': phone.text,
        'lieu_habitation': localisation.text,
        'email': email.text,
        'bank_card': bankcard.text
      };
      var response = await Dio().post(url,
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer $token"
          }),
          data: FormData.fromMap(body));
      int statusCode = response.statusCode!;
      var responseBody = response.data;
      if (statusCode == 200) {
        if (responseBody['status']) {
          setState(() {
            loading = false;
          });
          context.read<UserProvider>().investisseur.nom =
              responseBody['data']['nom'];
          context.read<UserProvider>().investisseur.prenom =
              responseBody['data']['prenoms'];
          context.read<UserProvider>().investisseur.email =
              responseBody['data']['email'];
          context.read<UserProvider>().investisseur.phone =
              responseBody['data']['phone'];
          context.read<UserProvider>().investisseur.bankcard =
              responseBody['data']['bank_card'];
          context.read<UserProvider>().investisseur.lieuHabitation =
              responseBody['data']['lieu_habitation'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Modifié avec succès",
                  style: customFonts(14, Colors.white, FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(responseBody['message'],
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
              content: Text(responseBody['message'],
                  style: customFonts(14, Colors.white, FontWeight.bold)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1)));
        });
      }
    } on DioException catch (e) {
      print(e.response);
      setState(() {
        loading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
        title: Text("Details",
            style: customFonts(20, Colors.black, FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h * 0.01),
              Provider.of<UserProvider>(context).investisseur.identity.length ==
                      0
                  ? _identityField(h)
                  : Container(),
              FormWidget(
                  h: h,
                  label: "nom",
                  controllerText: nom,
                  intText: Provider.of<UserProvider>(context).investisseur.nom,
                  type: TextInputType.name,
                  useIcon: false),
              SizedBox(height: h * 0.01),
              FormWidget(
                  h: h,
                  label: "prenoms",
                  controllerText: prenoms,
                  intText:
                      Provider.of<UserProvider>(context).investisseur.prenom,
                  type: TextInputType.name,
                  useIcon: false),
              SizedBox(height: h * 0.01),
              FormWidget(
                  h: h,
                  label: "contact",
                  controllerText: phone,
                  intText:
                      Provider.of<UserProvider>(context).investisseur.phone,
                  type: TextInputType.phone,
                  useIcon: false),
              SizedBox(height: h * 0.01),
              FormWidget(
                  h: h,
                  label: "localisation",
                  intText: Provider.of<UserProvider>(context)
                      .investisseur
                      .lieuHabitation,
                  controllerText: localisation,
                  type: TextInputType.text,
                  useIcon: false),
              SizedBox(height: h * 0.01),
              FormWidget(
                  h: h,
                  label: "email",
                  controllerText: email,
                  intText:
                      Provider.of<UserProvider>(context).investisseur.email,
                  type: TextInputType.text,
                  useIcon: false),
              SizedBox(height: h * 0.03),
              FormWidget(
                h: h,
                label: "numéro de carte bancaire",
                controllerText: bankcard,
                intText:
                    Provider.of<UserProvider>(context).investisseur.bankcard,
                type: TextInputType.number,
                useIcon: false,
                obscure: true,
              ),
              SizedBox(height: h * 0.03),
              loading
                  ? SpinKitFadingCircle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    )
                  : CustomButton(
                      h: h,
                      label: "Enregistrer",
                      touch: () {
                        detailsRequest();
                      },
                      colorBtn: Colors.black,
                      textColor: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      identity = result;
      await identityAdd();
    } else {
      identity = null;
    }
  }

  Widget _identityField(h) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(h * 0.02)),
      child: Container(
        padding: EdgeInsets.all(h * 0.01),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Vous n'avez pas de pièce d'identité \n Vous ne pourrez pas faire \n de souscription",
              style: customFonts(13, Colors.red, FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  await pickFile();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: 20,
                    ),
                    Text(
                      'Charger',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> identityAdd() async {
    var token =
        Provider.of<LoginInfo>(context, listen: false).userToken.toString();
    var user = Provider.of<UserProvider>(context, listen: false).investisseur;
    String url = "https://backend.invest-ci.com/api/update";
    try {
      Uri uri = Uri.parse(url);

      var body = Map<String, dynamic>();
      body['id'] = user.id;
      body['identity'] = await MultipartFile.fromFile(
          identity!.files.single.path.toString(),
          filename:
              "identity_user_0${user.id}${Random().nextInt(100).toString()}");
      FormData formData = new FormData.fromMap(body);
      final dio = Dio();

      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: <String, dynamic>{
            'Authorization': "Bearer $token",
          },
        ),
      );
      if (response.data['status']) {
        context.read<UserProvider>().investisseur.identity =
            response.data['data']['identity'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Ajouté avec succès",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1)));
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.data['message'],
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      }
    } catch (e) {
      print(e);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      });
    }
  }
}
