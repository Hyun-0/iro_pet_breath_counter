import 'package:flutter/material.dart';

class SelectedResultProvider with ChangeNotifier {
  int _tempIndex = 0;
  int _index = 0;

  void setTempIndex(int index) {
    _tempIndex = index;
  }

  void setIndex(int index) {
    _tempIndex = _index;
    _index = index;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int getIndex() => _index;

  int getTempIndex() => _tempIndex;
}
