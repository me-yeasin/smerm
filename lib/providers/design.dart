import 'package:flutter/material.dart';

class Design extends ChangeNotifier {
  bool _isHomePage = true;

  bool get getIsHomePage => _isHomePage;
  set setIsHomePage(bool val) {
    _isHomePage = val;
    notifyListeners();
  }
}
