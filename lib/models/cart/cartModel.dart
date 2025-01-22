import 'package:json_annotation/json_annotation.dart';

part 'cartModel.g.dart';

@JsonSerializable()
class Cart {
  int userId;
  String status;

  Cart({required this.userId, required this.status});

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}
