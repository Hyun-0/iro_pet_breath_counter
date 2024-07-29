import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/provider/pet_data_list_provider.dart';
import 'package:iro_pet_breath_counter/provider/selected_pet_provider.dart';
import 'package:provider/provider.dart';

class SelectPetAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool canTap;
  final AppBar appBar;
  const SelectPetAppBar({
    super.key,
    required this.appBar,
    required this.canTap,
  });

  @override
  State<SelectPetAppBar> createState() => SelectPetAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SelectPetAppBarState extends State<SelectPetAppBar> {
  late int _selectedPet;

  @override
  Widget build(BuildContext context) {
    final petDataList =
        Provider.of<PetDataListProvider>(context).getPetDataList();
    final selectedPetProvider = Provider.of<SelectedPetProvider>(context);
    _selectedPet = selectedPetProvider.getIndex();

    return InkWell(
      onTap: () {
        if (widget.canTap) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('애완동물 선택'),
                content: SizedBox(
                  width: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: petDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        title: Text(petDataList.elementAt(index).name),
                        value: index,
                        groupValue: _selectedPet,
                        onChanged: (int? value) {
                          setState(() {
                            selectedPetProvider.setTempIndex(_selectedPet);
                            _selectedPet = value!;
                            int id = petDataList.elementAt(_selectedPet).id;
                            selectedPetProvider.setIndex(_selectedPet, id);
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
      child: widget.appBar,
    );
  }
}
