import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiredDate;
  String _userId;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiredDate != null &&
        _expiredDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signing(String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDO9dye1aPUDirBQOLhuGullYCVraMlbu8';
    try {
      final response = await http.post(Uri.parse(url),
          body: convert.json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final decodedResponse = convert.json.decode(response.body);

      if (decodedResponse['error'] != null) {
        print(decodedResponse['error']['message']);
        throw HttpException(decodedResponse['error']['message']);
      }
      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];
      _expiredDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
      autoLogout();

      final prefrs = await SharedPreferences.getInstance();
      final userData = convert.json.encode({
        'token': decodedResponse['idToken'],
        'userId': decodedResponse['localId'],
        'expireDate': DateTime.now().toIso8601String(),
      });

      prefrs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> signIn(String email, String password) async {
    return signing(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return signing(email, password, 'signUp');
  }

  Future<bool> autoTryLogIn() async {
    final prefrs = await SharedPreferences.getInstance();

    if (!prefrs.containsKey('userData')) {
      return false;
    }

    final getPrefsdata = convert.json.decode(prefrs.getString('userData'))
        as Map<String, Object>;
    final expiryDate = DateTime.parse(getPrefsdata['expireDate']);
    if (!expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = getPrefsdata['token'];
    _userId = getPrefsdata['userId'];
    _expiredDate = expiryDate;
    autoLogout();
    notifyListeners();

    return true;
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiredDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiredDate.difference(DateTime.now()).inSeconds;
    print(_expiredDate);
    print(DateTime.now());
    print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
