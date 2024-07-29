import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/json_storage.dart';
import 'package:iro_pet_breath_counter/data/pet_data.dart';
import 'package:iro_pet_breath_counter/data/pet_data_list.dart';

class PetDataListProvider with ChangeNotifier {
  final List<PetData> _petDataList = List<PetData>.empty(growable: true);
  final JsonStorage jsonStorage = JsonStorage('pet_data.json');

  Future<void> readPetDataList() async {
    String data = '';
    jsonStorage.readFile().then((value) {
      data = value;
      if (data != '') {
        _petDataList.clear();
        _petDataList.addAll(PetDataList.fromJson(data).getPetDataList());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateListToJson() {
    jsonStorage.writeFile(PetDataList(_petDataList).toJson());
  }

  void addPetDataToList(PetData petData) {
    _petDataList.add(petData);
    updateListToJson();
  }

  List<PetData> getPetDataList() {
    readPetDataList();
    return _petDataList;
  }
}
