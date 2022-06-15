import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class Image {

  @JsonKey(defaultValue: '')
  @HiveField(0)
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(1)
  final String firebaseId;

  @JsonKey(defaultValue: '')
  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  Image({
    required this.id,
    required this.firebaseId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) =>
      _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
