import 'dart:convert';
import 'package:invest_mobile/model/user.dart';
import 'package:invest_mobile/util/url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class UserProvider extends ChangeNotifier {
  User _investisseur = User(
      id: 0,
      nom: "",
      prenom: "",
      email: "",
      lieuHabitation: "",
      password: "",
      phone: "",
      picture: "",
      bankcard: "",
      identity: "",
      solde: 0);
  String _token = "";
  bool _error = false;
  String _errorMessage = "";
  bool _buttonClick = false;

  bool get buttonClick => _buttonClick;

  void click() {
    _buttonClick = !_buttonClick;
    notifyListeners();
  }

  User get investisseur => _investisseur;
  bool get error => _error;
  String get errorMessage => _errorMessage;
  String get token => _token;

  Future<void> signInUser(String nom, prenom, phone, bank, habitation, email,
      pass, identity) async {
    click();
    try {
      Map<String, dynamic> body = {};
      body["nom"] = nom;
      body["prenoms"] = prenom;
      body["phone"] = phone;
      body["lieu_habitation"] = habitation;
      body["email"] = email;
      body["password"] = pass;
      body["bank_card"] = bank;

      final formData = dio.FormData.fromMap(body);

      final response = await dio.Dio().post(
        "https://backend.invest-ci.com/api/auth/signupMobile",
        data: formData,
      );
      if (response.data['status']) {
        _error = false;
        _errorMessage = "";
        _buttonClick = false;
      } else {
        _error = true;
        _errorMessage = "Problème au niveau de la connexion au serveur";
        _buttonClick = false;
      }
    } on dio.DioException catch (e) {
      if (e.response!.statusCode == 500) {
        _errorMessage =
            "Code 500: Problème au niveau de la connexion au serveur";
      }
      _buttonClick = false;
      _error = true;
    }
    notifyListeners();
  }

  Future<void> logInUser(String email, pasword) async {
    click();
    try {
      final response =
          await dio.Dio().post("https://backend.invest-ci.com/api/auth/login",
              options: dio.Options(
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              ),
              data: jsonEncode({"email": email, "password": pasword}));
      if (response.statusCode == 200) {
        _token = response.data["access_token"];
        _investisseur = User(
            id: response.data["user"]['id'],
            nom: response.data["user"]['nom'],
            prenom: response.data["user"]['prenoms'],
            email: email,
            lieuHabitation: response.data["user"]['lieu_habitation'],
            picture: response.data["user"]['picture'] ?? '',
            identity: response.data["user"]['identity'] ?? '',
            bankcard: response.data["user"]['bank_card'] ?? '',
            password: pasword,
            phone: response.data["user"]['phone'] ?? '',
            solde: response.data["user"]['solde']);
        _error = false;
        _errorMessage = "";
        _buttonClick = false;
      } else {
        _error = true;
        _errorMessage = "Problème au niveau de la connexion au serveur";
        _buttonClick = false;
      }
    } on dio.DioException catch (_) {
      _buttonClick = false;
      _errorMessage = "Identifiants incorrectes";
      _error = true;
    }
    notifyListeners();
  }

  Future<void> userInfo() async {
    final localStorage = await SharedPreferences.getInstance();
    final tok = localStorage.getString('token');
    final response = await http.get(UrL.user, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer $tok"
    });
    if (response.statusCode == 200) {
      try {
        _investisseur = User(
            id: jsonDecode(response.body)["data"]['id'],
            nom: jsonDecode(response.body)["data"]['nom'],
            prenom: jsonDecode(response.body)["data"]['prenoms'],
            email: jsonDecode(response.body)["data"]['email'],
            lieuHabitation: jsonDecode(response.body)["data"]
                ['lieu_habitation'],
            picture: jsonDecode(response.body)["data"]['picture'] ?? '',
            identity: jsonDecode(response.body)["data"]['identity'] ?? '',
            bankcard: jsonDecode(response.body)["data"]['bank_card'] ?? '',
            password: investisseur.password,
            phone: jsonDecode(response.body)["data"]['phone'] ?? '',
            solde: jsonDecode(response.body)["data"]['solde']);
        _error = false;
        _errorMessage = "";
        _buttonClick = false;
      } catch (e) {
        _error = true;
        _errorMessage = e.toString();
        _buttonClick = false;
      }
    } else {
      _error = true;
      _errorMessage = "Problème au niveau de la connexion au serveur";
      _buttonClick = false;
    }
    notifyListeners();
  }
}
