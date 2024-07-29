import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iro_pet_breath_counter/data/json_storage.dart';
import 'package:iro_pet_breath_counter/data/option.dart';
import 'package:iro_pet_breath_counter/data/pet_data.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';
import 'package:iro_pet_breath_counter/provider/option_provider.dart';
import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/result_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_result_provider.dart';
import 'package:iro_pet_breath_counter/view/notification_service.dart';
import 'package:iro_pet_breath_counter/view/pet_data_page.dart';
import 'package:iro_pet_breath_counter/view/pet_page.dart';
import 'package:iro_pet_breath_counter/view/counter_page.dart';
import 'package:iro_pet_breath_counter/view/result_data_page.dart';
import 'package:iro_pet_breath_counter/view/result_page.dart';
import 'package:iro_pet_breath_counter/view/graph_page.dart';
import 'package:iro_pet_breath_counter/view/option_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectedPetProvider>(
          create: (_) => SelectedPetProvider(),
        ),
        ChangeNotifierProvider<PetDataListProvider>(
          create: (_) => PetDataListProvider(),
        ),
        ChangeNotifierProvider<ResultDataListProvider>(
          create: (_) => ResultDataListProvider(),
        ),
        ChangeNotifierProvider<SelectedResultProvider>(
          create: (_) => SelectedResultProvider(),
        ),
        ChangeNotifierProvider<OptionProvider>(
          create: (_) => OptionProvider(),
        ),
      ],
      child: const IroPetBreathCounterApp(),
    ),
  );

  await _initNotiSetting();
}

Future<void> _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}

class IroPetBreathCounterApp extends StatelessWidget {
  const IroPetBreathCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: '이로동물의료센터', home: IroMainPage());
  }
}

class IroMainPage extends StatefulWidget {
  const IroMainPage({super.key});

  @override
  State<IroMainPage> createState() => _IroMainPageState();
}

class _IroMainPageState extends State<IroMainPage> {
  int _selectedIndex = 0;
  bool _isSettingTapped = false;

  bool _isAddPetDataTapped = false;
  bool _isEditPetDataTapped = false;

  bool _isAddResultDataTapped = false;
  bool _isEditResultDataTapped = false;

  bool _isBackIconPop = false;
  bool _isPermission = false;

  late PetDataListProvider petDataListProvider;
  late SelectedPetProvider selectedPetProvider;
  late ResultDataListProvider resultDataListProvider;
  late SelectedResultProvider selectedResultProvider;
  late OptionProvider optionProvider;

  late CounterPage counterPage;
  late GraphPage graphPage;

  Widget _bodyWidgetOptions(int index) {
    if (_isSettingTapped) {
      return OptionPage(
        onBackIconTapped: _onBackIconTapped,
      );
    } else if (_isAddPetDataTapped) {
      return PetDataPage(
        updateState: _onItemTapped,
        isAddingData: true,
      );
    } else if (_isEditPetDataTapped) {
      return PetDataPage(
        updateState: _onItemTapped,
        isAddingData: false,
      );
    } else if (_isAddResultDataTapped) {
      return ResultDataPage(
        updateState: _onItemTapped,
        isAddingData: true,
      );
    } else if (_isEditResultDataTapped) {
      return ResultDataPage(
        updateState: _onItemTapped,
        isAddingData: false,
      );
    } else {
      switch (index) {
        case 0:
          return PetPage(
            updateState: _onItemTapped,
            onEditTapped: _onEditPetDataTapped,
          );
        case 1:
          return counterPage;
        case 2:
          return ResultPage(
              updateState: _onItemTapped,
              onEditTapped: _onEditResultDataTapped);
        case 3:
          return graphPage;
        default:
          return const Text('Error');
      }
    }
  }

  final List<Widget> _appBarWidgetOptions = <Widget>[
    const Text('반려동물 선택'),
    const Text('호흡 측정'),
    const Text('결과 보기'),
    const Text('그래프 보기'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _isSettingTapped = false;
      _isAddPetDataTapped = false;
      _isEditPetDataTapped = false;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = false;
      _isBackIconPop = false;
      _selectedIndex = index;
    });
  }

  void _onOptionTapped() {
    setState(() {
      _isSettingTapped = true;
      _isAddPetDataTapped = false;
      _isEditPetDataTapped = false;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = false;
      _isBackIconPop = true;
    });
  }

  void _onAddPetDataTapped() {
    setState(() {
      selectedPetProvider
          .setTempIndex(petDataListProvider.getPetDataList().length);
      _isSettingTapped = false;
      _isAddPetDataTapped = true;
      _isEditPetDataTapped = false;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = false;
      _isBackIconPop = true;
    });
  }

  void _onEditPetDataTapped(int index) {
    setState(() {
      selectedPetProvider.setTempIndex(index);
      _isSettingTapped = false;
      _isAddPetDataTapped = false;
      _isEditPetDataTapped = true;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = false;
      _isBackIconPop = true;
    });
  }

  void _onAddResultDataTapped() {
    setState(() {
      if (petDataListProvider.getPetDataList().isNotEmpty) {
        int id = selectedPetProvider.getID();
        resultDataListProvider.initResultDataListByID(id);
        if (resultDataListProvider.getResultDataListByID()[id] != null) {
          selectedResultProvider.setTempIndex(
              resultDataListProvider.getResultDataListByID()[id]!.length);
        }
        _isSettingTapped = false;
        _isAddPetDataTapped = false;
        _isEditPetDataTapped = false;
        _isAddResultDataTapped = true;
        _isEditResultDataTapped = false;
        _isBackIconPop = true;
      }
    });
  }

  void _onEditResultDataTapped(int index) {
    setState(() {
      selectedResultProvider.setIndex(index);
      _isSettingTapped = false;
      _isAddPetDataTapped = false;
      _isEditPetDataTapped = false;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = true;
      _isBackIconPop = true;
    });
  }

  void _onBackIconTapped() {
    setState(() {
      _isSettingTapped = false;
      _isAddPetDataTapped = false;
      _isEditPetDataTapped = false;
      _isAddResultDataTapped = false;
      _isEditResultDataTapped = false;
      _isBackIconPop = false;
    });
  }

  void _onDeletePetIconTapped() {
    setState(() {
      int index = selectedPetProvider.getIndex();
      int tempIndex = selectedPetProvider.getTempIndex();
      List<PetData> petDataList = petDataListProvider.getPetDataList();
      List<ResultData> resultDataList =
          resultDataListProvider.getResultDataList();
      int petID = petDataList.elementAt(tempIndex).id;

      if (resultDataList.isNotEmpty) {
        debugPrint('----');
        for (int idx = resultDataList.length - 1; idx >= 0; idx--) {
          debugPrint('$idx');
          if (petID == resultDataList.elementAt(idx).id) {
            resultDataList.removeAt(idx);
          }
        }
      }
      resultDataListProvider.updateListToJson();

      petDataList.removeAt(selectedPetProvider.getTempIndex());
      petDataListProvider.updateListToJson();
      if (petDataList.isNotEmpty) {
        if (index >= tempIndex) {
          if (index != 0) {
            index -= 1;
          }
          int id = petDataList.elementAt(index).id;
          selectedPetProvider.setIndex(index, id);
        }
      }
      _onItemTapped(0);
    });
  }

  void _onDeleteResultIconTapped() {
    setState(() {
      List<ResultData> resultDataList =
          resultDataListProvider.getResultDataList();
      int id = selectedPetProvider.getID();
      int index = selectedResultProvider.getIndex();
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
      resultDataList.removeAt(iter);
      resultDataListProvider.updateListToJson();
      _onItemTapped(2);
    });
  }

  Future<bool> callPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.notification,
    ].request();

    if (statuses.values.every((element) => element.isGranted)) {
      return true;
    } else {
      return false;
    }
  }

  void initFile() async {
    await JsonStorage('option.json').createFile();
    await JsonStorage('pet_data.json').createFile();
    await JsonStorage('result_data.json').createFile();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermission) {
      _isPermission = true;
      // ignore: unrelated_type_equality_checks
      if (callPermissions() == false) {
        _isPermission = false;
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
      }
    }

    initFile();
    petDataListProvider = Provider.of<PetDataListProvider>(context);
    selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    resultDataListProvider = Provider.of<ResultDataListProvider>(context);
    selectedResultProvider = Provider.of<SelectedResultProvider>(context);
    optionProvider = Provider.of<OptionProvider>(context);

    optionProvider.readOption();
    petDataListProvider.readPetDataList();
    resultDataListProvider.readResultDataList();

    DateTime date = DateTime.now();
    Option option = optionProvider.getOption();
    if (option.alarm != 0) {
      if (option.alarm == 2) {
        date =
            date.subtract(Duration(days: date.weekday - option.alarmDay - 1));
      }
      int year = date.year;
      int month = date.month;
      int day = date.day;
      int hour = int.parse(option.alarmTime.split(':')[0]);
      int minute = int.parse(option.alarmTime.split(':')[1]);
      date = DateTime(year, month, day, hour, minute);
      NotificationService.sendLocalNotificationDateTime(
        idx: 0,
        date: date,
        title: '심박수를 측정해주세요!',
        content: '애완동물의 심박수를 측정해야 합니다.',
        isWeek: (option.alarm == 2),
      );
    } else {
      NotificationService.clear();
    }

    counterPage = CounterPage(
      updateState: _onItemTapped,
    );
    graphPage = const GraphPage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        leading: (() {
          if (!_isBackIconPop) {
            return null;
          } else {
            return IconButton(
              icon: const Icon(Icons.arrow_circle_left_outlined),
              onPressed: _onBackIconTapped,
            );
          }
        })(),
        title: (() {
          if (_isSettingTapped) {
            return const Text('설정');
          } else if (_isAddPetDataTapped) {
            return const Text('반려동물 추가');
          } else if (_isEditPetDataTapped) {
            return const Text('반려동물 편집');
          } else if (_isAddResultDataTapped) {
            return const Text('결과 추가');
          } else if (_isEditResultDataTapped) {
            return const Text('결과 편집');
          } else {
            return _appBarWidgetOptions.elementAt(_selectedIndex);
          }
        })(),
        centerTitle: false,
        actions: [
          (() {
            if (_isEditPetDataTapped) {
              return IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: _onDeletePetIconTapped,
              );
            } else if (_isEditResultDataTapped) {
              return IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: _onDeleteResultIconTapped,
              );
            } else {
              return const Text('');
            }
          })(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _onOptionTapped,
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        child: _bodyWidgetOptions(_selectedIndex),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: '반려동물',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: '측정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '결과',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: '그래프',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: (() {
        if ((!_isSettingTapped) &&
            (!_isAddPetDataTapped && !_isEditPetDataTapped) &&
            (!_isAddResultDataTapped && !_isEditResultDataTapped)) {
          if (_selectedIndex == 0) {
            return FloatingActionButton(
              backgroundColor: Colors.amber[800],
              onPressed: _onAddPetDataTapped,
              child: const Icon(Icons.add),
            );
          } else if (_selectedIndex == 2) {
            return SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              visible: true,
              curve: Curves.bounceIn,
              backgroundColor: Colors.amber[800],
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  label: '수동 추가',
                  labelStyle: const TextStyle(
                    fontSize: 13,
                  ),
                  backgroundColor: Colors.amber[800],
                  labelBackgroundColor: Colors.amber[800],
                  onTap: _onAddResultDataTapped,
                ),
                SpeedDialChild(
                  child: const Icon(Icons.timer),
                  label: '측정',
                  labelStyle: const TextStyle(
                    fontSize: 13,
                  ),
                  backgroundColor: Colors.amber[800],
                  labelBackgroundColor: Colors.amber[800],
                  onTap: () {
                    _onItemTapped(1);
                  },
                ),
              ],
            );
          }
        }
      })(),
    );
  }
}
