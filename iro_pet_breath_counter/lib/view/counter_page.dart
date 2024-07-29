import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/provider/option_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/view/counter_result_page.dart';
import 'package:iro_pet_breath_counter/view/empty_page.dart';
import 'package:iro_pet_breath_counter/view/select_pet_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';
import 'package:vibration/vibration.dart';

class CounterPage extends StatefulWidget {
  final dynamic updateState;
  const CounterPage({super.key, required this.updateState});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  int _initMinute = 0;
  int _initSecond = 30;
  int _breathCount = 1;
  int _leftMinute = 0;
  int _leftSecond = 0;
  bool _isRunning = false;
  bool _isFinished = false;
  int _alertType = 0;

  void setIsFinished(bool isFinished) {
    _isFinished = isFinished;
  }

  void setInitTime(int initMinute, int initSecond) {
    _initMinute = initMinute;
    _initSecond = initSecond;
  }

  void _initTimer() {
    _leftMinute = _initMinute;
    _leftSecond = _initSecond;
  }

  void alert() {
    if (_alertType == 1) {
      // 0.5초간 진동
      Vibration.vibrate(duration: 500);
    } else if (_alertType == 2) {
      // 소리 넣기
    } else {
      // 알림 없음
    }
  }

  void _startTimer() {
    if (!_isRunning) {
      alert();
      _breathCount = 1;
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_leftMinute == 0 && _leftSecond == 0) {
            _stopTimer();
            _resetTimer();
            alert();
            _isFinished = true;
          } else {
            if (_leftSecond == 0) {
              _leftMinute--;
              _leftSecond = 59;
            } else {
              _leftSecond--;
            }
          }
        });
      });
    } else {
      _breathCount++;
    }
  }

  void _stopTimer() {
    _isRunning = false;
    _stopwatch.stop();
    _timer.cancel();
  }

  void _resetTimer() {
    _isRunning = false;
    _stopwatch.reset();
    _initTimer();
  }

  @override
  void dispose() {
    if (_isRunning) {
      _stopTimer();
      _resetTimer();
    }
    super.dispose();
  }

  String _timeToString(int minutes, int seconds) {
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    final petDataList =
        Provider.of<PetDataListProvider>(context).getPetDataList();
    final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    final optionProvider = Provider.of<OptionProvider>(context);

    _alertType = optionProvider.getOption().alert;

    if (optionProvider.getOption().breath == 0) {
      setInitTime(0, 30);
    } else {
      setInitTime(1, 0);
    }

    if (!_isRunning) {
      _initTimer();
    }

    if (petDataList.isEmpty) {
      return const Scaffold(
        body: EmptyPage(text: '선택된 반려동물이 없습니다\n반려동물 창에서 +를 눌러 반려동물을 추가하세요'),
      );
    } else {
      String titleText =
          '[${petDataList.elementAt(selectedPetProvider.getIndex()).name}]의 수면 중 호흡수를 측정 중입니다';

      return Scaffold(
        appBar: SelectPetAppBar(
          appBar: AppBar(
            backgroundColor: Colors.amber[600],
            centerTitle: false,
            title: Text(
              titleText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          canTap: !_isRunning && !_isFinished,
        ),
        body: (() {
          if (!_isFinished) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '반려동물이 조용한 환경에서 깊이 잠들었을 때, 가슴이나 배가 올라갔다 내려오면 아래 버튼을 1회 터치합니다.',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    _timeToString(_leftMinute, _leftSecond),
                    style: const TextStyle(
                      fontSize: 70,
                      color: Colors.grey,
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.amber[800],
                      child: InkWell(
                        splashColor: Colors.amber[900],
                        onTap: _startTimer,
                        child: SizedBox(
                          width: 350,
                          height: 350,
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              '터치하면\n시작됩니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(''),
                ],
              ),
            );
          } else {
            return CounterResultPage(
              initMinute: _initMinute,
              initSecond: _initSecond,
              breathCount: _breathCount,
              setIsFinished: setIsFinished,
              updateState: widget.updateState,
            );
          }
        })(),
      );
    }
  }
}
