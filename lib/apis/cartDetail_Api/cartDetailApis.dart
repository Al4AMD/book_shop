import 'dart:developer';

import '../../models/book/bookModel.dart';
import '../../services/apiClient.dart';
import '../../services/utils/utilApis.dart';

class CartDetailService {
  Future<String> createCartDetail(
      List<int> bookIds, int cartId, List<int> quantities) async {
    try {
      // Construct the request body
      final List<Map<String, dynamic>> requestBody =
          List.generate(bookIds.length, (index) {
        return {
          'bookId': bookIds[index],
          'cartId': cartId,
          'quantity': quantities[index],
        };
      });
      final response = await ApiClient.dio.post(
        '/createCartDetail',
        data: requestBody,
      );

      if (response.data['result'] == 'success') {
        return "Success";
      } else {
        return "Failed!";
      }
    } catch (error) {
      return "Failed: $error";
    }
  }

  Future<List<int>> getBookIds(List<Book> books) async {
    List<int> bookIds = [];
    for (var item in books) {
      try {
        final response =
            await ApiClient.dio.get('/getBookSerial/${item.serialNumber}');
        bookIds.add(response.data['data']);
      } catch (error) {
        log("error: $error");
      }
    }
    return bookIds;
  }

  Future<List<int>> getUserCarts() async {
    try {
      int userId = await UtilsService.getUserId();
      final List<int> cartIds = [];
      final response =
          await ApiClient.dio.get('/getUserCarts/$userId').then((value) {
        log(value.data['data'].toString());
        for (var item in value.data['data']) {
          cartIds.add(item['id']);
        }
        log("Ids: ${cartIds}");
        return cartIds;
      });
      return cartIds;
    } catch (error) {
      return [];
    }
  }

  Future<List<Book>> getCartDetails(int cartId) async {
    try {
      List<Book> books = [];
      final response = await ApiClient.dio.get('/getCartDetails/$cartId');
      if (response.data['result'] == "success") {
        for (var item in response.data['data']) {
          books.add(Book.fromJson(item['Book']));
        }
        return books;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
