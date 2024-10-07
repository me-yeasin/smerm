import 'package:flutter/material.dart';

class Design extends ChangeNotifier {
  bool _isHomePage = true;
  bool _isLcDetailPage = false;
  double _appBarHeight = 0.0;
  List<bool> chassisItemSelectedBoolList = List.generate(4, (index) => false);
  bool showChassisNameForm = false;

  bool get getIsHomePage => _isHomePage;
  set setIsHomePage(bool val) {
    _isHomePage = val;
    notifyListeners();
  }

  bool get getIsLcDetailPage => _isLcDetailPage;
  set setIsLcDetailPage(bool val) {
    _isLcDetailPage = val;
    notifyListeners();
  }

  double get getAppBarHeight => _appBarHeight;
  set setAppBarHeight(double val) {
    _appBarHeight = val;
  }

  Future<void> showSimpleDialog(BuildContext context, Widget dialog) async {
    return showDialog(
        context: context, barrierDismissible: true, builder: (ctx) => dialog);
  }

  void selectChassisItem(int index) {
    chassisItemSelectedBoolList[index] = !chassisItemSelectedBoolList[index];
    if (chassisItemSelectedBoolList[index]) {
      showChassisNameForm = true;
    } else {
      showChassisNameForm = false;
    }
    notifyListeners();
  }
}
