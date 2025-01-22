// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      fullName: json['fullName'] as String,
      profilePicture: _stringToFile(json['profilePicture'] as String?),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'birth': instance.birth?.toIso8601String(),
      'fullName': instance.fullName,
      'profilePicture': _fileToString(instance.profilePicture),
    };
