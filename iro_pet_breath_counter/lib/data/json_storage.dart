import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class JsonStorage {
  final String _filename;
  late String _path;
  late File _file;

  JsonStorage(this._filename) {
    init();
  }

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _path = directory.path;
  }

  Future<void> createFile() async {
    try {
      await init();
      File('$_path/json/$_filename').create(recursive: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> readFile() async {
    try {
      await init();
      _file = File('$_path/json/$_filename');
      _file.create(recursive: true);
      final data = await _file.readAsString();
      return data;
    } catch (e) {
      //return e.toString();
      return '';
    }
  }

  Future<void> writeFile(String data) async {
    try {
      readFile();
      await _file.writeAsString(data, mode: FileMode.writeOnly, flush: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
