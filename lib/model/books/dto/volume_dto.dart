import 'package:books_app/data/book.dart';

class VolumeDto {
  VolumeDto(this.book);

  final Book book;

  factory VolumeDto.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> volumeInfo = json["volumeInfo"];
    Map<String, dynamic> saleInfo = json["saleInfo"];

    return VolumeDto(Book(
        id: json["id"],
        title: volumeInfo["title"],
        description: volumeInfo["description"],
        authors: (volumeInfo["authors"] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        thumbnailLink: volumeInfo["imageLinks"]["smallThumbnail"],
        infoLink: volumeInfo["infoLink"],
        buyLink: (saleInfo != null && saleInfo.containsKey("buyLink")) ? saleInfo["buyLink"] : null
    ));
  }
}
