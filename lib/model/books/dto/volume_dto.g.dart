// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolumeDto _$VolumeDtoFromJson(Map<String, dynamic> json) {
  return VolumeDto(
    id: json['id'] as String,
    volumeInfo: json['volumeInfo'] == null
        ? null
        : VolumeInfoDto.fromJson(json['volumeInfo'] as Map<String, dynamic>),
    saleInfo: SaleInfoDto.fromJson(json['saleInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VolumeDtoToJson(VolumeDto instance) => <String, dynamic>{
      'id': instance.id,
      'volumeInfo': instance.volumeInfo,
      'saleInfo': instance.saleInfo,
    };

ImageLinksDto _$ImageLinksDtoFromJson(Map<String, dynamic> json) {
  return ImageLinksDto(
    smallThumbnail: json['smallThumbnail'] as String,
  );
}

Map<String, dynamic> _$ImageLinksDtoToJson(ImageLinksDto instance) =>
    <String, dynamic>{
      'smallThumbnail': instance.smallThumbnail,
    };

SaleInfoDto _$SaleInfoDtoFromJson(Map<String, dynamic> json) {
  return SaleInfoDto(
    buyLink: json['buyLink'] as String,
  );
}

Map<String, dynamic> _$SaleInfoDtoToJson(SaleInfoDto instance) =>
    <String, dynamic>{
      'buyLink': instance.buyLink,
    };

VolumeInfoDto _$VolumeInfoDtoFromJson(Map<String, dynamic> json) {
  return VolumeInfoDto(
    title: json['title'] as String,
    description: json['description'] as String ?? '',
    authors: (json['authors'] as List)?.map((e) => e as String)?.toList() ?? [],
    infoLink: json['infoLink'] as String,
    imageLinks: json['imageLinks'] == null
        ? null
        : ImageLinksDto.fromJson(json['imageLinks'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VolumeInfoDtoToJson(VolumeInfoDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'authors': instance.authors,
      'infoLink': instance.infoLink,
      'imageLinks': instance.imageLinks,
    };
