import 'package:json_annotation/json_annotation.dart';

part 'result_data.g.dart';

// flutter pub run build_runner build
@JsonSerializable()
class ResultData {
  // gender   true: Male / false: Female
  // species  true: Dog / false: Cat
  final int id;
  String breathPerMinute;
  String date;
  String time;
  String weight;
  String comment;

  ResultData(this.id, this.breathPerMinute, this.date, this.time, this.weight,
      this.comment);

  int getTime() {
    return DateTime.parse('${date}T$time').millisecondsSinceEpoch;
  }

  factory ResultData.fromJson(Map<String, dynamic> json) =>
      _$ResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDataToJson(this);
}
