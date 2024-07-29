import 'dart:convert';

import 'package:iro_pet_breath_counter/data/pet_data.dart';

class PetDataList {
  final List<PetData> _petDataList;

  PetDataList(
    this._petDataList,
  );

  factory PetDataList.fromJson(String jsonString) {
    List<dynamic> listFromJson = json.decode(jsonString);
    List<PetData> petDataList =
        listFromJson.map((petData) => PetData.fromJson(petData)).toList();
    return PetDataList(petDataList);
  }

  String toJson() {
    return json.encode(_petDataList);
  }

  static String addPetDataToJson(String jsonString, PetData petData) {
    List<dynamic> listToJson = json.decode(jsonString);
    listToJson.add(petData.toJson());
    return json.encode(listToJson);
  }

  List<PetData> getPetDataList() => _petDataList;
}
