import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:libraryproject/view/models.dart';

class HttpService {
  // Change the base URL to your server's IP address.
  final String baseUrl = "http://192.168.3.151:5000/book/";

  // Fetch the list of books from the server
  Future<List<Book>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);

        // Map only if the items are JSON-like maps
        List<Book> shoppingItems = items
            .map<Book>((item) => Book.fromJson(item as Map<String, dynamic>))
            .toList();
        return shoppingItems;
      } else {
        throw Exception(
            'Failed to load items. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading items: $error');
    }
  }

  // Create a new book in the database
  Future<void> createBook(Map<String, dynamic> bookDetails) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bookDetails),
      );
      // final res = json.decode(response.toString());
      log("res: ${utf8.decode(response.bodyBytes)}");
      print(jsonEncode(bookDetails));
      if (response.statusCode == 201) {
        print('Book created successfully');
      } else {
        throw Exception(
            'Failed to create book. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating book: $error');
    }
  }

  // Update an existing book's details
  Future<void> updateBook(
      int bookKey, Map<String, dynamic> updatedBookDetails) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl' + 'update/$bookKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedBookDetails),
      );

      if (response.statusCode == 200) {
        print('Book updated successfully');
      } else {
        throw Exception(
            'Failed to update book. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating book: $error');
    }
  }

  // Delete a book from the database
  Future<void> deleteBook(int bookKey) async {
    try {
      print('$baseUrl' + 'destroy/$bookKey');
      final response = await http.delete(
        Uri.parse('$baseUrl' + 'destroy/$bookKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        print('Book deleted successfully');
        // Call fetchItems to update the list after deletion
        await fetchItems();
      } else {
        throw Exception(
            'Failed to delete book. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting book: $error');
    }
  }

  // Update the user's cart (add/remove book from favorites)
  Future<void> updateCart(int bookId, bool addToCart) async {
    try {
      print('$baseUrl' + 'cart/update/1');
      final response = await http.post(
        Uri.parse('$baseUrl' + 'cart/update/1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'book_id': bookId,
          'add_to_cart': addToCart,
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('Cart updated successfully');
        await fetchCartItems();
      } else {
        throw Exception(
            'Failed to update cart. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating cart: $error');
    }
  }

  // Fetch the list of books in the user's cart (favorites)
  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    // Modify this based on your actual URL for fetching cart items
    String baseUrl = "http://192.168.3.151:8000/book/cart";
    try {
      print('$baseUrl' + '/1');
      final response = await http.get(Uri.parse('$baseUrl' + '/1/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Access the 'books' field in the response data
        final List<dynamic> items = responseData['books'];

        print(items);

        List<Map<String, dynamic>> shoppingItems =
            List<Map<String, dynamic>>.from(items);
        return shoppingItems;
      } else {
        throw Exception(
            'Failed to load items. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading items: $error');
    }
  }

  // Fetch books by their IDs (used in favorites screen)
  Future<List<Book>> fetchBooksByIds(List<int> bookIds) async {
    final List<Book> books = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final items = json.decode(response.body);
        for (var item in items) {
          if (bookIds.contains(item['id'])) {
            books.add(Book.fromJson(item));
          }
        }
      } else {
        throw Exception(
            'Failed to load books. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching books: $error');
    }
    return books;
  }
}
