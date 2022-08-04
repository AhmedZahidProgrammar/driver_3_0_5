import 'package:json_annotation/json_annotation.dart';
part 'driverModelForFirebase.g.dart';
@JsonSerializable()
class DriverModelForFirebase{
  final double driverLat;
  final double driverLang;

  DriverModelForFirebase({required this.driverLat,required this.driverLang});
  factory DriverModelForFirebase.fromJson(Map<String, dynamic> json) => _$DriverModelForFirebaseFromJson(json);
  Map<String, dynamic> toJson() => _$DriverModelForFirebaseToJson(this);
}