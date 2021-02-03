import 'package:json_annotation/json_annotation.dart';

import 'volume_dto.dart';

part 'volumes_dto.g.dart';

@JsonSerializable(nullable: false)
class VolumesDto {
  final int totalItems;
  final List<VolumeDto> items;

  VolumesDto({this.totalItems, this.items});

  factory VolumesDto.fromJson(Map<String, dynamic> json) =>
      _$VolumesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VolumesDtoToJson(this);
}
