import 'package:json_annotation/json_annotation.dart';

part 'pet_data.g.dart';

// flutter pub run build_runner build
@JsonSerializable()
class PetData {
  // gender   true: Male / false: Female
  // species  true: Dog / false: Cat
  final int id;
  String image;
  String name;
  String age;
  bool species;
  String breed;
  @JsonKey(name: 'is_neutered')
  bool isNeutered;
  bool gender;

  PetData(this.id, this.image, this.name, this.age, this.species, this.breed,
      this.isNeutered, this.gender);

  factory PetData.fromJson(Map<String, dynamic> json) =>
      _$PetDataFromJson(json);

  Map<String, dynamic> toJson() => _$PetDataToJson(this);
}
