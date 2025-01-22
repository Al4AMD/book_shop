// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      serialNumber: json['serialNumber'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      genre: json['genre'] as String,
      publisher: json['publisher'] as String,
      price: (json['price'] as num).toDouble(),
      publicationYear: (json['publicationYear'] as num).toInt(),
      cover: _stringToFile(json['cover'] as String?),
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'serialNumber': instance.serialNumber,
      'title': instance.title,
      'author': instance.author,
      'genre': instance.genre,
      'publisher': instance.publisher,
      'price': instance.price,
      'publicationYear': instance.publicationYear,
      'cover': _fileToString(instance.cover),
    };
