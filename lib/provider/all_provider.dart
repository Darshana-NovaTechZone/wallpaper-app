import 'package:flutter/material.dart';
import 'package:wall_app/Color/color.dart';

class ProviderS with ChangeNotifier {
  int _selected = 0;
  int get selected => _selected;

  set selected(int p) {
    _selected = p;
    notifyListeners();
  }

  Color _pbackground = background;
  Color get pbackground => _pbackground;

  set pbackground(Color i) {
    _pbackground = i;
    notifyListeners();
  }

  Color _pfont = white1;
  Color get pfont => _pfont;

  set pfont(Color i) {
    _pfont = i;
    notifyListeners();
  }

  Color _pfont2 = white2;
  Color get pfont2 => _pfont2;

  set pfont2(Color i) {
    _pfont2 = i;
    notifyListeners();
  }

  Color _appbarColor = appbarDark;
  Color get appbarColor => _appbarColor;

  set appbarColor(Color i) {
    _appbarColor = i;
    notifyListeners();
  }

  Color _pnaveColor = navColor;
  Color get pnaveColor => _pnaveColor;

  set pnaveColor(Color i) {
    _pnaveColor = i;
    notifyListeners();
  }

  Color _pMenuColor = menuD;
  Color get pMenuColor => _pMenuColor;

  set pMenuColor(Color i) {
    _pMenuColor = i;
    notifyListeners();
  }

  int _columnIndex = 3;
  int get columnIndex => _columnIndex;

  set columnIndex(int i) {
    _columnIndex = i;
    notifyListeners();
  }
}

// task--------------------------------------------------
