import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:iro_pet_breath_counter/view/empty_page.dart';
import 'package:iro_pet_breath_counter/view/pet_data_card.dart';
import 'package:provider/provider.dart';

class PetPage extends StatefulWidget {
  final dynamic updateState;
  final dynamic onEditTapped;
  const PetPage(
      {super.key, required this.updateState, required this.onEditTapped});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (() {
        final petDataList =
            Provider.of<PetDataListProvider>(context).getPetDataList();
        final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
        if (petDataList.isEmpty) {
          return const EmptyPage(
              text: '선택된 반려동물이 없습니다\n반려동물 창에서 +를 눌러 반려동물을 추가하세요');
        } else {
          return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: petDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (() {
                    setState(() {
                      int id = petDataList.elementAt(index).id;
                      selectedPetProvider.setIndex(index, id);
                      widget.updateState(1);
                    });
                  }),
                  child: PetDataCard(
                      data: petDataList.elementAt(index),
                      index: index,
                      onEditTapped: widget.onEditTapped),
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
