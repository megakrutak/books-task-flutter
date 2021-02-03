import 'dart:convert';
import 'package:books_app/model/books/dto/volumes_dto.dart';
import 'package:dio/dio.dart';

abstract class IBooksRemoteDataSource {
  Future<VolumesDto> searchVolumes(String query, int maxResults, int startIndex);
}

class BooksRemoteDataSource extends IBooksRemoteDataSource {
  BooksRemoteDataSource(this.dio);

  final Dio dio;

  @override
  Future<VolumesDto> searchVolumes(String query, int maxResults, int startIndex) async {
    Response response =
        await dio.get("https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=$maxResults&startIndex=$startIndex");


    Map result = json.decode(response.toString());

    return VolumesDto.fromJson(result);
  }
}
