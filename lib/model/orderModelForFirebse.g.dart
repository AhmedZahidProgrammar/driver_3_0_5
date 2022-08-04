// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderModelForFirebse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModelForFirebase _$OrderModelForFirebaseFromJson(
        Map<String, dynamic> json) =>
    OrderModelForFirebase(
      vendorLang: (json['vendorLang'] as num).toDouble(),
      vendorLat: (json['vendorLat'] as num).toDouble(),
      userLang: (json['userLang'] as num).toDouble(),
      userLat: (json['userLat'] as num).toDouble(),
      driverLat: (json['driverLat'] as num).toDouble(),
      driverLang: (json['driverLang'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderModelForFirebaseToJson(
        OrderModelForFirebase instance) =>
    <String, dynamic>{
      'vendorLang': instance.vendorLang,
      'vendorLat': instance.vendorLat,
      'userLang': instance.userLang,
      'userLat': instance.userLat,
      'driverLat': instance.driverLat,
      'driverLang': instance.driverLang,
    };
