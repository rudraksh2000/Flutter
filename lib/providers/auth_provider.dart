// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    // it will return true only if token is not equal to null.
    return token != null;
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    const params = {
      'key': 'AIzaSyD1SRfu6a0R3NerMhc2PQk1t6uwdqUGQXU',
    };
    final url = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:$urlSegment', params);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      // we want to handle the exception for this using our custom exception
      // handler.
      // here if we print some error message we get the error key having message
      // key therefore to fetch the message we want to get the the value of
      // message key.
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // these all data are mentioned in Response payload in REST API flutter.
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // we get expiresIn as seconds and as String we want to parse in
      // accordingly.
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      preferences.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    // we can use remove also but since we only have userData we can clear
    // sharedPreferences.
    preferences.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final userTimeExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: userTimeExpiry), logout);
  }
}
