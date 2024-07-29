// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultData _$ResultDataFromJson(Map<String, dynamic> json) => ResultData(
      json['id'] as int,
      json['breathPerMinute'] as String,
      json['date'] as String,
      json['time'] as String,
      json['weight'] as String,
      json['comment'] as String,
    );

Map<String, dynamic> _$ResultDataToJson(ResultData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'breathPerMinute': instance.breathPerMinute,
      'date': instance.date,
      'time': instance.time,
      'weight': instance.weight,
      'comment': instance.comment,
    };
