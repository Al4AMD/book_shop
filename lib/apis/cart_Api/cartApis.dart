import 'package:libraryproject/services/apiClient.dart';
import 'package:libraryproject/services/utils/utilApis.dart';

class CartService {
  Future<dynamic> createCard() async {
    try {
      int id = await UtilsService.getUserId();
      final response =
          await ApiClient.dio.post('/createCart', data: {"userId": id});
      if (response.data['result'] == 'success') {
        return response.data;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
