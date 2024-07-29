import 'package:json_annotation/json_annotation.dart';

part 'option.g.dart';

// flutter pub run build_runner build
@JsonSerializable()
class Option {
  int breath;
  int graph;
  int alert;
  int alarm;
  @JsonKey(name: 'alarm_day')
  int alarmDay;
  @JsonKey(name: 'alarm_time')
  String alarmTime;

  Option(this.breath, this.graph, this.alert, this.alarm, this.alarmDay,
      this.alarmTime);

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
