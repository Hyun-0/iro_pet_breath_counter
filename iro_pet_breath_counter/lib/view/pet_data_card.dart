import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/pet_data.dart';

class PetDataCard extends StatefulWidget {
  final PetData data;
  final int index;
  final dynamic onEditTapped;

  const PetDataCard(
      {super.key,
      required this.data,
      required this.index,
      required this.onEditTapped});

  @override
  State<PetDataCard> createState() => _PetDataCardState();
}

class _PetDataCardState extends State<PetDataCard> {
  void _onEditTapped() {
    widget.onEditTapped(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final PetData data = widget.data;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 80,
          child: (() {
            if (data.image == '') {
              return const Icon(Icons.crop_original);
            } else {
              return Image.file(File(data.image));
            }
          })(),
        ),
        title: Text(data.name),
        subtitle: (() {
          String subtitle = '';
          subtitle += (data.age != '' && data.age != '나이 미정')
              ? '${data.age}세'
              : '나이 미정';
          subtitle += (data.breed != '') ? ', ${data.breed}\n' : '\n';
          subtitle += (data.isNeutered) ? '중성화 ' : '비중성화 ';
          subtitle += (data.gender) ? '수컷' : '암컷';
          return Text(subtitle);
        })(),
        trailing: IconButton(
          icon: const Icon(Icons.create_outlined),
          onPressed: _onEditTapped,
        ),
      ),
    );
  }
}
