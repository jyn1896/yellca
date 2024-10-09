import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _nickname;
  String? _profileImagePath;

  bool get isLoggedIn => _isLoggedIn;
  String? get nickname => _nickname;
  String? get profileImagePath => _profileImagePath;

  void login(String nickname, String profileImagePath) {
    _isLoggedIn = true;
    _nickname = nickname;
    _profileImagePath = profileImagePath;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _nickname = null;
    _profileImagePath = null;
    notifyListeners();
  }
}
