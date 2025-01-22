// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDetail _$CartDetailFromJson(Map<String, dynamic> json) => CartDetail(
      cartId: (json['cartId'] as num).toInt(),
      bookId: (json['bookId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartDetailToJson(CartDetail instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'bookId': instance.bookId,
      'quantity': instance.quantity,
    };
