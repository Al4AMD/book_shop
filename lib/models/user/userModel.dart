import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

// Helper function to convert File to String (path)
String? _fileToString(File? file) => file?.path;

// Helper function to convert String (path) to File
File? _stringToFile(String? path) => path != null ? File(path) : null;

@JsonSerializable()
class User {
  String username;
  String email;
  String
      password; // Note: Password should typically not be included in API responses
  String address;
  String phoneNumber;
  DateTime? birth;
  String fullName;

  @JsonKey(
    fromJson: _stringToFile,
    toJson: _fileToString,
  )
  File? profilePicture;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.phoneNumber,
    this.birth,
    required this.fullName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
