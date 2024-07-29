import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/json_storage.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';
import 'package:iro_pet_breath_counter/data/result_data_list.dart';

class ResultDataListProvider with ChangeNotifier {
  final List<ResultData> _resultDataList =
      List<ResultData>.empty(growable: true);
  final Map<int, List<ResultData>> _resultDataListByID = {};
  final JsonStorage jsonStorage = JsonStorage('result_data.json');

  Future<void> readResultDataList() async {
    String data = '';
    jsonStorage.readFile().then((value) {
      data = value;
      if (data != '') {
        _resultDataList.clear();
        _resultDataList
            .addAll(ResultDataList.fromJson(data).getResultDataList());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateListToJson() {
    jsonStorage.writeFile(ResultDataList(_resultDataList).toJson());
  }

  void addResultDataToList(ResultData resultData) {
    _resultDataList.add(resultData);
    updateListToJson();
  }

  List<ResultData> getResultDataList() {
    readResultDataList();
    return _resultDataList;
  }

  void initResultDataListByID(int id) {
    if (!_resultDataListByID.containsKey(id)) {
      _resultDataListByID[id] = List<ResultData>.empty(growable: true);
    }
  }

  Map<int, List<ResultData>> getResultDataListByID() {
    _resultDataListByID.clear();
    readResultDataList();
    for (var element in _resultDataList) {
      initResultDataListByID(element.id);
      _resultDataListByID[element.id]?.add(element);
      _resultDataListByID[element.id]!
          .sort((a, b) => a.getTime().compareTo(b.getTime()));
    }
    return _resultDataListByID;
  }
}
