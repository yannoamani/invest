import 'package:flutter/material.dart';
import 'package:invest_mobile/providers/userProvider.dart';
import 'package:provider/provider.dart';

class NotifCard extends StatefulWidget {
  const NotifCard({Key? key}) : super(key: key);

  @override
  State<NotifCard> createState() => _NotifCardState();
}

class _NotifCardState extends State<NotifCard> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool show =
        Provider.of<UserProvider>(context).investisseur.identity.length == 0 ||
            Provider.of<UserProvider>(context).investisseur.bankcard.length ==
                0 ||
            Provider.of<UserProvider>(context).investisseur.phone.length == 0;
    return show
        ? isOn
            ? Card(
                elevation: 0,
                color: Color.fromARGB(121, 171, 195, 247),
                child: Container(
                  width: w,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 15,
                                color: Color.fromARGB(255, 129, 28, 21),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isOn = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    size: 15,
                                  ))
                            ],
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.95,
                            child: Text(
                              "Pièce d'identité + Numéro de téléphone + Numéro de carte bancaire requis pour pouvoir effectuer des opérations. Allez dans Mon compte > Modifier pour les ajouter",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5)
                    ],
                  ),
                ),
              )
            : Container()
        : Container();
  }
}
