import 'dart:developer';

import 'package:libraryproject/models/book/bookModel.dart';
import 'package:libraryproject/services/apiClient.dart';

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
