// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volumes_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolumesDto _$VolumesDtoFromJson(Map<String, dynamic> json) {
  return VolumesDto(
    totalItems: json['totalItems'] as int,
    items: (json['items'] as List)
        .map((e) => VolumeDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$VolumesDtoToJson(VolumesDto instance) =>
    <String, dynamic>{
      'totalItems': instance.totalItems,
      'items': instance.items,
    };
