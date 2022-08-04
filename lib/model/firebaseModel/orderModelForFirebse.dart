import 'package:json_annotation/json_annotation.dart';
part 'orderModelForFirebse.g.dart';
@JsonSerializable()
class OrderModelForFirebase {
  final double vendorLang;
  final double vendorLat;
  final double userLang;
  final double userLat;
  final double driverLat;
  final double driverLang;
  factory OrderModelForFirebase.fromJson(Map<String, dynamic> json) => _$OrderModelForFirebaseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelForFirebaseToJson(this);
  OrderModelForFirebase({required this.vendorLang,required this.vendorLat,required this.userLang,required this.userLat,required this.driverLat,required this.driverLang});

}