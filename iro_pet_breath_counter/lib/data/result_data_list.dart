import 'dart:convert';

import 'package:iro_pet_breath_counter/data/result_data.dart';

class ResultDataList {
  final List<ResultData> _resultDataList;

  ResultDataList(
    this._resultDataList,
  );

  factory ResultDataList.fromJson(String jsonString) {
    List<dynamic> listFromJson = json.decode(jsonString);
    List<ResultData> resultDataList = listFromJson
        .map((resultData) => ResultData.fromJson(resultData))
        .toList();
    return ResultDataList(resultDataList);
  }

  String toJson() {
    return json.encode(_resultDataList);
  }

  static String addResultDataToJson(String jsonString, ResultData resultData) {
    List<dynamic> listToJson = json.decode(jsonString);
    listToJson.add(resultData.toJson());
    return json.encode(listToJson);
  }

  List<ResultData> getResultDataList() => _resultDataList;
}
