// @dart=2.9
import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'HttpException.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth with ChangeNotifier {
  String _token;
  String _refreshToken;
  DateTime _expiryDate;
  String _userId;
  // Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

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

  Future<void> _authenticate(String email, String password, String urlSegment, String displayName) async {
    await dotenv.load(fileName: ".env");
    String AUTH_KEY = dotenv.env['AUTH_KEY'];
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$AUTH_KEY';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData["refreshToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();

      if (urlSegment == "signUp") {
        final userData = json.encode(
          {
            'token': _token,
            "refreshToken": _refreshToken,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
      }

      //SIGN IN
      if (urlSegment == "signInWithPassword") {
        final userData = json.encode(
          {
            'token': _token,
            "refreshToken": _refreshToken,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
      }
      // _autoLogout();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password, String displayName) async {
    return _authenticate(email, password, 'signUp', displayName);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', "_");
  }


  // Future<bool> tryAutoLogin() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     if (!prefs.containsKey('userData')) {
  //       return false;
  //     }
  //     final extractedUserData =
  //     json.decode(prefs.getString('userData')) as Map<String, dynamic>;
  //     final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
  //
  //     if (expiryDate.isBefore(DateTime.now())) {
  //       String refreshToken = extractedUserData["refreshToken"];
  //       await dotenv.load(fileName: ".env");
  //       String AUTH_KEY = dotenv.env['AUTH_KEY'];
  //       final url =
  //           "https://securetoken.googleapis.com/v1/token?key=$AUTH_KEY";
  //       final response = await http.post(Uri.parse(url),
  //           body: json.encode({
  //             "grant_type": "refresh_token",
  //             "refresh_token": refreshToken
  //           }));
  //       final responseData = json.decode(response.body);
  //       _token = responseData['id_token'];
  //       _userId = responseData['user_id'];
  //       _refreshToken = responseData["refresh_token"];
  //       _expiryDate = DateTime.now().add(
  //         Duration(
  //           seconds: int.parse(
  //             responseData['expires_in'],
  //           ),
  //         ),
  //       );
  //       notifyListeners();
  //       final prefs = await SharedPreferences.getInstance();
  //       final userData = json.encode(
  //         {
  //           'token': _token,
  //           "refreshToken": _refreshToken,
  //           'userId': _userId,
  //           'expiryDate': _expiryDate.toIso8601String(),
  //         },
  //       );
  //       prefs.setString('userData', userData);
  //     } else {
  //       _token = extractedUserData['token'];
  //       _userId = extractedUserData['userId'];
  //       _expiryDate = expiryDate;
  //       notifyListeners();
  //     }
  //     return true;
  //   } catch (error) {
  //     return false;
  //   }
  // }
  //
  // Future<void> logout() async {
  //   _token = null;
  //   _userId = null;
  //   _expiryDate = null;
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //     _authTimer = null;
  //   }
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }
  //
  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
  //
  // Future<void> resetPassword(String email) async {
  //   await dotenv.load(fileName: ".env");
  //   String AUTH_KEY = dotenv.env['AUTH_KEY'];
  //   final url =
  //       "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$AUTH_KEY";
  //   final response = await http.post(Uri.parse(url),
  //       body: json.encode({
  //         'requestType': "PASSWORD_RESET",
  //         "email": email,
  //       }));
  //   final responseData = json.decode(response.body);
  //   if (responseData['error'] != null) {
  //     throw HttpException(responseData['error']['message']);
  //   }
  // }
}