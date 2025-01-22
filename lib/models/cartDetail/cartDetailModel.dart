import 'package:json_annotation/json_annotation.dart';

part 'cartDetailModel.g.dart';

@JsonSerializable()
class CartDetail {
  int cartId;
  int bookId;
  int quantity;

  CartDetail(
      {required this.cartId, required this.bookId, required this.quantity});

  factory CartDetail.fromJson(Map<String, dynamic> json) =>
      _$CartDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CartDetailToJson(this);
}
