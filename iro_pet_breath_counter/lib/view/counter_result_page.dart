import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';
import 'package:iro_pet_breath_counter/provider/result_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/view/empty_page.dart';
import 'package:provider/provider.dart';

import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';

class CounterResultPage extends StatefulWidget {
  final int initMinute;
  final int initSecond;
  final int breathCount;
  final dynamic setIsFinished;
  final dynamic updateState;

  const CounterResultPage({
    super.key,
    required this.initMinute,
    required this.initSecond,
    required this.breathCount,
    required this.setIsFinished,
    required this.updateState,
  });

  @override
  State<CounterResultPage> createState() => CounterResultPageState();
}

class CounterResultPageState extends State<CounterResultPage> {
  final TextEditingController _weightTextEditingController =
      TextEditingController();
  final TextEditingController _commentTextEditingController =
      TextEditingController();

  final DateTime _date = DateTime.now();
  final TimeOfDay _time = TimeOfDay.now();
  late String _dateString;
  late String _timeString;
  late String _previousWeight;

  @override
  Widget build(BuildContext context) {
    final petDataList =
        Provider.of<PetDataListProvider>(context).getPetDataList();
    final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    final resultDataListProvider = Provider.of<ResultDataListProvider>(context);

    _dateString =
        '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
    String printDateString =
        '${_date.year}년 ${_date.month.toString().padLeft(2, '0')}월 ${_date.day.toString().padLeft(2, '0')}일';
    _timeString =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    String printTimeString =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

    int breathCount = widget.breathCount;
    int minute = widget.initMinute;
    int second = widget.initSecond;

    int totalSecond = minute * 60 + second;
    int finalBreathCount = (breathCount / totalSecond * 60).floor();

    _previousWeight = '';

    if (petDataList.isEmpty) {
      return const Scaffold(
        body: EmptyPage(text: '반려동물이 존재하지 않습니다'),
      );
    } else {
      List<ResultData>? resultDataList = resultDataListProvider
          .getResultDataListByID()[selectedPetProvider.getID()];
      if (resultDataList != null) {
        _previousWeight =
            resultDataList.elementAt(resultDataList.length - 1).weight;
      }

      return Scaffold(
        body: (() {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$printDateString $printTimeString\n현재 1분당 수면 중 호흡수는',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$finalBreathCount회',
                      style: const TextStyle(
                        fontSize: 130,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      (finalBreathCount < 25) ? '정상입니다' : '비정상입니다',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    TextField(
                      controller: _weightTextEditingController,
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: '몸무게',
                        hintText: (_previousWeight == '')
                            ? '최근 체중 데이터가 없습니다'
                            : '최근 체중은 $_previousWeight입니다',
                        counterText: '',
                      ),
                    ),
                    TextField(
                      controller: _commentTextEditingController,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        labelText: '메모',
                      ),
                    ),
                    const Divider(),
                    const Text(
                      '알고 계신가요?',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      '강아지나 고양이가 잠들었을 때의 호흡수는 분당 15~25회가 정상이며, 30회 이상이거나 지속적으로 증가하는 경우, 심장 질환을 의심할 수 있습니다.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        int id = selectedPetProvider.getID();
                        String breathPerMinute = '$finalBreathCount';
                        String weightString = _weightTextEditingController.text;
                        String weight;
                        if (_previousWeight == '') {
                          weight = (weightString == '') ? '0' : weightString;
                        } else {
                          weight = (weightString == '')
                              ? _previousWeight
                              : weightString;
                        }
                        String comment = _commentTextEditingController.text;

                        ResultData resultData = ResultData(id, breathPerMinute,
                            _dateString, _timeString, weight, comment);
                        resultDataListProvider.addResultDataToList(resultData);
                        widget.updateState(2);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800],
                      ),
                      child: const Text('등록'),
                    ),
                  ],
                ),
              ),
            ),
          );
        })(),
      );
    }
  }
}
