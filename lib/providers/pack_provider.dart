import 'dart:convert';

import 'package:invest_mobile/util/url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PackProvider extends ChangeNotifier {
  bool _error = false;
  String _errorMessage = "";
  bool _isLoad = true;
  List<dynamic> _pack = [];

  // ignore: unnecessary_getters_setters
  bool get isLoad => _isLoad;
  bool get error => _error;
  String get errorMessage => _errorMessage;
  List<dynamic> get pack => _pack;

  set isLoad(bool value) {
    _isLoad = value;
  }

  Future<void> loadPack() async {
    try {
      final response = await http.get(UrL.listPack, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 10));
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
        }
      } else {
        _error = true;
        _errorMessage = "Problème au niveau de la connexion au serveur";
        _isLoad = false;
      }
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
      _isLoad = false;
    }
    notifyListeners();
  }
}
