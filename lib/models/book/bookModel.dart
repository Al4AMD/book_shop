import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'bookModel.g.dart';

// Helper function to convert File to String (path)
String? _fileToString(File? file) => file?.path;

// Helper function to convert String (path) to File
File? _stringToFile(String? path) => path != null ? File(path) : null;

@JsonSerializable()
class Book {
  String serialNumber;
  String title;
  String author;
  String genre;
  String publisher;
  double price;
  int publicationYear;

  @JsonKey(
    fromJson: _stringToFile,
    toJson: _fileToString,
  )
  File? cover;

  Book(
      {required this.serialNumber,
      required this.title,
      required this.author,
      required this.genre,
      required this.publisher,
      required this.price,
      required this.publicationYear,
      this.cover});

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
