import 'dart:convert';

import 'package:invest_mobile/util/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class DetailsPackProv extends ChangeNotifier {
  String _libelle = "", _period = "";
  int _cout = 0;
  int _nbrProd = 0;
  int _prodRestant = 0;
  int _gain = 0;
  int _id = 0;
  List _statut = [];
  String _img = "";
  String _qte = "";
  String _qteRestant = "";
  int _tranche = 0;

  bool _error = false;
  String _errorMessage = "";
  bool _buttonClick = false;

  bool get error => _error;
  String get errorMessage => _errorMessage;
  bool get buttonClick => _buttonClick;
  List get statut => _statut;

  String get libelle => _libelle;
  String get period => _period;
  int get cout => _cout;
  int get nbrProd => _nbrProd;
  int get prodRestant => _prodRestant;
  int get gain => _gain;
  int get id => _id;
  String get img => _img;
  String get qte => _qte;
  String get qteRestant => _qteRestant;
  int get tranche => _tranche;

  void click() {
    _buttonClick = !_buttonClick;
    notifyListeners();
  }

  Future<void> achat(String token, int userId) async {
    click();
    final response = await http.post(UrL.achat,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userId,
          "package_id": _id,
          "nb_pieces": _qte
        }));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status']) {
        _error = false;
        _buttonClick = false;
      } else {
        _error = true;
        _errorMessage = responseBody['message'];
        _buttonClick = false;
        // print(responseBody['message']);
      }
    } else {
      _error = true;
      _errorMessage = "Package deja souscrit";
      _buttonClick = false;
    }
    notifyListeners();
  }

  set statut(List statut) {
    _statut = statut;
    notifyListeners();
  }

  set id(int id) {
    _id = id;
    notifyListeners();
  }

  set libelle(String libelle) {
    _libelle = libelle;
    notifyListeners();
  }

  set qte(String? qte) {
    _qte = qte!;
    notifyListeners();
  }

  qteFranchise() {
    _qte = _qteRestant;
  }

  set qteRestant(String? qteRestant) {
    _qteRestant = qteRestant!;
    notifyListeners();
  }

  set period(String period) {
    _period = period;
    notifyListeners();
  }

  set img(String img) {
    _img = img;
    notifyListeners();
  }

  set cout(int cout) {
    _cout = cout;
    notifyListeners();
  }

  set nbrProd(int nbrProd) {
    _nbrProd = nbrProd;
    notifyListeners();
  }

  set prodRestant(int prodRestant) {
    _prodRestant = prodRestant;
    notifyListeners();
  }

  set tranche(tranche) {
    _tranche = tranche != null ? tranche : 0;
    notifyListeners();
  }

  set gain(int gain) {
    _gain = gain;
    notifyListeners();
  }
}
