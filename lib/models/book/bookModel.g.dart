// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      userId: (json['userId'] as num?)?.toInt(),
      serialNumber: json['serialNumber'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      author: json['author'] as String,
      genre: json['genre'] as String,
      publisher: json['publisher'] as String,
      price: (json['price'] as num).toDouble(),
      publicationYear: (json['publicationYear'] as num).toInt(),
      cover: _stringToFile(json['cover'] as String?),
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'userId': instance.userId,
      'serialNumber': instance.serialNumber,
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'genre': instance.genre,
      'publisher': instance.publisher,
      'price': instance.price,
      'publicationYear': instance.publicationYear,
      'cover': _fileToString(instance.cover),
    };
