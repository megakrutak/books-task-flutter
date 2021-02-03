import 'package:json_annotation/json_annotation.dart';

part 'volume_dto.g.dart';

@JsonSerializable(nullable: false)
class VolumeDto {
  final String id;
  @JsonKey(nullable: true)
  final VolumeInfoDto volumeInfo;
  final SaleInfoDto saleInfo;

  VolumeDto({this.id, this.volumeInfo, this.saleInfo});

  factory VolumeDto.fromJson(Map<String, dynamic> json) =>
      _$VolumeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeDtoToJson(this);
}

@JsonSerializable(nullable: true)
class ImageLinksDto {
  final String smallThumbnail;

  ImageLinksDto({this.smallThumbnail});

  factory ImageLinksDto.fromJson(Map<String, dynamic> json) =>
      _$ImageLinksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageLinksDtoToJson(this);
}

@JsonSerializable(nullable: true)
class SaleInfoDto {
  @JsonKey(nullable: true)
  final String buyLink;

  SaleInfoDto({this.buyLink});

  factory SaleInfoDto.fromJson(Map<String, dynamic> json) =>
      _$SaleInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SaleInfoDtoToJson(this);
}

@JsonSerializable(nullable: false)
class VolumeInfoDto {
  final String title;
  @JsonKey(nullable: true, defaultValue: "")
  final String description;
  @JsonKey(nullable: true, defaultValue: [])
  final List<String> authors;
  final String infoLink;
  @JsonKey(nullable: true)
  final ImageLinksDto imageLinks;

  VolumeInfoDto(
      {this.title,
      this.description,
      this.authors,
      this.infoLink,
      this.imageLinks});

  factory VolumeInfoDto.fromJson(Map<String, dynamic> json) =>
      _$VolumeInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeInfoDtoToJson(this);
}
