import 'package:invest_mobile/providers/user_provider.dart';
import 'package:invest_mobile/util/method.dart';
import 'package:invest_mobile/widget/home.dart';
import 'package:invest_mobile/widget/list.dart';
import 'package:invest_mobile/widget/profil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final screens = [
    const Home(),
    const Suscrib(),
    const Profil(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedFontSize: 16,
        selectedLabelStyle: customFonts(15, Colors.white, FontWeight.bold),
        showUnselectedLabels: false,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Accueil"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Souscription"),
          BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: Provider.of<UserProvider>(context)
                            .investisseur
                            .identity
                            .isEmpty ||
                        Provider.of<UserProvider>(context)
                            .investisseur
                            .bankcard
                            .isEmpty ||
                        Provider.of<UserProvider>(context)
                            .investisseur
                            .phone
                            .isEmpty
                    ? true
                    : false,
                child: const Icon(Icons.person),
              ),
              label: "Mon compte"),
        ],
      ),
    );
  }
}
