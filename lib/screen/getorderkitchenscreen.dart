import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/screen/homescreen.dart';

import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class GetOrderKitchen extends StatefulWidget {
  @override
  _GetOrderKitchen createState() => _GetOrderKitchen();
}

class _GetOrderKitchen extends State<GetOrderKitchen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  double heigntValue = 300;
  bool full = true;
  bool full1 = false;
  bool vi_address = true;
  String? _cancelReason = "0";
  bool showSpinner = false;
  List can_reason = [];

  String driver_address = "Not Found";

  String? id;
  late String orderId;
  late String vendorname;
  late String vendorAddress;
  late String distance;

  Timer? timer;

  int second = 10;

  double? driver_lat = 0.0;
  double? driver_lang= 0.0;

  late double vendor_lat = 0.0;
  late double vendor_lang = 0.0 ;
  late String cancel_reason;
  final _text_cancel_reason_controller = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();


  // String? _currentAddress;

  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};

  late LocationData currentLocation;
  Location? location;
 double CAMERA_ZOOM = 14.4746;
 double CAMERA_TILT = 80;
 double CAMERA_BEARING = 30;


  @override
  void initState() {
    super.initState();
    location = new Location();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    _getCurrentLocation();

    if (mounted) {
      setState(() {
        cancel_reason = PreferenceUtils.getString(Constants.cancel_reason);
        var json = JsonDecoder().convert(cancel_reason);
        can_reason.addAll(json);
      });
    }

    Constants.CheckNetwork().whenComplete(
        () => timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
              _getCurrentLocation();
            }));

   // second = int.parse(PreferenceUtils.getString(Constants.driver_auto_refrese));
    print("Seconds:$second");
    if (Constants.currentlat != 0.0 && Constants.currentlong != 0.0) {
      setState(() {
        driver_lat = Constants.currentlat;
        driver_lang = Constants.currentlong;
        if(PreferenceUtils.getString(Constants.previos_order_vendor_lat) != ''){
          vendor_lat = double.parse(PreferenceUtils.getString(Constants.previos_order_vendor_lat));
          vendor_lang = double.parse(PreferenceUtils.getString(Constants.previos_order_vendor_lang));
        }
        // assert(vendor_lat is double);
        // assert(vendor_lang is double);

        print("driver_lat::${driver_lat}");
        print("driver_lang::${driver_lang}");

        print("vendor_lat::${vendor_lat}");
        print("vendor_lang::${vendor_lang}");

        //currentLocation = _currentPosition;

        /// origin marker
        /// // make sure to initialize before map loading
        BitmapDescriptor customIcon;
         BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
                 'images/driver_map_image_7.png')
            .then((d) {
           customIcon = d;
           addMarker(LatLng(driver_lat!, driver_lang!), "origin", customIcon);
         });


        /// destination marker
        BitmapDescriptor customIcon1;
        BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'images/food_map_image_4.png')
            .then((d) {
          customIcon1 = d;
          addMarker(LatLng(vendor_lat, vendor_lang), "destination", customIcon1);
        });

        Constants.CheckNetwork().whenComplete(
            () => timer = Timer.periodic(Duration(seconds: second), (Timer t) {
                  _getCurrentLocation();
                 // adddrivermarker(_controller, 1, GeoCoordinates(driver_lat, driver_lang));
                  PostDriverLocation(driver_lat, driver_lang);
                }));
      });
    } else {
      checkforpermission();
    }

    PreferenceUtils.init();

    if (mounted) {
      setState(() {
        id = PreferenceUtils.getString(Constants.previos_order_id);
        orderId = PreferenceUtils.getString(Constants.previos_order_orderid);
        vendorname =
            PreferenceUtils.getString(Constants.previos_order_vendor_name);
        vendorAddress =
            PreferenceUtils.getString(Constants.previos_order_vendor_address);
        distance = PreferenceUtils.getString(Constants.previos_order_distance);

        if (Constants.currentaddress != "0") {
          driver_address = Constants.currentaddress;
        } else {

        }
      });
    }

    location!.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });
  }

  updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due

      // updated position
      //var pinPosition = LatLng(driver_lat,driver_lang);
    // final marker = markers.values.toList().firstWhere((item) => item.markerId == MarkerId('driver'));

    final marker = markers.values.toList().firstWhere((item) => item.markerId == MarkerId('origin'));

      Marker _marker = Marker(
        markerId: marker.markerId,
        position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        icon: marker.icon,
      );
    markers[MarkerId('origin')] = _marker;

      // setState(() {
      //
      //   //the marker is identified by the markerId and not with the index of the list
      //  // markers.update(markers[0].markerId, (_) => _marker) ;
      // });

      /*sourcePinInfo.location = pinPosition;
      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));*/

  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition()
        .then((Position position) {
      setState(() {
        driver_lat = position.latitude;
        driver_lang = position.longitude;

        print("driver_lat852:${driver_lat}");
        print("driver_lang852:${driver_lang}");
      });

     // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void checkforpermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print("denied");
      Constants.createSnackBar(Languages.of(context)!.allowlocationlable,
          this.context, Color(Constants.redtext));
    } else if (permission == LocationPermission.whileInUse) {
      print("whileInUse56362");


      setState(() {
        _getCurrentLocation();
        Constants.CheckNetwork().whenComplete(
            () => timer = Timer.periodic(Duration(seconds: second), (Timer t) {
                  //adddrivermarker(_controller, 1, GeoCoordinates(driver_lat, driver_lang));
                  PostDriverLocation(driver_lat, driver_lang);
                }));
      });
    } else if (permission == LocationPermission.always) {
      print("always");
      _getCurrentLocation();

      setState(() {
        Constants.CheckNetwork().whenComplete(
            () => timer = Timer.periodic(Duration(seconds: second), (Timer t) {
                 // adddrivermarker(_controller, 1, GeoCoordinates(driver_lat, driver_lang));
                  PostDriverLocation(driver_lat, driver_lang);
                }));
      });
    }
  }

  void PostDriverLocation(double? currentlat, double? currentlang) {
    print("UpdateLat:$currentlat");
    print("UpdateLang:$currentlang");

   // adddrivermarker(_controller, 1, GeoCoordinates(currentlat, currentlang));

    RestClient(Api_Header().Dio_Data())
        .driveupdatelatlong(currentlat.toString(), currentlang.toString())
        .then((response) {
      final body = json.decode(response!);
      bool? sucess = body['success'];
      if (sucess = true) {
        print("sucess lat long update");

        //removelatlong(GeoCoordinates(currentlat, currentlang));
      } else if (sucess == false) {
        print("false lat long update");

        // Constants.createSnackBar("Something Worng", context, Color(Constants.redtext));
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

 /* void removelatlong(GeoCoordinates geoCoordinates,) async {
    ByteData fileData = await rootBundle.load('images/driver_map_image_7.png');
    Uint8List pixelData = fileData.buffer.asUint8List();
    MapImage mapImage = MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    mapMarker.drawOrder = 1;_controller.mapScene.removeMapMarker(mapMarker);
    print("remove12");
  }*/

  void CallApiForPickUporder(BuildContext context) {
    setState(() {
      showSpinner = true;
    });

    if (mounted) {
      RestClient(Api_Header().Dio_Data())
          .orderstatuschange1(id, "PICKUP")
          .then((response) {
        print("order_response:$response");

        final body = json.decode(response!);
        bool? sucess = body['success'];
        // bool sucess =response.success;
        if (sucess = true) {
          setState(() {
            showSpinner = false;
          });
          // Constants.createSnackBar(msg, context, Color(Constants.greentext));

          PreferenceUtils.setString(Constants.previos_order_status, "PICKUP");

          setState(() {
            timer?.cancel();
          });

          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickUpOrder()));
        } else if (sucess == false) {
          setState(() {
            showSpinner = false;
          });
          var msg = Languages.of(context)!.tryagainlable;
          // print(msg);
          Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
        }
      }).catchError((Object obj) {
        final snackBar = SnackBar(
          content: Text(Languages.of(context)!.servererrorlable),
          backgroundColor: Color(Constants.redtext),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          showSpinner = false;
        });
        print("error:$obj");
        print(obj.runtimeType);
        //AppConstant.toastMessage("Internal Server Error");
      });
    }
  }

  void CallApiForCacelorder(String? id, String? cancelReason, BuildContext context) {
    print(id);

    setState(() {
      showSpinner = true;
    });

    if (mounted) {
      RestClient(Api_Header().Dio_Data())
          .cancelorder(id, "CANCEL", cancelReason)
          .then((response) {
        print("order_response:$response");

        final body = json.decode(response!);
        bool? sucess = body['success'];
        if (sucess = true) {
          setState(() {
            showSpinner = false;
          });
          var msg = Languages.of(this.context)!.ordercancellable;
          Constants.createSnackBar(msg, this.context, Color(Constants.greentext));

          if (mounted) {
            setState(() {
              PreferenceUtils.setString(
                  Constants.previos_order_status, "CANCEL");

              setState(() {
                timer?.cancel();
              });

              Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
            });
          }
        } else if (sucess == false) {
          setState(() {
            showSpinner = false;
          });
          var msg = Languages.of(this.context)!.tryagainlable;
          // print(msg);
          Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
        }
      }).catchError((Object obj) {
        final snackBar = SnackBar(
          content: Text(Languages.of(this.context)!.servererrorlable),
          backgroundColor: Color(Constants.redtext),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          showSpinner = false;
        });
        print("error:$obj");
        print(obj.runtimeType);
        //AppConstant.toastMessage("Internal Server Error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
     // double screenWidth = MediaQuery.of(context).size.width;

    // heigntValue =  300;

   /* ScreenUtil.init(context,
        designSize: Size(screenWidth, screenHeight), allowFontScaling: true);
*/
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/background_image.png'),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              // resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              body: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator:
                    SpinKitFadingCircle(color: Color(Constants.greentext)),
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return new Stack(
                      children: <Widget>[
                        Column(
                          // physics: NeverScrollableScrollPhysics(),
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: screenHeight * 0.7,
                                child: Stack(
                                  children: [
                                    Container(
                                      child: GoogleMap(
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(driver_lat!, driver_lang!),
                                            zoom: CAMERA_ZOOM,
                                          ),
                                          myLocationEnabled: true,
                                          tiltGesturesEnabled: true,
                                          compassEnabled: true,
                                          scrollGesturesEnabled: true,
                                          zoomGesturesEnabled: true,
                                          markers: Set<Marker>.of(markers.values),
                                          polylines: Set<Polyline>.of(polylines.values),

                                          onMapCreated: onMapCreated),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  full = true;
                                  full1 = false;
                                  vi_address = true;
                                });
                              },
                              child: Visibility(
                                visible: full1,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(
                                      left: 0, bottom: 0, right: 0),
                                  child:
                                      SvgPicture.asset("images/map_zoom.svg"),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Visibility(
                                visible: vi_address,
                                child: Container(
                                  height: ScreenUtil().setHeight(220),
                                  margin: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 60),
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              Languages.of(context)!.oidlable +
                                                  "   " +
                                                  orderId,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                full = false;
                                                full1 = true;
                                                vi_address = false;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, bottom: 0, right: 0),
                                              child: SvgPicture.asset(
                                                  "images/map_zoom.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(150),
                                        margin: EdgeInsets.only(top: 20),
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: 2,
                                            itemBuilder: (con, index) {
                                              double lineTop = 0;
                                              double dotTop = 0;
                                              double statusTop = 0;
                                              Color? color;


                                              if (index == 0) {
                                              }

                                              if (index == 1) {
                                                lineTop = -30.0;
                                                dotTop = -42.0;
                                                statusTop = -35.0;
                                                color =
                                                    Color(Constants.greentext);
                                              }

                                              return index != 0
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                          Row(children: [
                                                            Column(
                                                              children:
                                                                  List.generate(
                                                                4,
                                                                (ii) => Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              9,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    transform: Matrix4
                                                                        .translationValues(
                                                                            1.0,
                                                                            lineTop,
                                                                            0.0),
                                                                    height: 20,
                                                                    width: 2,
                                                                    color:
                                                                        color,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              color: Colors
                                                                  .transparent,
                                                              height: 0.5,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 20,
                                                              ),
                                                            ))
                                                          ]),
                                                          Row(children: [
                                                            Container(
                                                              transform: Matrix4
                                                                  .translationValues(
                                                                      3.0,
                                                                      dotTop,
                                                                      0.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "images/kitchen.svg"),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height: 40,
                                                                color: Colors
                                                                    .transparent,
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        20.0,
                                                                        statusTop,
                                                                        0.0),

                                                                child: ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            vendorname,
                                                                            style: TextStyle(
                                                                                color: Color(Constants.whitetext),
                                                                                fontSize: 16,
                                                                                fontFamily: Constants.app_font_bold)),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 35),
                                                                          child:
                                                                              RichText(
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textScaleFactor:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                WidgetSpan(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 5),
                                                                                    child: SvgPicture.asset(
                                                                                      "images/location.svg",
                                                                                      width: 13,
                                                                                      height: 13,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                WidgetSpan(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 5),
                                                                                    child: Text(
                                                                                      distance + Languages.of(context)!.kmfarawaylable,
                                                                                      style: TextStyle(
                                                                                        color: Color(Constants.whitetext),
                                                                                        fontSize: 12,
                                                                                        fontFamily: Constants.app_font,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 2),
                                                                      child: Text(
                                                                          vendorAddress,
                                                                          maxLines:
                                                                              3,
                                                                          overflow: TextOverflow
                                                                              .visible,
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 12,
                                                                              fontFamily: Constants.app_font)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ])
                                                        ])
                                                  : Row(children: [
                                                      Container(
                                                        transform: Matrix4
                                                            .translationValues(
                                                                2.0, -12, 0.0),
                                                        child: SvgPicture.asset(
                                                            "images/map.svg",
                                                            width: 20,
                                                            height: 20),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: 55,
                                                          color: Colors
                                                              .transparent,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 0,
                                                                  right: 10),
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            children: [
                                                              Text(
                                                                  Languages.of(
                                                                          context)!
                                                                      .yourlocationlable,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .whitetext),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          Constants
                                                                              .app_font_bold)),
                                                              Text(driver_address,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .whitetext),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          Constants
                                                                              .app_font)),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ]);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: full,
                            child: new Container(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    child: GestureDetector(
                                  onTap: () {
                                    _OpenCancelBottomSheet(id, context);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0, right: 0, bottom: 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              color: Color(Constants.redtext),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset:
                                                      Offset(0.0, 0.0), //(x,y)
                                                  blurRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                            height: screenHeight * 0.08,
                                            child: Center(
                                              child: Container(
                                                color: Color(Constants.redtext),
                                                child: Text(
                                                  Languages.of(context)!
                                                      .canceldeliverylable,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          Constants.app_font),
                                                ),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Constants.CheckNetwork()
                                                .whenComplete(() =>
                                                    CallApiForPickUporder(context));
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 0, bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                color:
                                                    Color(Constants.greentext),
                                                boxShadow: [BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(
                                                        0.0, 0.0), //(x,y)
                                                    blurRadius: 0.0,
                                                  ),],
                                              ),
                                              height: screenHeight * 0.08,
                                              child: Center(
                                                child: Container(
                                                  color: Color(
                                                      Constants.greentext),
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .pickupanddeliverlable,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            )),
                      ],
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async{
    return true;
  }

  void _OpenCancelBottomSheet(String? id, BuildContext context12) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // final _formKey = GlobalKey<FormState>();
    // String _review = "";

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Color(Constants.itembgcolor),
        builder: (context1) {
          return StatefulBuilder(
            builder: (context1, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 20, left: 20, bottom: 0, right: 10),
                        child: Text(
                          Languages.of(context)!.telluslable,
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 18,
                              fontFamily: Constants.app_font),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 20, bottom: 0, right: 10),
                        child: Text(
                          Languages.of(context)!.whycancellable,
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 18,
                              fontFamily: Constants.app_font),
                        ),
                      ),
                      ListView.builder(
                          itemCount: can_reason.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, position) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 10, left: 10, bottom: 0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    can_reason[position],
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Color(Constants.greaytext),
                                        fontSize: 12,
                                        fontFamily: Constants.app_font),
                                  ),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          Color(Constants.whitetext),
                                      disabledColor: Color(Constants.whitetext),
                                    ),
                                    child: Radio<String>(
                                      activeColor: Color(Constants.greentext),
                                      value: can_reason[position],
                                      groupValue: _cancelReason,
                                      onChanged: (value) {
                                        setState(() {
                                          _cancelReason = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, bottom: 20, right: 20),
                        child: Card(
                          color: Color(Constants.bgcolor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              validator: Constants.kvalidateFullName,
                              keyboardType: TextInputType.text,
                              controller: _text_cancel_reason_controller,
                              maxLines: 5,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: Constants.app_font_bold),
                              decoration: Constants.kTextFieldInputDecoration
                                  .copyWith(
                                      contentPadding: EdgeInsets.only(
                                          left: 20, top: 20, right: 20),
                                      hintText: Languages.of(context)!
                                          .cancelreasonlable,
                                      hintStyle: TextStyle(
                                          color: Color(Constants.greaytext),
                                          fontFamily: Constants.app_font,
                                          fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("RadioValue:$_cancelReason");

                          if (_cancelReason == "0") {
                            Constants.toastMessage(
                                Languages.of(context)!.selectcancelreasonlable);
                          } else if (_cancelReason ==
                              Languages.of(context)!.otherreasonlable) {
                            if (_text_cancel_reason_controller.text.length ==
                                0) {
                              Constants.toastMessage(
                                  Languages.of(context)!.addreasonlable);
                            } else {
                              _cancelReason =
                                  _text_cancel_reason_controller.text;
                            }
                          } else {
                            Constants.CheckNetwork().whenComplete(() =>
                                CallApiForCacelorder(
                                    id, _cancelReason, context12));
                            Navigator.pop(context12);
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                top: 10, left: 10, bottom: 20, right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              color: Color(Constants.greentext),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.0), //(x,y)
                                  blurRadius: 0.0,
                                ),
                              ],
                            ),
                            width: screenWidth,
                            height: screenHeight * 0.07,
                            child: Center(
                              child: Container(
                                color: Color(Constants.greentext),
                                child: Text(
                                  Languages.of(context)!.submitreviewlable,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: Constants.app_font),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void onMapCreated(GoogleMapController googleMapController) {

    check().then((intenet) async {
      if (intenet) {
        setState(() {
          showSpinner = true;
        });

        try{
          _controller.complete(googleMapController);

          PolylinePoints polylinePoints = PolylinePoints();
          PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyDOz5oWyuWCeyh-9c1W5gexDzRakcRP-eM',
              PointLatLng(driver_lat!, driver_lang!), PointLatLng(vendor_lat, vendor_lang));
          print(result.points);
          if (result.points.isNotEmpty) {
            result.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          }

          PolylineId id = PolylineId("poly");
          Polyline polyline = Polyline(
              polylineId: id, color: Colors.green, points: polylineCoordinates);
          polylines[id] = polyline;
        }catch (e){
          print(e.toString());
        }

        setState(() {
          showSpinner = false;
        });
       /* hereMapController.mapScene.loadSceneForMapScheme(MapScheme.greyNight,
            (error) {
          if (error != null) {
            print('Error:' + error.toString());
            return;
          }
        });

        drawdriverDot(hereMapController, 0, GeoCoordinates(driver_lat, driver_lang));

        drawRoute(GeoCoordinates(driver_lat, driver_lang),
            GeoCoordinates(vendor_lat, vendor_lang), hereMapController);
        drawvendorDot(
            hereMapController, 2, GeoCoordinates(vendor_lat, vendor_lang));
        double distanceToEarthInMeters = 5000;
        hereMapController.camera.lookAtPointWithDistance(
            GeoCoordinates(driver_lat, driver_lang), distanceToEarthInMeters);
*/

      } else {
        showDialog(
          builder: (context) => AlertDialog(
            title: Text(Languages.of(context)!.checkinternetlable),
            content: Text(Languages.of(context)!.internetconnectionlable),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetOrderKitchen(),
                      ));
                },
                child: Text(Languages.of(context)!.oklable),
              )
            ],
          ),
          context: context,
        );
      }
    });
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  /*Future<void> drawdriverDot(
    HereMapController hereMapController,
    int drawOrder,
    GeoCoordinates geoCoordinates,
  ) async {
    ByteData fileData = await rootBundle.load('images/driver_map_image_7.png');
    Uint8List pixelData = fileData.buffer.asUint8List();
    MapImage mapImage =
        MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    mapMarker.drawOrder = drawOrder;
    hereMapController.mapScene.addMapMarker(mapMarker);
  }*/

 /* Future<void> adddrivermarker(
    HereMapController hereMapController,
    int drawOrder,
    GeoCoordinates geoCoordinates,
  ) async {
    ByteData fileData = await rootBundle.load('images/driver_map_image_7.png');
    Uint8List pixelData = fileData.buffer.asUint8List();
    MapImage mapImage =
        MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    mapMarker.drawOrder = drawOrder;
    hereMapController.mapScene.addMapMarker(mapMarker);
  }*/

 /* Future<void> drawvendorDot(
    HereMapController hereMapController,
    int drawOrder,
    GeoCoordinates geoCoordinates,
  ) async {
    ByteData fileData = await rootBundle.load('images/food_map_image_4.png');
    Uint8List pixelData = fileData.buffer.asUint8List();
    MapImage mapImage =
        MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    mapMarker.drawOrder = drawOrder;
    hereMapController.mapScene.addMapMarker(mapMarker);
  }*/

  /*Future<void> drawRoute(GeoCoordinates start, GeoCoordinates end,
      HereMapController hereMapController) async {
    RoutingEngine routingEngine = RoutingEngine();
    Waypoint startWayPoint = Waypoint.withDefaults(start);
    Waypoint endWayPoint = Waypoint.withDefaults(end);

    List<Waypoint> wayPoints = [startWayPoint, endWayPoint];
    Waypoint(start, WaypointType.passThrough, 100, 60, 360);

    routingEngine.calculateCarRoute(wayPoints, CarOptions.withDefaults(),
        (routingError, routes) {
      if (routingError == null) {
        var route = routes.first;
        GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);
double depth = 10;
        _mapPolyline = MapPolyline(routeGeoPolyline, depth, Colors.green);

        hereMapController.mapScene.addMapPolyline(_mapPolyline);
      }
    });
  }*/
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: Color(Constants.redtext),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 0.0,
                        ),
                      ],
                    ),
                    height: screenHeight * 0.08,
                    child: Center(
                      child: Container(
                        color: Color(Constants.redtext),
                        child: Text(
                          Languages.of(context)!.canceldeliverylable,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: Constants.app_font),
                        ),
                      ),
                    )),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {

                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Color(Constants.greentext),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 0.0,
                          ),
                        ],
                      ),
                      height: screenHeight * 0.08,
                      child: Center(
                        child: Container(
                          color: Color(Constants.greentext),
                          child: Text(
                            Languages.of(context)!.pickupanddeliverlable,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: Constants.app_font),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
