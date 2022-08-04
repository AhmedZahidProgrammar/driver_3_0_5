

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:driver_3_0_5/model/firebaseModel/driverModelForFirebase.dart';
import 'package:driver_3_0_5/model/orderModelForFirebse.dart';

class FirebaseController extends GetxController{
  DatabaseReference _firebaseRef=FirebaseDatabase.instance.ref();
  createOrderNode(String orderId,double driverLang,double driverLat,double userLat,double userLang,double vendorLat,double vendorLang){
    OrderModelForFirebase _orderModelForFirebase=OrderModelForFirebase(driverLang: driverLang, driverLat: driverLat, userLat: userLat, userLang: userLang, vendorLat: vendorLat, vendorLang: vendorLang);
    _firebaseRef.child(orderId).set(_orderModelForFirebase.toJson());
  }
  createDriverNode(int driverId,double driverLat,double driverLang){
    DriverModelForFirebase driverModelForFirebase=DriverModelForFirebase(driverLat: driverLat, driverLang: driverLang);
  _firebaseRef.child('drivers').child(driverId.toString()).set(driverModelForFirebase.toJson());
  }
  updateDriverNode(String driverId,double driverLat,double driverLang){
    DriverModelForFirebase driverModelForFirebase=DriverModelForFirebase(driverLat: driverLat, driverLang: driverLang);
    _firebaseRef.child('drivers').child(driverId.toString()).update(driverModelForFirebase.toJson());
  }
}