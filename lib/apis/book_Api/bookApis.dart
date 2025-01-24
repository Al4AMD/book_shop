import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:libraryproject/models/book/bookModel.dart';
import 'package:libraryproject/services/apiClient.dart';
import 'package:libraryproject/services/utils/utilApis.dart';

class BookService {
  Future<List<Book>> getAllBooks() async {
    List<Book> books = [];
    try {
      final response = await ApiClient.dio.get("/getAllBooks");
      if (response.data['result'] == "success") {
        for (var item in response.data['data']) {
          books.add(Book.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (error) {
      log("Error: $error");
      return [];
    }
  }

  Future<String> createBook({required Book book}) async {
    try {
      final formData = FormData.fromMap({
        "userId": book.userId != 0 ? book.userId : null,
        "title": book.title,
        "serialNumber": book.serialNumber,
        "author": book.author,
        "description": book.description,
        "genre": book.genre,
        "publisher": book.publisher,
        "publicationYear": book.publicationYear,
        "price": book.price,
        if (book.cover != null)
          'cover': await MultipartFile.fromFile(book.cover!.path,
              contentType: MediaType('image', 'jpg')),
      });
      final response = await ApiClient.dio.post("/createBook", data: formData);
      if (response.data['result'] == "success") {
        return "Success";
      } else {
        return "";
      }
    } catch (error) {
      return "";
    }
  }

  Future<List<Book>> getUserBooks(int userId) async {
    List<Book> books = [];
    try {
      final response = await ApiClient.dio.get("/getUserBooks/$userId");
      if (response.data['result'] == "success") {
        for (var item in response.data['data']) {
          books.add(Book.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (error) {
      log("error: $error");
      return [];
    }
  }

  Future<List<dynamic>> getAllGenres() async {
    try {
      final response = await ApiClient.dio.get("/getAllGenres");
      if (response.data['result'] == "success") {
        return response.data['data'];
      } else {
        return [];
      }
    } catch (error) {
      log("Error: $error");
      return [];
    }
  }

  Future<List<Book>> getBooksByGenre(String genre) async {
    List<Book> books = [];
    try {
      final response = await ApiClient.dio.get("/getAllBooks/$genre");
      if (response.data['result'] == "success") {
        for (var item in response.data['data']) {
          books.add(Book.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (error) {
      log("Error: $error");
      return [];
    }
  }
}
