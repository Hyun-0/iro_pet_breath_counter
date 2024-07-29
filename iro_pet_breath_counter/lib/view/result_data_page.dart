import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';
import 'package:iro_pet_breath_counter/provider/result_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_result_provider.dart';
import 'package:provider/provider.dart';

class ResultDataPage extends StatefulWidget {
  final dynamic updateState;
  // isAddingData true: Adding / false: Editing
  final bool isAddingData;
  const ResultDataPage(
      {super.key, required this.updateState, required this.isAddingData});

  @override
  State<ResultDataPage> createState() => _ResultDataPageState();
}

class _ResultDataPageState extends State<ResultDataPage> {
  final double _headlineFontSize = 20;
  final TextEditingController _breathPerMinuteTextEditingController =
      TextEditingController();
  final TextEditingController _weightTextEditingController =
      TextEditingController();
  final TextEditingController _commentTextEditingController =
      TextEditingController();

  late ResultDataListProvider _resultDataListProvider;
  late SelectedPetProvider _selectedPetProvider;
  late SelectedResultProvider _selectedResultProvider;

  late bool _isAddingData;
  bool _initEdit = true;

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    _resultDataListProvider = Provider.of<ResultDataListProvider>(context);
    _selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    _selectedResultProvider = Provider.of<SelectedResultProvider>(context);
    _isAddingData = widget.isAddingData;

    if (_initEdit && !_isAddingData) {
      ResultData resultData = _resultDataListProvider
          .getResultDataListByID()[_selectedPetProvider.getID()]!
          .elementAt(_selectedResultProvider.getIndex());

      _breathPerMinuteTextEditingController.text = resultData.breathPerMinute;
      _weightTextEditingController.text = resultData.weight;
      _commentTextEditingController.text = resultData.comment;
      String date = resultData.date;
      _date = DateTime.utc(int.parse(date.split('-')[0]),
          int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));
      String time = resultData.time;
      _time = TimeOfDay(
          hour: int.parse(time.split(':')[0]) % 24,
          minute: int.parse(time.split(':')[1]) % 60);
      _initEdit = false;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '분당 수면중 호흡수',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _breathPerMinuteTextEditingController,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '분당 수면중 호흡수',
                    counterText: '',
                  ),
                ),
                const Divider(),
                Text(
                  '날짜',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
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
                const Divider(),
                Text(
                  '시간',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _time = selectedTime;
                        });
                      }
                    },
                    child: Text(
                        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}'),
                  ),
                ),
                const Divider(),
                Text(
                  '몸무게',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _weightTextEditingController,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '몸무게',
                    counterText: '',
                  ),
                ),
                const Divider(),
                Text(
                  '메모',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _commentTextEditingController,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: '메모',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber[800],
          onPressed: _onSubmitTapped,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          label: (() {
            if (_isAddingData) {
              return const Text('등록');
            } else {
              return const Text('편집');
            }
          })(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _onSubmitTapped() {
    setState(() {
      if (_isAddingData) {
        String tempBreathPerMinuteText =
            _breathPerMinuteTextEditingController.text;
        String breathPerMinute =
            (tempBreathPerMinuteText == '') ? '0' : tempBreathPerMinuteText;
        String tempWeightText = _weightTextEditingController.text;
        String weight = (tempWeightText == '') ? '0' : tempWeightText;
        String comment = _commentTextEditingController.text;
        String date =
            '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
        String time =
            '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

        ResultData resultData = ResultData(_selectedPetProvider.getID(),
            breathPerMinute, date, time, weight, comment);
        _resultDataListProvider.addResultDataToList(resultData);
      } else {
        List<ResultData> resultDataList =
            _resultDataListProvider.getResultDataList();
        int id = _selectedPetProvider.getID();
        int index = _selectedResultProvider.getIndex();
        int iter = 0;
        for (var element in resultDataList) {
          if (id == element.id) {
            if (index == 0) {
              break;
            }
            index--;
          }
          iter++;
        }
        ResultData resultData = resultDataList.elementAt(iter);
        String tempBreathPerMinuteText =
            _breathPerMinuteTextEditingController.text;
        resultData.breathPerMinute =
            (tempBreathPerMinuteText == '') ? '0' : tempBreathPerMinuteText;
        String tempWeightText = _weightTextEditingController.text;
        resultData.weight = (tempWeightText == '') ? '0' : tempWeightText;
        resultData.comment = _commentTextEditingController.text;
        resultData.date =
            '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
        resultData.time =
            '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

        _resultDataListProvider.updateListToJson();
        _initEdit = true;
      }
      widget.updateState(2);
    });
  }
}
