// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetData _$PetDataFromJson(Map<String, dynamic> json) => PetData(
      json['id'] as int,
      json['image'] as String,
      json['name'] as String,
      json['age'] as String,
      json['species'] as bool,
      json['breed'] as String,
      json['is_neutered'] as bool,
      json['gender'] as bool,
    );

Map<String, dynamic> _$PetDataToJson(PetData instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'age': instance.age,
      'species': instance.species,
      'breed': instance.breed,
      'is_neutered': instance.isNeutered,
      'gender': instance.gender,
    };
