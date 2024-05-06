import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:invest_mobile/providers/login_info.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});
  @override
  State<Transaction> createState() => _Transaction();
}

class _Transaction extends State<Transaction> {
  List operations = [];
  bool load = false;
  @override
  void initState() {
    mesOperations();
    super.initState();
  }

  void mesOperations() async {
    setState(() {
      load = true;
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
      //print(response.body.toString());
      if (statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status']) {
          setState(() {
            load = false;
          });
          setState(() {
            operations = responseBody['data'];
          });
          // print('avant');
        } else {
          setState(() {
            load = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        load = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Transaction",
              style: customFonts(20, Colors.black, FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: load
            ? const SpinKitFadingCircle(
                color: Color.fromARGB(255, 0, 0, 0),
                size: 25,
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                itemBuilder: ((context, index) => custonTransaction(
                    h,
                    operations[index]['amount'],
                    operations[index]['type'],
                    DateFormat("yyyy-MM-dd")
                        .parse(operations[index]['created_at'])
                        .toString(),
                    operations[index]['state'])),
                itemCount: operations.length));
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
