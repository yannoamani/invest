import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInfo extends ChangeNotifier {
  bool _isOnline = false;
  String _userToken = "";
  int _userId = 0;
  SharedPreferences? _connexionState, _token, _id;
  bool get isOnline => _isOnline;
  String get userToken => _userToken;
  int get userId => _userId;

  _initialState() async {
    _connexionState ??= await SharedPreferences.getInstance();
    _token ??= await SharedPreferences.getInstance();
    _id ??= await SharedPreferences.getInstance();
  }

  loadState() async {
    await _initialState();
    _isOnline = _connexionState?.getBool("connexionState") ?? false;
    _userToken = _token?.getString("token") ?? "";
    _userId = _id?.getInt("id") ?? 0;
    notifyListeners();
  }

  _saveLoginState() async {
    await _initialState();
    _connexionState?.setBool('connexionState', _isOnline);
    _token?.setString("token", _userToken);
    _id?.setInt("id", _userId);
  }

  _removeConnexionState() async {
    await _connexionState?.remove('connexionState');
    await _token?.remove("token");
    await _id?.remove("id");
  }

  Future login(bool status, String key, int id) async {
    _isOnline = status;
    _userToken = key;
    _userId = id;
    await _saveLoginState();
    notifyListeners();
  }

  Future logout() async {
    _isOnline = false;
    _userToken = "";
    _userId = 0;
    await _removeConnexionState();
    notifyListeners();
  }
}
