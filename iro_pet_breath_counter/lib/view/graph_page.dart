import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';
import 'package:iro_pet_breath_counter/provider/option_provider.dart';
import 'package:iro_pet_breath_counter/provider/result_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/view/empty_page.dart';
import 'package:iro_pet_breath_counter/view/select_pet_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';

enum GraphType {
  monthly,
  weekly,
  daily,
}

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  GraphType _graphType = GraphType.daily;
  late List<ResultData>? _resultDataList;
  late double _minX;
  late double _maxX;
  late double _minY;
  late double _maxY;
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final List<bool> _selectedGraph = <bool>[true, false];

  void setGraphType(int index) {
    if (index == 2) {
      _graphType = GraphType.monthly;
    } else if (index == 1) {
      _graphType = GraphType.weekly;
    } else {
      _graphType = GraphType.daily;
    }
  }

  @override
  Widget build(BuildContext context) {
    final petDataList =
        Provider.of<PetDataListProvider>(context).getPetDataList();
    final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    final resultDataListProvider = Provider.of<ResultDataListProvider>(context);
    final optionProvider = Provider.of<OptionProvider>(context);

    setGraphType(optionProvider.getOption().graph);

    if (petDataList.isEmpty) {
      return const Scaffold(
        body: EmptyPage(text: '선택된 반려동물이 없습니다\n반려동물 창에서 +를 눌러 반려동물을 추가하세요'),
      );
    } else {
      String titleText =
          '[${petDataList.elementAt(selectedPetProvider.getIndex()).name}]의 기록을 봅니다';

      _resultDataList = List<ResultData>.empty(growable: true);
      List<ResultData>? temp = resultDataListProvider
          .getResultDataListByID()[selectedPetProvider.getID()];
      if (temp != null) {
        if (_graphType == GraphType.daily) {
          for (var element in temp) {
            int year = int.parse(element.date.split('-')[0]);
            int month = int.parse(element.date.split('-')[1]);
            int day = int.parse(element.date.split('-')[2]);
            if (year == _date.year &&
                month == _date.month &&
                day == _date.day) {
              _resultDataList!.add(element);
            }
          }
        } else if (_graphType == GraphType.weekly) {
          for (var element in temp) {
            int year = int.parse(element.date.split('-')[0]);
            int month = int.parse(element.date.split('-')[1]);
            int day = int.parse(element.date.split('-')[2]);
            DateTime date = DateTime(year, month, day);

            DateTime minday = _date.subtract(Duration(days: _date.weekday - 1));
            DateTime maxday = _date.subtract(Duration(days: _date.weekday - 7));
            if (minday.millisecondsSinceEpoch <= date.millisecondsSinceEpoch &&
                maxday.millisecondsSinceEpoch >= date.millisecondsSinceEpoch) {
              _resultDataList!.add(element);
            }
          }
        } else {
          // _graphType == GraphType.monthly
          for (var element in temp) {
            int year = int.parse(element.date.split('-')[0]);
            int month = int.parse(element.date.split('-')[1]);
            if (year == _date.year && month == _date.month) {
              _resultDataList!.add(element);
            }
          }
        }
      }

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
          canTap: true,
        ),
        body: Scaffold(
          body: (() {
            if (_resultDataList == null) {
              return const EmptyPage(
                  text: '반려동물의 호흡 데이터가 없습니다\n결과 창에서 +를 눌러 데이터를 추가하세요');
            } else {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _date = selectedDate;
                                });
                              }
                            },
                            child: Text(
                                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
                          ),
                        ),
                        ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _selectedGraph.length; i++) {
                                _selectedGraph[i] = (i == index);
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.black,
                          selectedColor: Colors.black,
                          fillColor: Colors.amber[800],
                          borderColor: Colors.black,
                          color: Colors.black,
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: _selectedGraph,
                          children: const [
                            Text('분당 호흡 수'),
                            Text('무게'),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: (() {
                        return LineChart(
                          chart(),
                        );
                      })(),
                    ),
                  ],
                ),
              );
            }
          })(),
        ),
      );
    }
  }

  LineChartData chart() {
    int maxBreath = 0;
    int minBreath = 0xffffffff;
    int maxWeight = 0;
    int minWeight = 0xffffffff;

    for (ResultData value in _resultDataList!) {
      if (int.parse(value.breathPerMinute) > maxBreath) {
        maxBreath = int.parse(value.breathPerMinute);
      }
      if (int.parse(value.breathPerMinute) < minBreath) {
        minBreath = int.parse(value.breathPerMinute);
      }
      if (int.parse(value.weight) > maxWeight) {
        maxWeight = int.parse(value.weight);
      }
      if (int.parse(value.weight) < minWeight) {
        minWeight = int.parse(value.weight);
      }
    }

    if (_graphType == GraphType.daily) {
      _minX = DateTime(_date.year, _date.month, _date.day)
          .millisecondsSinceEpoch
          .toDouble();
      _maxX = DateTime(_date.year, _date.month, _date.day, 24, 0, 0)
          .millisecondsSinceEpoch
          .toDouble();
    } else if (_graphType == GraphType.weekly) {
      DateTime monday = _date.subtract(Duration(days: _date.weekday));
      DateTime sunday = _date.subtract(Duration(days: _date.weekday - 8));
      _minX = monday.millisecondsSinceEpoch.toDouble();
      _maxX = DateTime(sunday.year, sunday.month, sunday.day, 24, 0, 0)
          .millisecondsSinceEpoch
          .toDouble();
    } else {
      // _graphType == GraphType.monthly
      _minX = DateTime(_date.year, _date.month, 1)
          .millisecondsSinceEpoch
          .toDouble();
      _maxX = DateTime(_date.year, _date.month + 1, 0)
          .millisecondsSinceEpoch
          .toDouble();
    }
    if (_selectedGraph[0] == true) {
      _minY = minBreath - 1;
      _maxY = maxBreath + 1;
    } else {
      _minY = minWeight - 1;
      _maxY = maxWeight + 1;
    }

    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
      ),
      borderData: FlBorderData(
        border: const Border(
          bottom: BorderSide(),
          left: BorderSide(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: (() {
            if (_selectedGraph[0] == true) {
              return _resultDataList!
                  .map((data) => FlSpot(data.getTime().toDouble(),
                      double.parse(data.breathPerMinute)))
                  .toList();
            } else {
              return _resultDataList!
                  .map((data) => FlSpot(
                      data.getTime().toDouble(), double.parse(data.weight)))
                  .toList();
            }
          })(),
          isCurved: false,
          dotData: const FlDotData(
            show: true,
          ),
          color: Colors.amber[800],
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: _bottomTitles,
        ),
        leftTitles: AxisTitles(
          axisNameWidget: (() {
            if (_selectedGraph[0] == true) {
              return const Text('분당 호흡 수 (회/분)');
            } else {
              return const Text('무게 (kg)');
            }
          })(),
          sideTitles: _leftTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
    );
  }

  Widget bottomTitlesWidget(double value, TitleMeta meta) {
    String text;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    if (_graphType == GraphType.daily) {
      if (date.hour % 4 == 0 && date.hour != 0) {
        text = '${date.hour}:00';
      } else {
        text = '';
      }
    } else if (_graphType == GraphType.weekly) {
      if (date.day != _date.subtract(Duration(days: _date.weekday)).day &&
          date.day != _date.subtract(Duration(days: _date.weekday - 8)).day &&
          date.day != _date.subtract(Duration(days: _date.weekday - 9)).day) {
        text = '${date.month}/${date.day}';
      } else {
        text = '';
      }
    } else {
      // _graphType == GraphType.monthly
      if (date.day % 5 == 0 && date.day != 30) {
        text = '${date.month}/${date.day}';
      } else {
        text = '';
      }
    }

    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        getTitlesWidget: bottomTitlesWidget,
        interval: (() {
          if (_graphType == GraphType.daily) {
            return 3.6e+6;
          } else if (_graphType == GraphType.weekly) {
            return 8.64e+7;
          } else {
            // _graphType == GraphType.monthly
            return 8.64e+7;
          }
        })(),
        showTitles: true,
      );

  Widget leftTitlesWidget(double value, TitleMeta meta) {
    String text;
    if (value != _minY && value != _maxY) {
      text = '${value.toInt()}';
    } else {
      text = '';
    }

    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  SideTitles get _leftTitles => SideTitles(
        getTitlesWidget: leftTitlesWidget,
        interval: 1,
        showTitles: true,
      );
}
