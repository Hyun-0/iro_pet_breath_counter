import 'package:flutter/material.dart';

class SelectedPetProvider with ChangeNotifier {
  int _tempIndex = 0;
  int _index = 0;
  int _id = 0;

  void setTempIndex(int index) {
    _tempIndex = index;
  }

  void setIndex(int index, int id) {
    _tempIndex = _index;
    _index = index;
    _id = id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int getIndex() => _index;

  int getTempIndex() => _tempIndex;

  int getID() => _id;
}
