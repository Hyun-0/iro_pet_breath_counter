// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      json['breath'] as int,
      json['graph'] as int,
      json['alert'] as int,
      json['alarm'] as int,
      json['alarm_day'] as int,
      json['alarm_time'] as String,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'breath': instance.breath,
      'graph': instance.graph,
      'alert': instance.alert,
      'alarm': instance.alarm,
      'alarm_day': instance.alarmDay,
      'alarm_time': instance.alarmTime,
    };
