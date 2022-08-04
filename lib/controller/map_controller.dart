import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';

import 'firebase_controller.dart';

class MapController extends GetxController{
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  FirebaseController _firebaseController=Get.find<FirebaseController>();
  RxBool loading=false.obs;
  Location location= Location();
  RxBool pickupStatus=false.obs;

  Future<void> addMarkersAndPolyLines(double driverLat,double driverLang,double vendorLat,double vendorLang,double userLat,double userLang,double heading)async{
    polylines.clear();
    polylineCoordinates.clear();
    print(userLat.toString()+","+userLang.toString());
    BitmapDescriptor customIcon1=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1, 1)), 'images/food_map_image_4.png');
    MarkerId markerId1 = MarkerId('destination');
    Marker marker1 =
    Marker(
        markerId: markerId1, icon: customIcon1, position: LatLng(vendorLat,vendorLang),
        zIndex: 2,
        anchor: Offset(0.5,0.5)
    );
    markers.addAll({markerId1:marker1});
    BitmapDescriptor customIcon2=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)), 'images/driver_map_image_7.png');
    MarkerId markerId2 = MarkerId('origin');
    Marker marker2 =
    Marker(markerId: markerId2, icon: customIcon2, position: LatLng(driverLat,driverLang),
        zIndex: 2,
        rotation: heading,
        anchor: Offset(0.5,0.5)
    );
    markers.addAll({markerId2:marker2});
    BitmapDescriptor customIcon3=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(0, 0)), 'images/home_icon.png');
    MarkerId markerId3 = MarkerId('user');
    Marker marker3 =
    Marker(markerId: markerId3, icon: customIcon3, position: LatLng(userLat,userLang),
        zIndex: 2,
        anchor: Offset(0.5,0.5));
   markers.addAll({markerId3:marker3});
   print("Markers are"+markers[markerId3].toString());
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(Constants.androidKey,
        PointLatLng(driverLat, driverLang), PointLatLng(vendorLat, vendorLang));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    result = await polylinePoints.getRouteBetweenCoordinates(Constants.androidKey,
         PointLatLng(vendorLat, vendorLang),PointLatLng(userLat, userLang));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.green, points: polylineCoordinates);
    polylines[id] = polyline;
    update();
  }
  updateMarker(double driverLat,double driverLong,double vendorLat,double vendorLang,double userLat,double userLang,double heading)async{
    // polylines.clear();
    // polylineCoordinates.clear();
    BitmapDescriptor customIcon3=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)), 'images/driver_map_image_7.png');
    MarkerId markerId = MarkerId('origin');
    Marker marker =
    Marker(
        markerId: markerId, icon: customIcon3, position: LatLng(driverLat,driverLong),
        zIndex: 2,
        rotation: heading,
        anchor: Offset(0.5,0.5)
    );
    markers[markerId]=marker;
    // PolylinePoints polylinePoints = PolylinePoints();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyCDcZlGMIvPlbwuDgQzlEkdhjVQVPnne4c',
    //     PointLatLng(driverLat, driverLong), PointLatLng(vendorLat, vendorLang));
    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
    // result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyCDcZlGMIvPlbwuDgQzlEkdhjVQVPnne4c',
    //     PointLatLng(vendorLat, vendorLang),PointLatLng(userLat, userLang));
    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
    // PolylineId id = PolylineId("poly");
    // Polyline polyline = Polyline(
    //     polylineId: id, color: Colors.green, points: polylineCoordinates);
    // polylines[id] = polyline;
    _firebaseController.updateDriverNode(PreferenceUtils.getString(Constants.driverid), driverLat, driverLong);
    update();

  }
  addUserAndDriverMarkersAndPolyLines(double driverLat,double driverLong,double userLat,double userLong,double heading)async{
    polylines.clear();
    polylineCoordinates.clear();
    BitmapDescriptor customIcon1=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), 'images/driver_map_image_7.png');
    MarkerId markerId1 = MarkerId('origin');
    Marker marker =
    Marker(
        markerId: markerId1,
        icon: customIcon1,
        position: LatLng(driverLat,driverLong),
        zIndex: 2,
        rotation: heading,
        anchor: Offset(0.5,0.5)
    );
    markers[markerId1]=marker;
    BitmapDescriptor customIcon2=await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), 'images/home_icon.png');
    MarkerId markerId2 = MarkerId('user');
    Marker marker2 =
    Marker(markerId: markerId2, icon: customIcon2, position: LatLng(userLat,userLong));
    markers[markerId2]=marker2;
    markers.remove(MarkerId('destination'));
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(Constants.androidKey,
        PointLatLng(driverLat, driverLong),PointLatLng(userLat, userLong));
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.green, points: polylineCoordinates);
    polylines[id] = polyline;
    update();

  }


  Future<bool> CallApiForPickUporder(BuildContext context,String id,double userLat,double userLang) async{
   loading.value=true;
   update();
    String? response=await RestClient(Api_Header().Dio_Data())
        .orderstatuschange1(id, "PICKUP");
   print("order_response:$response");
   final body = json.decode(response!);
   bool? sucess = body['success'];
   // bool sucess =response.success;
   if (sucess = true) {
     LocationData locationData=await location.getLocation();
     addUserAndDriverMarkersAndPolyLines(locationData.latitude!, locationData.longitude!, userLat, userLang,locationData.heading!);
     pickupStatus.value=true;
     // Constants.createSnackBar(msg, context, Color(Constants.greentext));
     //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickUpOrder()));
   } else if (sucess == false) {
     var msg = Languages.of(context)!.tryagainlable;
     // print(msg);
     Constants.createSnackBar(msg, context, Color(Constants.redtext));
   }
      //ScaffoldMessenger.of(context).showSnackBar(snackBar);

   loading.value=false;
   update();
    return true;
  }
}