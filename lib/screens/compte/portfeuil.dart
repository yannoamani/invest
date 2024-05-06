import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:invest_mobile/providers/login_info.dart';
import 'package:invest_mobile/providers/user_provider.dart';
import 'package:invest_mobile/widget/custom_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../util/method.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? _selectedMethod;
  bool loading = false;
  List methods = [];
  List operations = [];
  Widget? mod;
  String? fileName;
  // ignore: prefer_typing_uninitialized_variables
  var result;
  TextEditingController amount = TextEditingController();
  TextEditingController contact = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var showModalBottomSheet2;
  @override
  void initState() {
    fetch();
    super.initState();
  }

  void fetch() async {
    setState(() {
      moyens();
      mesOperations();
    });
  }

  void accountRequest(userId, type, token) async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> body;
    body = <String, dynamic>{};
    body['user_id'] = userId;
    body['type'] = type;
    body['amount'] = amount.text;
    body['moyen_id'] = _selectedMethod.toString();
    body['numero'] = contact.text;
    if (result != null) {
      body['proof'] = await MultipartFile.fromFile(result.path.toString(),
          filename:
              'proof_user_0${userId}_${Random().nextInt(100)}${Random().nextInt(100)}');
    }
    FormData formData = FormData.fromMap(body);
    final dio = Dio();
    String url = "https://backend.invest-ci.com/api/operations";
    try {
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
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        fetch();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Requete envoyé avec succès",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1)));
      } else {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.data['message'],
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5)));
      }
    } on DioException catch (_) {
      setState(() {
        loading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur",
                style: customFonts(14, Colors.white, FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
      });
    }
  }

  void moyens() async {
    setState(() {
      loading = true;
    });
    String url = "https://backend.invest-ci.com/api/moyens";
    try {
      await Provider.of<UserProvider>(context, listen: false).userInfo();

      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status']) {
          setState(() {
            methods = responseBody['data'];
          });
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _showMyDialog() async {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Prévisualisation'),
          content: SingleChildScrollView(
              child:
                  Image.file(File(result.path.toString()), fit: BoxFit.cover)),
          actions: <Widget>[
            TextButton(
              child: const Text('confirmer'),
              onPressed: () {
                setState(() {
                  fileName = 'Vous avez ajouté une piece jointe';
                });
                Navigator.of(context).pop();
                depotModal(h, w);
              },
            ),
            TextButton(
              child: const Text('annuler'),
              onPressed: () {
                setState(() {
                  fileName = '';
                  result = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void uploadFile() async {
    try {
      final fichier =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (fichier != null) {
        result = fichier;
        fileName = 'Vous avez ajouté une piece jointe';
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        _showMyDialog();
      } else {
        // User canceled the picker
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  retraitModal(h, w) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    padding: EdgeInsets.all(h * 0.02),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.05, vertical: h * 0.03),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(h * 0.02)),
                                color: Colors.black),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Solde",
                                      style: customFonts(
                                          14, Colors.white, FontWeight.bold)),
                                  Text(
                                      '${Provider.of<UserProvider>(context).investisseur.solde} XOF',
                                      style: customFonts(
                                          18, Colors.white, FontWeight.bold)),
                                ])),
                        SizedBox(height: h * 0.02),
                        Text("Montant",
                            style:
                                customFonts(16, Colors.black, FontWeight.bold)),
                        SizedBox(height: h * 0.015),
                        TextField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          style: customFonts(
                              17,
                              const Color.fromARGB(255, 83, 83, 83),
                              FontWeight.bold),
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 229, 229, 229),
                            // hintText: "2.000",
                            hintStyle:
                                customFonts(17, Colors.grey, FontWeight.bold),
                          ),
                          cursorColor: Colors.grey,
                        ),
                        SizedBox(height: h * 0.01),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text('Canal de reception',
                                  style: customFonts(
                                      16, Colors.black, FontWeight.bold)),
                              const Padding(padding: EdgeInsets.all(20)),
                              DropdownButton<String>(
                                  value: _selectedMethod,
                                  elevation: 12,
                                  items: methods
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(item['libelle'])))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    _selectedMethod = newValue;
                                    setState(() {
                                      _selectedMethod = newValue;
                                    });
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return methods.map<Widget>((item) {
                                      return Container(
                                        alignment: Alignment.center,
                                        constraints:
                                            const BoxConstraints(minWidth: 100),
                                        child: Text(
                                          item['libelle'],
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    }).toList();
                                  })
                            ],
                          ),
                        ),
                        /////
                        Text("No de compte ou telephone",
                            style:
                                customFonts(16, Colors.black, FontWeight.bold)),
                        SizedBox(height: h * 0.01),
                        TextField(
                          controller: contact,
                          keyboardType: TextInputType.number,
                          style: customFonts(
                              17,
                              const Color.fromARGB(255, 83, 83, 83),
                              FontWeight.bold),
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 229, 229, 229),
                            hintText: "",
                            hintStyle:
                                customFonts(17, Colors.grey, FontWeight.bold),
                          ),
                          cursorColor: Colors.grey,
                        ),
                        SizedBox(height: h * 0.01),
                        loading
                            ? const SpinKitFadingCircle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 25,
                              )
                            : CustomButton(
                                h: h,
                                label: "Retirer",
                                touch: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  accountRequest(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .investisseur
                                          .id
                                          .toString(),
                                      'retrait',
                                      Provider.of<LoginInfo>(context,
                                              listen: false)
                                          .userToken
                                          .toString());
                                },
                                colorBtn: Colors.black,
                                textColor: Colors.white)
                      ],
                    )),
              );
            }));
  }

  depotModal(h, w) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    padding: EdgeInsets.all(h * 0.02),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.05, vertical: h * 0.03),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(h * 0.02)),
                                color: Colors.black),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Solde",
                                      style: customFonts(
                                          14, Colors.white, FontWeight.bold)),
                                  Text(
                                      '${Provider.of<UserProvider>(context).investisseur.solde} XOF',
                                      style: customFonts(
                                          18, Colors.white, FontWeight.bold)),
                                ])),
                        SizedBox(height: h * 0.02),
                        Text("Montant",
                            style:
                                customFonts(16, Colors.black, FontWeight.bold)),
                        SizedBox(height: h * 0.015),
                        TextField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          style: customFonts(
                              17,
                              const Color.fromARGB(255, 83, 83, 83),
                              FontWeight.bold),
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 229, 229, 229),
                            // hintText: "2.000",
                            hintStyle:
                                customFonts(17, Colors.grey, FontWeight.bold),
                          ),
                          cursorColor: Colors.grey,
                        ),
                        SizedBox(height: h * 0.01),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text('Canal d\'envoi',
                                  style: customFonts(
                                      16, Colors.black, FontWeight.bold)),
                              const Padding(padding: EdgeInsets.all(20)),
                              DropdownButton<String>(
                                  value: _selectedMethod,
                                  elevation: 12,
                                  items: methods
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(item['libelle'])))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    _selectedMethod = newValue;
                                    setState(() {
                                      _selectedMethod = newValue;
                                    });
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return methods.map<Widget>((item) {
                                      return Container(
                                        alignment: Alignment.center,
                                        constraints:
                                            const BoxConstraints(minWidth: 100),
                                        child: Text(
                                          item['libelle'],
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    }).toList();
                                  })
                            ],
                          ),
                        ),
                        /////

                        SizedBox(height: h * 0.01),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  uploadFile();
                                },
                                child: const Text('fichier')),
                            const Padding(padding: EdgeInsets.all(8)),
                            fileName == null
                                ? Text('',
                                    style: TextStyle(
                                      fontSize: 16,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 1
                                        ..color = Colors.blue[600]!,
                                    ))
                                : Text(fileName!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 1
                                        ..color = Colors.blue[600]!,
                                    )),
                          ],
                        ),

                        SizedBox(height: h * 0.01),

                        CustomButton(
                            h: h,
                            label: "Déposer",
                            touch: () {
                              accountRequest(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .investisseur
                                      .id
                                      .toString(),
                                  'depot',
                                  Provider.of<LoginInfo>(context, listen: false)
                                      .userToken
                                      .toString());
                            },
                            colorBtn: Colors.black,
                            textColor: Colors.white)
                      ],
                    )),
              );
            }));
  }

  void mesOperations() async {
    setState(() {
      loading = true;
    });
    String url = "https://backend.invest-ci.com/api/user-operations";
    var token =
        Provider.of<LoginInfo>(context, listen: false).userToken.toString();
    try {
      Uri uri = Uri.parse(url);
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
        },
      );
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status']) {
          setState(() {
            operations = responseBody['data'];
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
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
        title: Text("Portefeuille",
            style: customFonts(20, Colors.black, FontWeight.bold)),
        centerTitle: true,
      ),
      body: loading
          ? const SpinKitFadingCircle(
              color: Color.fromARGB(255, 0, 0, 0),
              size: 25,
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03, vertical: h * 0.02),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(h * 0.01),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(h * 0.02),
                            height: h * 0.30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF000000),
                                      Color(0xFF434343)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(h * 0.01))),
                            child: Column(
                              children: [
                                Row(children: [
                                  Text("Solde",
                                      style: customFonts(
                                          20, Colors.white, FontWeight.bold))
                                ]),
                                SizedBox(height: h * 0.01),
                                Row(children: [
                                  Text(
                                      Provider.of<UserProvider>(context)
                                          .investisseur
                                          .solde
                                          .toString(),
                                      style: customFonts(
                                          24, Colors.white, FontWeight.bold)),
                                  SizedBox(width: w * 0.02),
                                  Text("XOF",
                                      style: customFonts(
                                          20, Colors.white, FontWeight.w200))
                                ]),
                                SizedBox(height: h * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: h * 0.07,
                                      width: w * 0.25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(h * 0.01)),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFf3f9a7),
                                                Color(0xFFcac531)
                                              ],
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft)),
                                    ),
                                    Text("Invest",
                                        style: customFonts(
                                            20, Colors.white, FontWeight.bold))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: Card(
                          child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                      onPressed: () {
                                        depotModal(h, w);
                                      },
                                      minWidth: w / 2.18,
                                      child: Padding(
                                        padding: EdgeInsets.all(h * 0.02),
                                        child: Column(children: [
                                          const Icon(Icons.savings,
                                              color: Colors.green),
                                          Text(
                                            "Depôt",
                                            style: customFonts(17, Colors.green,
                                                FontWeight.bold),
                                          )
                                        ]),
                                      )),
                                  MaterialButton(
                                      minWidth: w / 2.18,
                                      onPressed: () {
                                        retraitModal(h, w);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(h * 0.02),
                                        child: Column(children: [
                                          const Icon(Icons.request_quote,
                                              color: Colors.red),
                                          Text("Retrait",
                                              style: customFonts(17, Colors.red,
                                                  FontWeight.bold))
                                        ]),
                                      ))
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(w * 0.03),
                        child: Row(
                          children: [
                            Text(
                              "Dernières transactions",
                              style:
                                  customFonts(14, Colors.grey, FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.01),
                              child: custonTransaction(
                                  h,
                                  operations[index]['amount'],
                                  operations[index]['type'],
                                  operations[index]['created_at'].toString(),
                                  operations[index]['state']),
                            ),
                        childCount: operations.length))
              ],
            ),
    );
  }
}

Widget custonTransaction(
  double h,
  int amount,
  String type,
  String date,
  String state,
) {
  return Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Stack(children: [
      ListTile(
        leading: SizedBox(
          width: h * 0.001,
        ),
        title: Text("$amount XOF",
            style: customFonts(18, Colors.black, FontWeight.bold)),
        trailing:
            Text(type, style: customFonts(15, Colors.grey, FontWeight.bold)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date.substring(0, 19),
                style: customFonts(12, Colors.grey, FontWeight.bold)),
            state == 'validé'
                ? Text(state,
                    style: customFonts(12, Colors.green, FontWeight.bold))
                : Text(state,
                    style: customFonts(12, Colors.orange, FontWeight.bold)),
          ],
        ),
      ),
      type == 'depot'
          ? Padding(
              padding: EdgeInsets.only(left: h * 0.0135, top: h * 0.032),
              child: Container(
                height: h * 0.015,
                width: h * 0.015,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: h * 0.0135, top: h * 0.032),
              child: Container(
                height: h * 0.015,
                width: h * 0.015,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ),
      type == 'depot'
          ? Padding(
              padding: EdgeInsets.only(left: h * 0.02),
              child: DottedLine(
                direction: Axis.vertical,
                dashColor: Colors.green,
                dashGapLength: 5,
                lineThickness: 2,
                dashGapRadius: 5,
                lineLength: h * 0.09,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: h * 0.02),
              child: DottedLine(
                direction: Axis.vertical,
                dashColor: Colors.red,
                dashGapLength: 5,
                lineThickness: 2,
                dashGapRadius: 5,
                lineLength: h * 0.09,
              ))
    ]),
  );
}

Widget elment(double h, String lib) {
  return Container(
      padding: EdgeInsets.all(h * 0.01),
      decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          borderRadius: BorderRadius.all(Radius.circular(h * 0.01))),
      child: Column(children: [
        Text(lib, style: customFonts(16, Colors.black, FontWeight.bold))
      ]));
}
