import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/config/screen_config.dart';
import 'package:driver_3_0_5/controller/map_controller.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import '../homescreen.dart';
import '../orderdeliverdscreen.dart';

class PickupScreen extends StatefulWidget {
  final double driverLat;
  final double driverLang;
  final double vendorLat;
  final double vendorLang;
  final double userLat;
  final double userLang;
  final String userAddress;
  final String orderId;
  final String orderStatus;
  final String vendorname;
  final String  distance;
  final String  vendorAddress;
  final String price;
  final double heading;
  final String paymentType;
  const PickupScreen({Key? key,
    required this.driverLat,
    required this.driverLang,
    required this.vendorLat,
    required this.vendorLang,
    required this.userLat,
    required this.userLang,
    required this.orderId,
    required this.orderStatus,required this.vendorname,required this.distance,required this.vendorAddress,required this.price,required this.heading,required this.paymentType,
    required this.userAddress}) : super(key: key);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  MapController mapController=Get.find();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  double CAMERA_ZOOM = 14.4746;
  double CAMERA_TILT = 80;
  double CAMERA_BEARING = 30;
  double currentLat=0.0;
  double currentLang=0.0;
  bool pickupStatus=false;
  bool _saving = false;
  GoogleMapController? _controller;
  late String cancel_reason;
  List can_reason = [];
  String? _cancelReason = "0";
  final _text_cancel_reason_controller = TextEditingController();
  Timer? timer;
  startTimer(){
    timer=Timer.periodic(Duration(seconds: 10), (timer)async {
      print("timer");
      LocationData event=await mapController.location.getLocation();
      await mapController.updateMarker(event.latitude!,event.longitude!,widget.vendorLat,widget.vendorLang,widget.userLat,widget.userLang,event.heading!);
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(event.latitude!,event.longitude!),
              zoom: 17,
              tilt: CAMERA_TILT,
              bearing: CAMERA_BEARING
          )));
    });
  }
  @override
  void initState() {
    cancel_reason = PreferenceUtils.getString(Constants.cancel_reason);
    var json = JsonDecoder().convert(cancel_reason);
    startTimer();
    can_reason.addAll(json);
    currentLat=widget.driverLat;
    currentLang=widget.driverLang;
    print('orderstatus');
    print("${widget.userLat},${widget.userLang}");
    if(widget.orderStatus=='PICKUP'){
      mapController.addUserAndDriverMarkersAndPolyLines(widget.driverLat, widget.driverLang, widget.userLat,widget.userLang,widget.heading);
      pickupStatus=true;
    }else{
      mapController.addMarkersAndPolyLines(widget.driverLat, widget.driverLang, widget.vendorLat, widget.vendorLang,widget.userLat,widget.userLang,widget.heading);

    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return WillPopScope(
      onWillPop: () async{
        //_orderListController.CallApiForGetOrderList();
        timer?.cancel();

        _controller?.dispose();

        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(0)));
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          body: ModalProgressHUD(
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator:
            SpinKitFadingCircle(color: Color(Constants.greentext)),
            child: Column(
            children: [
              SizedBox(
                width: ScreenConfig.screenWidth,
                height: ScreenConfig.blockHeight*75,
                child: GetBuilder(
                    init: MapController(),
                    builder: (MapController value){
                      return GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition:CameraPosition(
                          target: LatLng(currentLat, currentLang),
                          zoom: CAMERA_ZOOM,
                        ),
                        markers: Set<Marker>.of(value.markers.values),
                        polylines: Set<Polyline>.of(value.polylines.values),
                        //buildingsEnabled: false,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        indoorViewEnabled: false,
                        buildingsEnabled: false,
                        minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                        onMapCreated: (GoogleMapController controller) {
                          _controller=controller;
                        },
                      );
                    }),
              ),
            SizedBox(
              height:ScreenConfig.blockHeight*15,
              width: ScreenConfig.screenWidth,
            child:  ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DataTable(columns: [
                  DataColumn(label: Text('Vendor Name')),
                  DataColumn(label: Text('Vendor Address')),
                  DataColumn(label: Text('User Address')),
                  DataColumn(label: Text('Distance')),
                  DataColumn(label: Text('Amount')),
                ], rows: [
                  DataRow(
                      cells: [
                        DataCell(Text(widget.vendorname),),
                        DataCell(Text(widget.vendorAddress),),
                        DataCell(Text(widget.userAddress),),
                        DataCell(  Text(widget.distance+"KM"),),
                        DataCell(  Text(widget.price),),
                      ]
                  )
                ])
              ],
            )
            ),
              SizedBox(
                  height:ScreenConfig.blockHeight*10,
                  width: ScreenConfig.screenWidth,
                  child:(!pickupStatus)? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: (){

                              _OpenCancelBottomSheet(widget.orderId,context);


                          },
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
                              child: Center(
                                child: Container(
                                  color: Color(Constants.redtext),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: Constants.app_font),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async{
                          final result= await showDialog(
                              context: context,
                              builder: (context) => Padding(
                                padding: EdgeInsets.all(16.0),
                                child: AlertDialog(
                                  title: new Text('Did you pickup the order?'),
                                  actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context,"NO"),
                                        child: Text(Languages.of(context)!.nolable),
                                      ),
                                      GestureDetector(
                                        onTap: ()=> Navigator.pop(context,"YES"),
                                        child: Text(Languages.of(context)!.yeslable),
                                      ),
                                    ],
                                  ),
                                    SizedBox(
                                      height: ScreenConfig.blockHeight*2,
                                    )
                                  ],
                                ),
                              ),
                            );
                          if(result=='YES'){
                            setState(() {
                              _saving = true;
                            });

                            await CallApiForPickUporder(context, widget.orderId);
                            setState(() {
                              _saving = false;
                            });

                          }



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
                              child: Center(
                                child: Container(
                                  color: Color(Constants.greentext),
                                  child: Text(
                                    "Pickup",
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
                  )
                      :Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async{
                            final result= await showDialog(
                              context: context,
                              builder: (context) => new AlertDialog(
                                title: new Text('Did you delivered ${widget.paymentType!='COD'?'':'and Received the cash ${widget.price}'}'),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context,"NO"),
                                        child: Text(Languages.of(context)!.nolable),
                                      ),
                                      GestureDetector(
                                        onTap: ()=> Navigator.pop(context,"YES"),
                                        child: Text(Languages.of(context)!.yeslable),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenConfig.blockHeight*2,
                                  )
                                ],
                              ),
                            );
                            if(result=='YES'){
                              setState(() {
                                _saving=true;
                              });
                              await CallApiForDeliver(context,widget.orderId);
                            }
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
                              child: Center(
                                child: Container(
                                  color: Color(Constants.greentext),
                                  child: Text(
                                    "Delivered",
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
                  )

              )
            ],
          ),inAsyncCall: _saving,)
      ),
    );

  }
  Future<bool> CallApiForPickUporder(BuildContext context,String id) async{
    try {
      timer?.cancel();
      String? response=await RestClient(Api_Header().Dio_Data())
          .orderstatuschange1(id, "PICKUP");
      print("order_response:$response");

      final body = json.decode(response!);
      bool? sucess = body['success'];
      // bool sucess =response.success;
      if (sucess = true) {
        LocationData locationData=await mapController.location.getLocation();
        print('location fetch successfully');
        await mapController.addUserAndDriverMarkersAndPolyLines(locationData.latitude!, locationData.longitude!, widget.userLat, widget.userLang,locationData.heading!);
        setState(() {
          pickupStatus=true;
        });
        // Constants.createSnackBar(msg, context, Color(Constants.greentext));
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickUpOrder()));
      } else if (sucess == false) {
        var msg = Languages.of(context)!.tryagainlable;
        // print(msg);
        Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
      }
      startTimer();
      return true;
    }  catch (e,stk) {
      print(e);
      print(stk);
      startTimer();
      return false;

    }
  }
  Future<void> CallApiForDeliver(BuildContext context,String id) async{
    try {
      timer?.cancel();
      if (mounted) {
        RestClient(Api_Header().Dio_Data())
            .orderstatuschange1(id, "DELIVERED")
            .then((response)async {
          print("order_response:$response");

          final body = json.decode(response!);
          bool? sucess = body['success'];
          // bool sucess =response.success;
          if (sucess = true) {
            // Constants.createSnackBar(msg, context, Color(Constants.greentext));
            Navigator.of(this.context)
                .push(MaterialPageRoute(builder: (context) => OrderDeliverd()));
          } else if (sucess == false) {
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
          print("error:$obj");
          print(obj.runtimeType);
          //AppConstant.toastMessage("Internal Server Error");
        });
      }
      startTimer();
    }catch (e,stk) {
      print(e);
      print(stk);
      startTimer();
    }

  }
  void _OpenCancelBottomSheet(String id, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // final _formKey = GlobalKey<FormState>();
    // String _review = "";

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Color(Constants.itembgcolor),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
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
                                width: screenWidth,
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, bottom: 0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 0, left: 0, bottom: 0, right: 0),
                                      child: Text(
                                        // can_reason[position],
                                        can_reason[position],
                                        overflow: TextOverflow.visible,
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Color(Constants.greaytext),
                                            fontSize: 12,
                                            fontFamily: Constants.app_font),
                                      ),
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

                                            // _handleRadioValueChange;
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

                              // Constants.createSnackBar("Select Cancel Reason", context, Color(Constants.redtext));
                            } else if (_cancelReason ==
                                Languages.of(context)!.otherreasonlable) {
                              if (_text_cancel_reason_controller.text.length ==
                                  0) {
                                Constants.toastMessage(
                                    Languages.of(context)!.addreasonlable);
                                // Constants.createSnackBar("Add Reason", context, Color(Constants.redtext));
                              } else {
                                _cancelReason =
                                    _text_cancel_reason_controller.text;
                                Constants.CheckNetwork().whenComplete(
                                        () => CallApiForCancelorder(id, _cancelReason));
                              }
                            } else {
                              Constants.CheckNetwork().whenComplete(
                                      () => CallApiForCancelorder(id, _cancelReason));
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
                ),
              );
            },
          );
        });
  }
  void CallApiForCancelorder(String id, String? cancelReason)async {
    setState(() {
      _saving=true;
    });
    try {
      String? response= await RestClient(Api_Header().Dio_Data())
          .cancelorder(id, "CANCEL", cancelReason);
      print("order_response:$response");

      final body = json.decode(response!);
      bool? sucess = body['success'];
      if (sucess = true) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(0)));


      } else if (sucess == false) {
        setState(() {
          _saving=false;
        });

        var msg = Languages.of(context)!.tryagainlable;
        // print(msg);
        Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
      }
    } catch (e) {
      setState(() {
        _saving=false;
      });
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("error:$e");
      print(e.runtimeType);
    }

  }
  @override
  void dispose()async {
    // GoogleMapController _control =_controller!;
    timer?.cancel();
    _controller?.dispose();
    super.dispose();


  }
}