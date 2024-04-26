import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MesSousProvider extends ChangeNotifier {
  int _montant = 0, _recu = 0, _restant = 0, _coutpackage = 0;
  String _ecoulement = "", _libelle = "";
  List _rapport = [];

  set rapport(List rap) {
    _rapport = rap;
    notifyListeners();
  }

  List get rapport => _rapport;
  set coutpackage(int coutpackage) {
    _coutpackage = coutpackage;
    notifyListeners();
  }

  int get coutpackage => _coutpackage;

  set montant(int montant) {
    _montant = montant;
    notifyListeners();
  }

  int get montant => _montant;

  set recu(int recu) {
    _recu = recu;
    notifyListeners();
  }

  int get recu => _recu;

  set restant(int restant) {
    _restant = restant;
    notifyListeners();
  }

  int get restant => _restant;

  set ecoulement(String ecoulement) {
    _ecoulement = ecoulement;
    notifyListeners();
  }

  String get ecoulement => _ecoulement;

  set libelle(String libelle) {
    _libelle = libelle;
    notifyListeners();
  }

  String get libelle => _libelle;

  bool _error = false;
  String _errorMessage = "";
  bool _isLoad = true;
  List<dynamic> _pack = [];

  bool get isLoad => _isLoad;
  bool get error => _error;
  String get errorMessage => _errorMessage;
  List<dynamic> get pack => _pack;

  set isLoad(bool value) {
    _isLoad = value;
    notifyListeners();
  }

  Future<void> loadSous(int id, String token) async {
    try {
      final response = await http.get(
          Uri.parse("https://backend.invest-ci.com/api/user_achats/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer $token"
          });
      if (response.statusCode == 200) {
        try {
          _pack = jsonDecode(response.body)["data"];
          _error = false;
          _errorMessage = "";
          _isLoad = false;
        } catch (e) {
          _error = true;
          _errorMessage = e.toString();
          _isLoad = false;
          print(_errorMessage);
        }
      } else {
        _error = true;
        _errorMessage = "Problème au niveau de la connexion au serveur";
        _isLoad = false;
        print(_errorMessage);
      }
    } catch (e) {
      print(e);
      _error = true;
      _errorMessage = e.toString();
      _isLoad = false;
    }
    notifyListeners();
  }
}
