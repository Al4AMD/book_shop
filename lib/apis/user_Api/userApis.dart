import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:libraryproject/models/user/userModel.dart';
import 'package:libraryproject/services/apiClient.dart';
import 'package:libraryproject/services/utils/utilApis.dart';

class UserApi {
  Future<String> login(
      {required String username, required String password}) async {
    try {
      final response = await ApiClient.dio.post("/login", data: {
        "username": username,
        "password": password,
      });
      if (response.data['result'] == "success") {
        await UtilsService.storeUserInfo(response.data['data']);
        return response.data['message'];
      } else {
        return "Login failed!";
      }
    } on DioException catch (error) {
      return "Login failed due to: $error";
    }
  }

  Future<String> signUp({required User user}) async {
    try {
      final formData = FormData.fromMap({
        "username": user.username,
        "password": user.password,
        "email": user.email,
        "address": user.address,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "birth": "${user.birth?.year}-${user.birth?.month}-${user.birth?.day}",
        if (user.profilePicture != null)
          'profile': await MultipartFile.fromFile(user.profilePicture!.path,
              contentType: MediaType('image', 'jpg')),
      });
      final response = await ApiClient.dio.post('/createUser', data: formData);
      if (response.data['result'] == "success") {
        await UtilsService.storeUserInfo(response.data['data']);
        return "Sign up successful!";
      } else {
        return "Sign up failed!";
      }
    } catch (error) {
      return "Sign up failed due to: $error";
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final id = await UtilsService.getUserId();
      final response = await ApiClient.dio.get("/getAllUsers/$id");
      if (response.data['result'] == "success") {
        return response.data['data'];
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }
}
