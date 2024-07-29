import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/json_storage.dart';
import 'package:iro_pet_breath_counter/data/option.dart';

class OptionProvider with ChangeNotifier {
  Option _option = Option(0, 0, 0, 0, 0, '00:00');
  final JsonStorage jsonStorage = JsonStorage('option.json');

  OptionProvider() {
    readOption();
  }

  Future<void> readOption() async {
    String data = '';
    data = await jsonStorage.readFile();
    if (data != '') {
      Map<String, dynamic> jsonData = json.decode(data);
      _option = Option.fromJson(jsonData);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  String _optionToString() {
    return '{"breath":${_option.breath},"graph":${_option.graph},"alert":${_option.alert},"alarm":${_option.alarm},"alarm_day":${_option.alarmDay},"alarm_time":"${_option.alarmTime}"}';
  }

  void updateOptionToJson() {
    jsonStorage.writeFile(_optionToString());
  }

  Option getOption() {
    return _option;
  }

  void setOption(Option option) {
    _option = option;
    updateOptionToJson();
  }
}
