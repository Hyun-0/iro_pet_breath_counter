import 'package:flutter/material.dart';
import 'package:iro_pet_breath_counter/data/result_data.dart';

class ResultDataCard extends StatefulWidget {
  final ResultData data;
  final dynamic onEditTapped;

  const ResultDataCard(
      {super.key, required this.data, required this.onEditTapped});

  @override
  State<ResultDataCard> createState() => _ResultDataCardState();
}

class _ResultDataCardState extends State<ResultDataCard> {
  void _onEditTapped() {
    widget.onEditTapped();
  }

  @override
  Widget build(BuildContext context) {
    final ResultData data = widget.data;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.date),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.time),
                          Text('${data.weight}kg'),
                          const Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text('분당\n수면중\n호흡수'),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          data.breathPerMinute,
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(data.comment),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.create_outlined),
          onPressed: _onEditTapped,
        ),
      ),
    );
  }
}
