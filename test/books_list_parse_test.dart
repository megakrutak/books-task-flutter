import 'dart:convert';

import 'package:books_app/data/book.dart';
import 'package:books_app/data/books_list.dart';
import 'package:books_app/model/books/dto/volumes_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/fixture_reader.dart';

void main() {
  test("test parse books list from json", () async {
    var booksList = BooksList(
        totalItems: 546,
        items: List.of([
          Book(
            id: "36kxuQAACAAJ",
            title: "The Works of Jonathan Swift Volume 15",
            description:
                "Unlike some other reproductions of classic texts (1) We have not used OCR(Optical Character Recognition), as this leads to bad quality books with introduced typos. (2) In books where there are images such as portraits, maps, sketches etc We have endeavoured to keep the quality of these images, so they represent accurately the original artefact. Although occasionally there may be certain imperfections with these old texts, we feel they deserve to be made available for future generations to enjoy.",
            authors: List.of(["Jonathan Swift"]),
            thumbnailLink:
                "http://books.google.com/books/content?id=36kxuQAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
            infoLink:
                "http://books.google.ru/books?id=36kxuQAACAAJ&dq=swift&hl=&source=gbs_api",
            buyLink: null,
          ),
          Book(
            id: "LJRDAQAAIAAJ",
            title:
                "The Works of Jonathan Swift: Journal to Stella (Letter XLIII-LXV). Tracts, political and historical, prior to the accession of George I. The Examiner",
            description: null,
            authors: List.of(["Jonathan Swift", "Sir Walter Scott"]),
            thumbnailLink:
                "http://books.google.com/books/content?id=LJRDAQAAIAAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
            infoLink:
                "https://play.google.com/store/books/details?id=LJRDAQAAIAAJ&source=gbs_api",
            buyLink: "https://play.google.com/store/books/details?id=LJRDAQAAIAAJ&rdid=book-LJRDAQAAIAAJ&rdot=1&source=gbs_api",
          )
        ]));

    var volumesDto = VolumesDto.fromJson(json.decode(fixture("volumes.json")));

    expect(booksList, volumesDto.booksList);
  });
}
