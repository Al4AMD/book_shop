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

  Future<String> createBook({required Book book}) async {
    try {
      final response = await ApiClient.dio.post("/createUser", data: {
        "userId": book.userId,
        "title": book.title,
        "serialNumber": book.serialNumber,
        "author": book.author,
        "description": book.description,
        "genre": book.genre,
        "publisher": book.publisher,
        "publicationYear": book.publicationYear,
        "price": book.price 
      });
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
