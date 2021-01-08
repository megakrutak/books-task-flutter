import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/dto/volume_dto.dart';

class VolumesDto {
  VolumesDto(this.booksList);

  final BooksList booksList;

  factory VolumesDto.fromJson(Map<String, dynamic> json) {
    return VolumesDto(BooksList(
        totalItems: json["totalItems"],
        items: (json["items"] as List<dynamic>)
            .map(
                (item) => VolumeDto.fromJson(item as Map<String, dynamic>).book)
            .toList()));
  }
}
