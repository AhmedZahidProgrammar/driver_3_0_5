// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driverModelForFirebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModelForFirebase _$DriverModelForFirebaseFromJson(
        Map<String, dynamic> json) =>
    DriverModelForFirebase(
      driverLat: (json['driverLat'] as num).toDouble(),
      driverLang: (json['driverLang'] as num).toDouble(),
    );

Map<String, dynamic> _$DriverModelForFirebaseToJson(
        DriverModelForFirebase instance) =>
    <String, dynamic>{
      'driverLat': instance.driverLat,
      'driverLang': instance.driverLang,
    };
