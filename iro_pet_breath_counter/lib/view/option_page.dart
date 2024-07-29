import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/option.dart';
import 'package:iro_pet_breath_counter/provider/option_provider.dart';
import 'package:provider/provider.dart';

class OptionPage extends StatefulWidget {
  final dynamic onBackIconTapped;
  const OptionPage({
    super.key,
    required this.onBackIconTapped,
  });

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  final double _headlineFontSize = 20;

  final List<bool> _selectedBreathCheckTime = <bool>[false, false];
  int _selectedBreathCheckTimeIndex = 0;
  final List<bool> _selectedGraphType = <bool>[false, false, false];
  int _selectedGraphTypeIndex = 0;
  final List<bool> _selectedCheckStartAlert = <bool>[false, false, false];
  int _selectedCheckStartAlertIndex = 0;
  final List<bool> _selectedAlarm = <bool>[false, false, false];
  int _selectedAlarmIndex = 0;
  final List<bool> _selectedAlarmDay = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  int _selectedAlarmDayIndex = 0;
  String _selectedAlarmTime = '';

  late OptionProvider optionProvider;
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    optionProvider = Provider.of<OptionProvider>(context);
    optionProvider.readOption();

    Option option = optionProvider.getOption();

    if (isOpen) {
      _selectedBreathCheckTimeIndex = option.breath;
      _selectedGraphTypeIndex = option.graph;
      _selectedCheckStartAlertIndex = option.alert;
      _selectedAlarmIndex = option.alarm;
      _selectedAlarmDayIndex = option.alarmDay;
      _selectedAlarmTime = option.alarmTime;
      isOpen = false;
    }

    for (int i = 0; i < _selectedBreathCheckTime.length; i++) {
      if (i == _selectedBreathCheckTimeIndex) {
        _selectedBreathCheckTime[i] = true;
      } else {
        _selectedBreathCheckTime[i] = false;
      }
    }

    for (int i = 0; i < _selectedGraphType.length; i++) {
      if (i == _selectedGraphTypeIndex) {
        _selectedGraphType[i] = true;
      } else {
        _selectedGraphType[i] = false;
      }
    }

    for (int i = 0; i < _selectedCheckStartAlert.length; i++) {
      if (i == _selectedCheckStartAlertIndex) {
        _selectedCheckStartAlert[i] = true;
      } else {
        _selectedCheckStartAlert[i] = false;
      }
    }

    for (int i = 0; i < _selectedAlarm.length; i++) {
      if (i == _selectedAlarmIndex) {
        _selectedAlarm[i] = true;
      } else {
        _selectedAlarm[i] = false;
      }
    }

    for (int i = 0; i < _selectedAlarmDay.length; i++) {
      if (i == _selectedAlarmDayIndex) {
        _selectedAlarmDay[i] = true;
      } else {
        _selectedAlarmDay[i] = false;
      }
    }

    if (_selectedAlarmTime == '') {
      TimeOfDay now = TimeOfDay.now();
      _selectedAlarmTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '호흡수 측정시간',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0;
                          i < _selectedBreathCheckTime.length;
                          i++) {
                        if (i == index) {
                          _selectedBreathCheckTime[i] = true;
                          _selectedBreathCheckTimeIndex = index;
                        } else {
                          _selectedBreathCheckTime[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.black,
                  fillColor: Colors.amber[800],
                  borderColor: Colors.black,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedBreathCheckTime,
                  children: const [
                    Text('30초'),
                    Text('60초'),
                  ],
                ),
                Text(
                  '그래프 보기 설정',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedGraphType.length; i++) {
                        if (i == index) {
                          _selectedGraphType[i] = true;
                          _selectedGraphTypeIndex = index;
                        } else {
                          _selectedGraphType[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.black,
                  fillColor: Colors.amber[800],
                  borderColor: Colors.black,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedGraphType,
                  children: const [
                    Text('일간'),
                    Text('주간'),
                    Text('월간'),
                  ],
                ),
                Text(
                  '측정 시작 및 종료 알림',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0;
                          i < _selectedCheckStartAlert.length;
                          i++) {
                        if (i == index) {
                          _selectedCheckStartAlert[i] = true;
                          _selectedCheckStartAlertIndex = index;
                        } else {
                          _selectedCheckStartAlert[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.black,
                  fillColor: Colors.amber[800],
                  borderColor: Colors.black,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedCheckStartAlert,
                  children: const [
                    Text('없음'),
                    Text('진동'),
                    Text('소리'),
                  ],
                ),
                Text(
                  '알림 기간 설정',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedAlarm.length; i++) {
                        if (i == index) {
                          _selectedAlarm[i] = true;
                          _selectedAlarmIndex = index;
                        } else {
                          _selectedAlarm[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.black,
                  fillColor: Colors.amber[800],
                  borderColor: Colors.black,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedAlarm,
                  children: const [
                    Text('없음'),
                    Text('매일'),
                    Text('일주일'),
                  ],
                ),
                (() {
                  if (_selectedAlarm[2] == true) {
                    return ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedAlarmDay.length; i++) {
                            if (i == index) {
                              _selectedAlarmDay[i] = true;
                              _selectedAlarmDayIndex = index;
                            } else {
                              _selectedAlarmDay[i] = false;
                            }
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.black,
                      fillColor: Colors.amber[800],
                      borderColor: Colors.black,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 30.0,
                        minWidth: 30.0,
                      ),
                      isSelected: _selectedAlarmDay,
                      children: const [
                        Text('월'),
                        Text('화'),
                        Text('수'),
                        Text('목'),
                        Text('금'),
                        Text('토'),
                        Text('일'),
                      ],
                    );
                  } else {
                    return Container();
                  }
                })(),
                (() {
                  if (_selectedAlarm[1] == true || _selectedAlarm[2] == true) {
                    return SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour:
                                    int.parse(_selectedAlarmTime.split(':')[0]),
                                minute: int.parse(
                                    _selectedAlarmTime.split(':')[1])),
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _selectedAlarmTime =
                                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        child: Text(
                          _selectedAlarmTime,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                })(),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[800],
        onPressed: () {
          optionProvider.setOption(Option(
              _selectedBreathCheckTimeIndex,
              _selectedGraphTypeIndex,
              _selectedCheckStartAlertIndex,
              _selectedAlarmIndex,
              _selectedAlarmDayIndex,
              _selectedAlarmTime));
          isOpen = true;
          widget.onBackIconTapped();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        label: const Text('저장'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
