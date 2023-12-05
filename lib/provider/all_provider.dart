import 'package:flutter/material.dart';

class ProviderS with ChangeNotifier {
  int _selected = 0;
  int get selected => _selected;

  set selected(int p) {
    _selected = p;
    notifyListeners();
  }
}

// task--------------------------------------------------
