import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/provider/result_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_result_provider.dart';
import 'package:iro_pet_breath_counter/view/empty_page.dart';
import 'package:iro_pet_breath_counter/view/result_data_card.dart';
import 'package:iro_pet_breath_counter/view/select_pet_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';

class ResultPage extends StatefulWidget {
  final dynamic updateState;
  final dynamic onEditTapped;
  const ResultPage(
      {super.key, required this.updateState, required this.onEditTapped});

  @override
  State<ResultPage> createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    final selectedResultProvider = Provider.of<SelectedResultProvider>(context);
    final petDataList =
        Provider.of<PetDataListProvider>(context).getPetDataList();
    final resultDataList = Provider.of<ResultDataListProvider>(context)
        .getResultDataListByID()[selectedPetProvider.getID()];

    if (petDataList.isEmpty) {
      return const Scaffold(
        body: EmptyPage(text: '선택된 반려동물이 없습니다\n반려동물 창에서 +를 눌러 반려동물을 추가하세요'),
      );
    } else {
      String titleText =
          '[${petDataList.elementAt(selectedPetProvider.getIndex()).name}]의 기록(${(resultDataList == null) ? 0 : resultDataList.length}개)을 봅니다';

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
        body: (() {
          if (resultDataList == null) {
            return const EmptyPage(
                text: '반려동물의 호흡 데이터가 없습니다\n결과 창에서 +를 눌러 데이터를 추가하세요');
          } else {
            return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: resultDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (() {
                      setState(() {
                        selectedResultProvider.setIndex(index);
                      });
                    }),
                    child: ResultDataCard(
                      data: resultDataList.elementAt(index),
                      onEditTapped: () {
                        selectedResultProvider.setIndex(index);
                        widget.onEditTapped(index);
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                });
          }
        })(),
      );
    }
  }
}
