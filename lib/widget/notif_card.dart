import 'package:flutter/material.dart';
import 'package:invest_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotifCard extends StatefulWidget {
  const NotifCard({super.key});

  @override
  State<NotifCard> createState() => _NotifCardState();
}

class _NotifCardState extends State<NotifCard> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    bool show =
        Provider.of<UserProvider>(context).investisseur.identity.isEmpty ||
            Provider.of<UserProvider>(context).investisseur.bankcard.isEmpty ||
            Provider.of<UserProvider>(context).investisseur.phone.isEmpty;
    return show
        ? isOn
            ? Card(
                elevation: 0,
                color: const Color.fromARGB(121, 171, 195, 247),
                child: SizedBox(
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
                              const Icon(
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
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 15,
                                  ))
                            ],
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.95,
                            child: const Text(
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
                      const SizedBox(height: 5)
                    ],
                  ),
                ),
              )
            : Container()
        : Container();
  }
}
