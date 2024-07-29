import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:provider/provider.dart';

import 'package:iro_pet_breath_counter/data/pet_data.dart';
import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';

class PetDataPage extends StatefulWidget {
  final dynamic updateState;
  // isAddingData true: Adding / false: Editing
  final bool isAddingData;
  const PetDataPage(
      {super.key, required this.updateState, required this.isAddingData});

  @override
  State<PetDataPage> createState() => _PetDataPageState();
}

class _PetDataPageState extends State<PetDataPage> {
  final double _headlineFontSize = 20;
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _ageTextEditingController =
      TextEditingController();
  final TextEditingController _breedTextEditingController =
      TextEditingController();

  late PetDataListProvider _petDataListProvider;
  late SelectedPetProvider _selectedPetProvider;

  late bool _isAddingData;
  bool _initEdit = true;

  final _gender = [
    '수컷',
    '암컷',
  ];
  String _selectedGender = '수컷';

  final _species = [
    '개',
    '고양이',
  ];
  String _selectedSpecies = '개';

  final _neutered = [
    '비중성화',
    '중성화',
  ];
  String _selectedNeutered = '비중성화';

  final ImagePicker picker = ImagePicker();
  String _image = '';

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _petDataListProvider = Provider.of<PetDataListProvider>(context);
    _selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    _isAddingData = widget.isAddingData;

    if (_initEdit && !_isAddingData) {
      PetData petData = _petDataListProvider
          .getPetDataList()
          .elementAt(_selectedPetProvider.getTempIndex());
      _nameTextEditingController.text = petData.name;
      _ageTextEditingController.text = petData.age.toString();
      _breedTextEditingController.text = petData.breed;

      _image = petData.image;
      _selectedGender = (petData.gender) ? '수컷' : '암컷';
      _selectedSpecies = (petData.species) ? '개' : '고양이';
      _selectedNeutered = (petData.isNeutered) ? '중성화' : '비중성화';
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
                  '사진',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: InkWell(
                    radius: 100,
                    onTap: () {
                      // 카메라로 가져오기
                      // getImage(ImageSource.camera);
                      getImage(ImageSource.gallery);
                    },
                    child: (() {
                      if (_image == '') {
                        return const Icon(Icons.crop_original);
                      } else {
                        return Image.file(File(_image));
                      }
                    })(),
                  ),
                ),
                const Divider(),
                Text(
                  '이름',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _nameTextEditingController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                  ),
                ),
                const Divider(),
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  value: _selectedGender,
                  items: _gender
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Divider(),
                Text(
                  '나이',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _ageTextEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '나이',
                  ),
                ),
                const Divider(),
                Text(
                  '분류',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  value: _selectedSpecies,
                  items: _species
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecies = value!;
                    });
                  },
                ),
                const Divider(),
                Text(
                  '품종',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                TextField(
                  controller: _breedTextEditingController,
                  decoration: const InputDecoration(
                    labelText: '품종',
                  ),
                ),
                const Divider(),
                Text(
                  '중성화 여부',
                  style: TextStyle(
                    fontSize: _headlineFontSize,
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  value: _selectedNeutered,
                  items: _neutered
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNeutered = value!;
                    });
                  },
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
        String tempNameText = _nameTextEditingController.text;
        String name = (tempNameText == '') ? '기본 이름' : tempNameText;
        String tempAgeText = _ageTextEditingController.text;
        String age = (tempAgeText == '') ? '나이 미정' : tempAgeText;
        String breed = _breedTextEditingController.text;
        bool species = (_selectedSpecies == '개') ? true : false;
        bool isNeutered = (_selectedNeutered == '중성화') ? true : false;
        bool gender = (_selectedGender == '수컷') ? true : false;

        int finalPetIndex = _petDataListProvider.getPetDataList().length - 1;
        int id = (finalPetIndex >= 0)
            ? _petDataListProvider
                    .getPetDataList()
                    .elementAt(finalPetIndex)
                    .id +
                1
            : 0;
        PetData petData =
            PetData(id, _image, name, age, species, breed, isNeutered, gender);
        _petDataListProvider.addPetDataToList(petData);
      } else {
        PetData petData = _petDataListProvider
            .getPetDataList()
            .elementAt(_selectedPetProvider.getTempIndex());
        petData.name = _nameTextEditingController.text;
        petData.age = _ageTextEditingController.text;
        petData.breed = _breedTextEditingController.text;
        petData.species = (_selectedSpecies == '개') ? true : false;
        petData.isNeutered = (_selectedNeutered == '중성화') ? true : false;
        petData.gender = (_selectedGender == '수컷') ? true : false;
        petData.image = _image;

        _petDataListProvider.updateListToJson();
        _initEdit = true;
      }
      int index = _selectedPetProvider.getTempIndex();
      int id = _petDataListProvider.getPetDataList().elementAt(index).id;
      _selectedPetProvider.setIndex(index, id);
      widget.updateState(0);
    });
  }
}
