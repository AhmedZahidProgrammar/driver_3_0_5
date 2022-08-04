import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/controller/map_controller.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/model/orderlistdata.dart';
import 'package:driver_3_0_5/screen/order/pickupScreen.dart';
import 'package:driver_3_0_5/screen/selectlocationscreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:driver_3_0_5/widget/transitions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/cart_master.dart';
import 'order_details_screen.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderList createState() => _OrderList();
}

class _OrderList extends State<OrderList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? _cancelReason = "0";
  // String _result = "0";
  bool isOnline = false;
  bool showSpinner = false;

  String? name;
  String? location;
  int? status;

  // ProgressDialog pr;
  bool showduty = false;
  bool hideduty = false;
  bool nojob = true;
  bool lastorder = false;
  late String cancel_reason;
  List can_reason = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  List<OrderData> orderdatalist = <OrderData>[];
  double current_lat = 0;
  double current_long = 0;

  final _text_cancel_reason_controller = TextEditingController();
  // Position? _currentPosition;
  // String? _currentAddress;
  MapController mapController=Get.put(MapController());

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    PreferenceUtils.init();

    if (mounted) {
      setState(() {
        name = PreferenceUtils.getString(Constants.driverfirstname) +
            " " +
            PreferenceUtils.getString(Constants.driverlastname);
        location = PreferenceUtils.getString(Constants.driverzone);
        cancel_reason = PreferenceUtils.getString(Constants.cancel_reason);
        var json = JsonDecoder().convert(cancel_reason);
        can_reason.addAll(json);
        print("name123:$name");
      });
    }

    // if (mounted) {
    if (PreferenceUtils.getstatus(Constants.isonline) == true) {
      // setState(() {
      isOnline = true;
      nojob = true;
      hideduty = false;
      showduty = false;

      // Constants.CheckNetwork().whenComplete(() => pr.show());
      Constants.CheckNetwork().whenComplete(() => CallApiForGetOrderList());

      checkforpermission();
      // });
    } else {
      setState(() {
        isOnline = false;
        nojob = false;
        hideduty = true;
        showduty = false;
      });
    }
  }
  _launchURL(String ur) async {
    Uri url=Uri.parse(ur);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void checkforpermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print("denied");
    } else if (permission == LocationPermission.whileInUse) {
      print("whileInUse56362");
      _getCurrentLocation();
      // Constants.CheckNetwork().whenComplete(() => CallApiForGetOrderList());

    } else if (permission == LocationPermission.always) {
      print("always");
      _getCurrentLocation();
      // Constants.CheckNetwork().whenComplete(() => CallApiForGetOrderList());

    }
  }

  Future<void> CallApiForGetOrderList() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(Api_Header().Dio_Data()).driveorderlist().then((response) {
      if (mounted) {
        print("OrderList:$response");
        if (response.success = true) {
          if (response.data!.length != 0) {
            orderdatalist.clear();
            orderdatalist.addAll(response.data!);
            print("orderdatalistLength:${orderdatalist.length}");
            nojob = false;
            showduty = true;

            setState(() {
              showSpinner = false;
            });

            // return true;
          } else {
            print("orderdatalistLength000:${orderdatalist.length}");
            setState(() {
              showSpinner = false;
            });

            nojob = true;
            showduty = false;

            // return false;

            //show no new order
          }
        } else {
          setState(() {
            showSpinner = false;
          });

          nojob = true;
          showduty = false;

          // return false;
        }
      }
    }).catchError((e,stk) {
      print(e);
      print(stk);
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print("error:$obj");
      // print(obj.runtimeType);
      nojob = true;
      showduty = false;

      setState(() {
        showSpinner = false;
      });

      // return false;
      //AppConstant.toastMessage("Internal Server Error");
    });
  }

  void CallApiForUpdateStatus(bool isOnline) {
    setState(() {
      showSpinner = true;
      showSpinner = true;
    });
    print(isOnline);

    if (mounted) {
      if (isOnline == true) {
        status = 1;
        print(status);
      } else if (isOnline == false) {
        status = 0;
        print(status);
      }
      RestClient(Api_Header().Dio_Data())
          .driverupdatestatus(status.toString())
          .then((response) {
        final body = json.decode(response!);
        bool? sucess = body['success'];
        if (sucess = true) {
          print("duty:$isOnline");

          setState(() {
            if (isOnline == true) {
              setState(() {
                showSpinner = false;
              });
              nojob = true;
              hideduty = false;
              showduty = false;

              PreferenceUtils.setstatus(Constants.isonline, true);

              checkforpermission();

              // Constants.CheckNetwork().whenComplete(() => pr.show());
              Constants.CheckNetwork()
                  .whenComplete(() => CallApiForGetOrderList());
            } else if (isOnline == false) {
              nojob = false;
              hideduty = true;
              showduty = false;
              PreferenceUtils.setstatus(Constants.isonline, false);
              setState(() {
                showSpinner = false;
              });
            }
          });

          setState(() {
            showSpinner = false;
          });
          var msg = body['data'];
          Constants.createSnackBar(msg, this.context, Color(Constants.greentext));
        } else if (sucess == false) {
          setState(() {
            showSpinner = false;
          });
          var msg = body['data'];
          // print(msg);
          Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
        }
      }).catchError((Object obj) {
        final snackBar = SnackBar(
          content: Text(Languages.of(context)!.servererrorlable),
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

  void CallApiForAcceptorder(
      String id,
      String orderId,
      String? vendor_name,
      String? vendor_address,
      String distance,
      String? vendor_lat,
      String? vendor_lang,
      String? user_lat,
      String? user_lang,
      String? user_address,
      String? vendor_image,
      String? user_name,
      String status,
      String amount,
      String payementType)async {
    print(id);
    setState(() {
      showSpinner = true;
    });

    if (mounted) {
      RestClient(Api_Header().Dio_Data())
          .orderstatuschange1(id, "ACCEPT")
          .then((response) async {
        print("order_response:$response");

        final body = json.decode(response!);
        bool? sucess = body['success'];
        // bool sucess =response.success;
        if (sucess = true) {

          // _firebaseController.createOrderNode(id,postion.latitude,postion.longitude,double.parse(user_lat!),double.parse(user_lang!),double.parse(vendor_lat!),double.parse(vendor_lang!));


          // PreferenceUtils.setString(Constants.previos_order_status, "ACCEPT");
          // PreferenceUtils.setString(Constants.previos_order_id, id);
          // PreferenceUtils.setString(Constants.previos_order_orderid, orderId);
          // PreferenceUtils.setString(
          //     Constants.previos_order_vendor_name, vendor_name!);
          // if(vendor_address != null){
          //   PreferenceUtils.setString(Constants.previos_order_vendor_address, vendor_address);
          // }else{
          //   PreferenceUtils.setString(Constants.previos_order_vendor_address, '');
          // }
          //
          // PreferenceUtils.setString(Constants.previos_order_distance, distance);
          // PreferenceUtils.setString(
          //     Constants.previos_order_vendor_lat, vendor_lat!);
          // PreferenceUtils.setString(
          //     Constants.previos_order_vendor_lang, vendor_lang!);
          // PreferenceUtils.setString(Constants.previos_order_user_lat, user_lat!);
          // PreferenceUtils.setString(
          //     Constants.previos_order_user_lang, user_lang!);
          // PreferenceUtils.setString(
          //     Constants.previos_order_user_address, user_address!);
          // PreferenceUtils.setString(
          //     Constants.previos_order_vendor_image, vendor_image!);
          // PreferenceUtils.setString(
          //     Constants.previos_order_user_name, user_name!);
          LocationData locationData=await  mapController.location.getLocation();


          Navigator.of(this.context)
              .push(MaterialPageRoute(builder: (context) =>
          //GetOrderKitchen()

          PickupScreen(
            driverLang: locationData.longitude!,
            vendorLang: double.parse(vendor_lang!),
            driverLat: locationData.latitude!,
            vendorLat: double.parse(vendor_lat!),
            userLang: double.parse(user_lang!),
            userLat:double.parse(user_lat!),
            orderId: id, orderStatus: status,
            vendorAddress: vendor_address!,
            distance: distance,
            vendorname: vendor_name!,
            price: amount,
            heading: locationData.heading!,
            paymentType: payementType,
            userAddress: user_address??'' ,)
          ));
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
          content: Text(Languages.of(context)!.servererrorlable),
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

  void CallApiForCancelorder(String id, String? cancelReason) {
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
          var msg = Languages.of(context)!.ordercancellable;
          Constants.createSnackBar(msg, this.context, Color(Constants.greentext));

          if (mounted) {
            setState(() {
              lastorder = false;
              Constants.CheckNetwork()
                  .whenComplete(() => CallApiForGetOrderList());
            });
          }
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
    double screenWidth = MediaQuery.of(context).size.width;
    /* ScreenUtil.init(context,
        designSize: Size(screenWidth, screenHeight), allowFontScaling: true);
*/
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      CallApiForGetOrderList();
      print("notification occur");
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background_image.png'),
                fit: BoxFit.cover,
              )),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              // resizeToAvoidBottomPadding: true,
              key: _scaffoldKey,
              body: RefreshIndicator(
                color: Color(Constants.greentext),
                backgroundColor: Colors.transparent,
                onRefresh: CallApiForGetOrderList,
                key: _refreshIndicatorKey,
                child: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  opacity: 1.0,
                  color: Colors.transparent.withOpacity(0.2),
                  progressIndicator:
                  SpinKitFadingCircle(color: Color(Constants.greentext)),
                  child: LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 0),
                            color: Colors.transparent,
                            child: Column(
                              // physics: NeverScrollableScrollPhysics(),
                              // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(0)),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 0, bottom: 0, left: 0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(0),
                                          right: ScreenUtil().setWidth(0)),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: ScreenUtil().setHeight(55),
                                        color: Color(Constants.bgcolor),
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (PreferenceUtils.getBool(
                                                        Constants
                                                            .isGlobalDriver) ==
                                                        true) {
                                                      Navigator.of(context)
                                                          .push(Transitions(
                                                          transitionType:
                                                          TransitionType
                                                              .slideLeft,
                                                          curve: Curves
                                                              .slowMiddle,
                                                          reverseCurve: Curves
                                                              .slowMiddle,
                                                          widget:
                                                          SelectLocation()));
                                                    } else {
                                                      Constants.toastMessage(
                                                          Constants
                                                              .notGlobalDriverSlogan);
                                                    }
                                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectLocation()));
                                                  },
                                                  child: ListView(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20, top: 10),
                                                        child: Text(
                                                          name != null
                                                              ? name!
                                                              : Languages.of(
                                                              context)!
                                                              .userlable,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontFamily: Constants
                                                                  .app_font_bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin:
                                                          EdgeInsets.only(
                                                              left: 20,
                                                              top: 0),
                                                          child: RichText(
                                                            maxLines: 1,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            textScaleFactor: 1,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text: location !=
                                                                        null
                                                                        ? location
                                                                        : Languages.of(context)!
                                                                        .setlocationlable,
                                                                    style:
                                                                    TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                      14,
                                                                      fontFamily:
                                                                      Constants
                                                                          .app_font,
                                                                    )),
                                                                WidgetSpan(
                                                                  child:
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: 5,
                                                                        top: 0,
                                                                        bottom:
                                                                        3),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "images/down_arrow.svg",
                                                                      width: 8,
                                                                      height: 8,
                                                                    ),
                                                                  ),
                                                                ),

                                                                //
                                                              ],
                                                            ),
                                                          )
                                                        // child: Text("London, United Kingdom",
                                                        //   style: TextStyle(color: Colors.white,fontFamily: Constants.app_font,fontSize: 14),),

                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        top: 0,
                                                        right: 0),
                                                    child: Transform.scale(
                                                      scale: 0.6,
                                                      child: CupertinoSwitch(
                                                          trackColor: Color(
                                                              Constants
                                                                  .color_black),
                                                          activeColor: Color(
                                                              Constants
                                                                  .greentext),
                                                          value: isOnline,
                                                          onChanged: (newval) {
                                                            setState(() {
                                                              isOnline =
                                                              !isOnline;

                                                              Constants
                                                                  .CheckNetwork()
                                                                  .whenComplete(() =>
                                                                  CallApiForUpdateStatus(
                                                                      isOnline));
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: showduty,
                                  child: ListView.builder(
                                    itemCount: orderdatalist.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String paymentstatus;
                                      String paymentType;
                                      Color paymentcolor;
                                      if (orderdatalist[index]
                                          .paymentStatus
                                          .toString() ==
                                          "0") {
                                        paymentstatus = "Pending";
                                        paymentcolor = Color(Constants.redtext);
                                      } else {
                                        paymentstatus = "Completed";
                                        paymentcolor =
                                            Color(Constants.greentext);
                                      }

                                      if (orderdatalist[index]
                                          .paymentType
                                          .toString() ==
                                          "COD") {
                                        paymentType = Languages.of(context)!
                                            .cashondeliverylable;
                                      } else {
                                        paymentType = orderdatalist[index]
                                            .paymentType
                                            .toString();
                                      }

                                      double user_lat = double.parse(
                                          orderdatalist[index].userAddress!.lat!);
                                      double user_long = double.parse(
                                          orderdatalist[index]
                                              .userAddress!
                                              .lang!);

                                      // assert(user_lat is double);
                                      // assert(user_long is double);

                                      String distance = "0";
                                      double distanceInMeters =
                                      Geolocator.distanceBetween(
                                          current_lat,
                                          current_long,
                                          user_lat,
                                          user_long);
                                      double distanceinkm =
                                          distanceInMeters / 1000;
                                      String str = distanceinkm.toString();
                                      var distance12 = str.split('.');
                                      distance = distance12[0];
                                      // print("km123:$distance");

                                      return GestureDetector(
                                        onTap: (){
                                          CartMaster cartMaster=CartMaster.fromMap(jsonDecode(orderdatalist[index]
                                              .orderData!));
                                          Get.to(()=>OrderDetailsScreen(cartMaster:cartMaster));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(8)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                right: 5,
                                                bottom: 0,
                                                left: 5),
                                            decoration: BoxDecoration(
                                                color:
                                                Color(Constants.itembgcolor),
                                                border: Border.all(
                                                  color: Color(
                                                      Constants.itembgcolor),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil().setWidth(0),
                                                  right:
                                                  ScreenUtil().setWidth(0)),
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15,
                                                          left: 15,
                                                          right: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            Languages.of(context)!
                                                                .oidlable +
                                                                "    " +
                                                                orderdatalist[
                                                                index]
                                                                    .orderId!,
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontFamily: Constants
                                                                    .app_font_bold,
                                                                fontSize: 16),
                                                          ),
                                                          Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                            child: Text(
                                                              Languages.of(
                                                                  context)!
                                                                  .dollersignlable +
                                                                  orderdatalist[
                                                                  index]
                                                                      .amount
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .color_theme),
                                                                  fontFamily:
                                                                  Constants
                                                                      .app_font_bold,
                                                                  fontSize: 16),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      itemCount:
                                                      orderdatalist[index]
                                                          .orderItems!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, position) {
                                                        return Container(
                                                          margin: EdgeInsets.only(
                                                              top: 10, left: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                orderdatalist[
                                                                index]
                                                                    .orderItems![
                                                                position]
                                                                    .itemName!,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        Constants
                                                                            .greaytext),
                                                                    fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                    fontSize: 12),
                                                              ),
                                                              Text(
                                                                "  x " +
                                                                    orderdatalist[
                                                                    index]
                                                                        .orderItems![
                                                                    position]
                                                                        .qty
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        Constants
                                                                            .greentext),
                                                                    fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, left: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    border:
                                                                    Border
                                                                        .all(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(8))),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                    top: 5,
                                                                    left: 0,
                                                                    right: 5,
                                                                    bottom:
                                                                    30),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child:
                                                                CachedNetworkImage(
                                                                  // imageUrl: imageurl,
                                                                  imageUrl:
                                                                  orderdatalist[
                                                                  index]
                                                                      .vendor!
                                                                      .image!,
                                                                  fit:
                                                                  BoxFit.fill,
                                                                  width: ScreenUtil()
                                                                      .setWidth(
                                                                      180),
                                                                  height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                      55),
                                                                  // screenWidth *
                                                                  //     0.15,
                                                                  // height:
                                                                  // screenHeight *
                                                                  //     0.09,

                                                                  imageBuilder:
                                                                      (context,
                                                                      imageProvider) =>
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10.0),
                                                                        child: Image(
                                                                          image:
                                                                          imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                  placeholder: (context,
                                                                      url) =>
                                                                      SpinKitFadingCircle(
                                                                          color: Color(
                                                                              Constants.greentext)),
                                                                  errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                      Image.asset(
                                                                          "images/no_image.png"),
                                                                ),
                                                                // child: Image.asset(
                                                                //   "images/food.png",
                                                                //   fit: BoxFit.fill,
                                                                //   width: screenWidth *
                                                                //       0.15,
                                                                //   height: screenHeight *
                                                                //       0.09,
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              // width: screenWidth * 0.65,
                                                              height:
                                                              screenHeight *
                                                                  0.15,
                                                              color: Color(Constants
                                                                  .itembgcolor),
                                                              margin:
                                                              EdgeInsets.only(
                                                                  top: 20,
                                                                  left: 5,
                                                                  right: 5,
                                                                  bottom: 0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                        child:
                                                                        AutoSizeText(
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .name!,
                                                                          maxLines:
                                                                          1,
                                                                          overflow:
                                                                          TextOverflow.visible,
                                                                          style: TextStyle(
                                                                              color:
                                                                              Color(Constants.whitetext),
                                                                              fontFamily: Constants.app_font_bold,
                                                                              fontSize: 16),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 0,
                                                                                left: 0,
                                                                                right: 2,
                                                                                bottom: 0),
                                                                            alignment:
                                                                            Alignment.topRight,
                                                                            child:
                                                                            SvgPicture.asset(
                                                                              "images/veg.svg",
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 0,
                                                                                left: 2,
                                                                                right: 10,
                                                                                bottom: 0),
                                                                            alignment:
                                                                            Alignment.topRight,
                                                                            child:
                                                                            SvgPicture.asset(
                                                                              "images/nonveg.svg",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                        top:
                                                                        5,
                                                                        left:
                                                                        0,
                                                                        right:
                                                                        5,
                                                                        bottom:
                                                                        0),

                                                                    color: Colors
                                                                        .transparent,
                                                                    // height:screenHeight * 0.03,
                                                                    child:
                                                                    AutoSizeText(
                                                                      orderdatalist[
                                                                      index]
                                                                          .vendor!
                                                                          .mapAddress ?? '',
                                                                      overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                      maxLines: 3,
                                                                      style: TextStyle(
                                                                          color: Color(Constants
                                                                              .greaytext),
                                                                          fontFamily:
                                                                          Constants
                                                                              .app_font,
                                                                          fontSize:
                                                                          14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 20,
                                                          right: 0,
                                                          left: 5),
                                                      width: screenWidth,
                                                      child: DottedLine(
                                                        direction:
                                                        Axis.horizontal,
                                                        lineLength:
                                                        double.infinity,
                                                        lineThickness: 1.0,
                                                        dashLength: 8.0,
                                                        dashColor: Color(
                                                            Constants.dashline),
                                                        dashRadius: 0.0,
                                                        dashGapLength: 5.0,
                                                        dashGapColor:
                                                        Colors.transparent,
                                                        dashGapRadius: 0.0,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          left: 15,
                                                          right: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orderdatalist[index]
                                                                .user!
                                                                .name!,
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontFamily: Constants
                                                                    .app_font_bold,
                                                                fontSize: 16),
                                                          ),
                                                          RichText(
                                                            maxLines: 2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            textScaleFactor: 1,
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child:
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                        left:
                                                                        5,
                                                                        top:
                                                                        0,
                                                                        bottom:
                                                                        0,
                                                                        right:
                                                                        5),
                                                                    child:
                                                                    SvgPicture
                                                                        .asset(
                                                                      "images/location.svg",
                                                                      width: 13,
                                                                      height: 13,
                                                                    ),
                                                                  ),
                                                                ),

                                                                WidgetSpan(
                                                                  child:
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                        left:
                                                                        0,
                                                                        top:
                                                                        0,
                                                                        bottom:
                                                                        0,
                                                                        right:
                                                                        5),
                                                                    child: Text(
                                                                      distance +
                                                                          " " +
                                                                          Languages.of(context)!
                                                                              .kmfarawaylable,
                                                                      style:
                                                                      TextStyle(
                                                                        color: Color(
                                                                            Constants
                                                                                .whitetext),
                                                                        fontSize:
                                                                        12,
                                                                        fontFamily:
                                                                        Constants
                                                                            .app_font,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                //
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5,
                                                          left: 15,
                                                          right: 10),
                                                      child: Text(
                                                        orderdatalist[index]
                                                            .userAddress!
                                                            .address!,
                                                        overflow:
                                                        TextOverflow.visible,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            color: Color(Constants
                                                                .greaytext),
                                                            fontFamily: Constants
                                                                .app_font,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 30,
                                                          bottom: 20,
                                                          right: 0,
                                                          left: 5),
                                                      width: screenWidth,
                                                      child: DottedLine(
                                                        direction:
                                                        Axis.horizontal,
                                                        lineLength:
                                                        double.infinity,
                                                        lineThickness: 1.0,
                                                        dashLength: 8.0,
                                                        dashColor: Color(
                                                            Constants.dashline),
                                                        dashRadius: 0.0,
                                                        dashGapLength: 5.0,
                                                        dashGapColor:
                                                        Colors.transparent,
                                                        dashGapRadius: 0.0,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 2,
                                                          left: 15,
                                                          right: 10,
                                                          bottom: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: ListView(
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                            0),
                                                                        child:
                                                                        Text(
                                                                          Languages.of(context)!
                                                                              .paymentlable,
                                                                          style: TextStyle(
                                                                              color: Color(Constants
                                                                                  .whitetext),
                                                                              fontSize:
                                                                              16,
                                                                              fontFamily:
                                                                              Constants.app_font_bold),
                                                                        )),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                            5),
                                                                        child:
                                                                        Text(
                                                                          "(" +
                                                                              paymentstatus +
                                                                              ")",
                                                                          style: TextStyle(
                                                                              color:
                                                                              paymentcolor,
                                                                              fontSize:
                                                                              16,
                                                                              fontFamily:
                                                                              Constants.app_font_bold),
                                                                        )),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  paymentType,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .greaytext),
                                                                      fontSize:
                                                                      14,
                                                                      fontFamily:
                                                                      Constants
                                                                          .app_font),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          (orderdatalist[index].orderStatus=='READY TO PICKUP')
                                                              ?Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      _OpenCancelBottomSheet(
                                                                          orderdatalist[index]
                                                                              .id
                                                                              .toString(),
                                                                          context);
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 0,
                                                                          left: 5,
                                                                          right:
                                                                          5,
                                                                          bottom:
                                                                          0),
                                                                      alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/close.svg",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      CallApiForAcceptorder(
                                                                          orderdatalist[index]
                                                                              .id
                                                                              .toString(),
                                                                          orderdatalist[index]
                                                                              .orderId
                                                                              .toString(),
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .name,
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .mapAddress,
                                                                          distance,
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .lat,
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .lang,
                                                                          orderdatalist[index]
                                                                              .userAddress!
                                                                              .lat,
                                                                          orderdatalist[index]
                                                                              .userAddress!
                                                                              .lang,
                                                                          orderdatalist[index]
                                                                              .userAddress!
                                                                              .address,
                                                                          orderdatalist[index]
                                                                              .vendor!
                                                                              .image,
                                                                          orderdatalist[index]
                                                                              .user!
                                                                              .name,
                                                                          orderdatalist[index]
                                                                              .orderStatus!,
                                                                          orderdatalist[index].amount.toString(),
                                                                          orderdatalist[index].paymentType!
                                                                      );
                                                                      // print(
                                                                      //     Constants.CheckNetwork().whenComplete(() => ));

                                                                      // if (PreferenceUtils.getString(Constants.previos_order_status) ==
                                                                      //         "COMPLETE" ||
                                                                      //     PreferenceUtils.getString(Constants.previos_order_status)
                                                                      //         .isEmpty ||
                                                                      //     PreferenceUtils.getString(Constants.previos_order_status) ==
                                                                      //         "CANCEL") {
                                                                      //   Constants.CheckNetwork().whenComplete(() => CallApiForAcceptorder(
                                                                      //       orderdatalist[index]
                                                                      //           .id
                                                                      //           .toString(),
                                                                      //       orderdatalist[index]
                                                                      //           .orderId
                                                                      //           .toString(),
                                                                      //       orderdatalist[index]
                                                                      //           .vendor!
                                                                      //           .name,
                                                                      //       orderdatalist[index]
                                                                      //           .vendor!
                                                                      //           .mapAddress,
                                                                      //       distance,
                                                                      //       orderdatalist[index]
                                                                      //           .vendor!
                                                                      //           .lat,
                                                                      //       orderdatalist[index]
                                                                      //           .vendor!
                                                                      //           .lang,
                                                                      //       orderdatalist[index]
                                                                      //           .userAddress!
                                                                      //           .lat,
                                                                      //       orderdatalist[index]
                                                                      //           .userAddress!
                                                                      //           .lang,
                                                                      //       orderdatalist[index]
                                                                      //           .userAddress!
                                                                      //           .address,
                                                                      //       orderdatalist[index]
                                                                      //           .vendor!
                                                                      //           .image,
                                                                      //       orderdatalist[index]
                                                                      //           .user!
                                                                      //           .name));
                                                                      //
                                                                      // } else {
                                                                      //   setState(
                                                                      //       () {
                                                                      //     lastorder =
                                                                      //         true;
                                                                      //
                                                                      //     if (lastorder ==
                                                                      //         false) {
                                                                      //       lastorder =
                                                                      //           true;
                                                                      //     }
                                                                      //   });
                                                                      // }
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 0,
                                                                          left: 0,
                                                                          right:
                                                                          10,
                                                                          bottom:
                                                                          0),
                                                                      alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/right.svg",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                              :ElevatedButton(onPressed: ()async{
                                                            setState(() {
                                                              showSpinner = true;
                                                            });

                                                            LocationData locationData=await  Location().getLocation();
                                                            print(locationData.longitude);
                                                            print(locationData.latitude);
                                                            Navigator.of(this.context)
                                                                .push(MaterialPageRoute(builder: (context) =>
                                                            //GetOrderKitchen()
                                                            PickupScreen(
                                                              driverLang: locationData.longitude!,
                                                              vendorLang: double.parse(orderdatalist[index].vendor!.lang!),
                                                              driverLat: locationData.latitude!,
                                                              vendorLat: double.parse(orderdatalist[index].vendor!.lat!),
                                                              userLat: double.parse(orderdatalist[index].userAddress!.lat!),
                                                              userLang: double.parse(orderdatalist[index].userAddress!.lang!),
                                                              orderStatus: orderdatalist[index].orderStatus!,
                                                              orderId: orderdatalist[index].id.toString(),
                                                              vendorname:orderdatalist[index].vendor!.name! ,
                                                              vendorAddress: orderdatalist[index].vendor!.mapAddress!,
                                                              distance: distance,
                                                              price: orderdatalist[index].amount!.toString(),
                                                              heading: locationData.heading!,
                                                              paymentType: orderdatalist[index].paymentType!, userAddress: orderdatalist[index].userAddress!.address??'',)
                                                            ));
                                                          }, child: Text("Map")),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: hideduty,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      // physics: NeverScrollableScrollPhysics(),
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 50),
                                            child: SvgPicture.asset(
                                              "images/offline.svg",
                                              width:
                                              ScreenUtil().setHeight(200),
                                              height:
                                              ScreenUtil().setHeight(200),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 20.0,
                                                left: 15.0,
                                                right: 15,
                                                bottom: 0),
                                            child: Text(
                                              Languages.of(context)!
                                                  .youareofflinelable,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                  Constants.app_font_bold,
                                                  fontSize: 20),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 15.0,
                                                right: 15,
                                                bottom: 0),
                                            child: Text(
                                              Languages.of(context)!
                                                  .dutystatusofflinelable,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                  Constants.app_font,
                                                  fontSize: 16),
                                              maxLines: 4,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 30.0,
                                                  left: 15.0,
                                                  right: 15,
                                                  bottom: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  isOnline = true;

                                                  Constants.CheckNetwork()
                                                      .whenComplete(() =>
                                                      CallApiForUpdateStatus(
                                                          isOnline));
                                                },
                                                child: RichText(
                                                  maxLines: 2,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  textScaleFactor: 1,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: Languages.of(
                                                              context)!
                                                              .reconnectlable,
                                                          style: TextStyle(
                                                            color: Color(Constants
                                                                .color_theme),
                                                            fontSize: 16,
                                                            fontFamily: Constants
                                                                .app_font_bold,
                                                          )),

                                                      //
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: nojob,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      // physics: NeverScrollableScrollPhysics(),
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 50),
                                            child: SvgPicture.asset(
                                              "images/no_job.svg",
                                              width:
                                              ScreenUtil().setHeight(200),
                                              height:
                                              ScreenUtil().setHeight(200),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 20.0,
                                                left: 15.0,
                                                right: 15,
                                                bottom: 0),
                                            child: Text(
                                              Languages.of(context)!
                                                  .nonewjoblable,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                  Constants.app_font_bold,
                                                  fontSize: 20),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 15.0,
                                                right: 15,
                                                bottom: 0),
                                            child: Text(
                                              Languages.of(context)!
                                                  .youhavenotnewjoblable,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                  Constants.app_font,
                                                  fontSize: 16),
                                              maxLines: 4,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Visibility(
                        //   visible: lastorder,
                        //   child: Container(
                        //     child: Align(
                        //       alignment: Alignment.bottomCenter,
                        //       child: Container(
                        //         height: ScreenUtil().setHeight(100),
                        //         color: const Color(0xFF42565f),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Container(
                        //               margin: EdgeInsets.only(left: 20, top: 20),
                        //               child: Column(
                        //                 children: [
                        //                   Text(
                        //                     Languages.of(context)!.oidlable + "  " +
                        //                         PreferenceUtils.getString(
                        //                             Constants.previos_order_orderid),
                        //                     style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontFamily:
                        //                             Constants.app_font_bold,
                        //                         fontSize: 16),
                        //                   ),
                        //                   Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.start,
                        //                     children: [
                        //                       InkWell(
                        //                         onTap: () {
                        //                           _OpenCancelBottomSheet(
                        //                               PreferenceUtils.getString(
                        //                                   Constants
                        //                                       .previos_order_id
                        //                                       .toString()),
                        //                               context);
                        //                         },
                        //                         child: Container(
                        //                           margin: EdgeInsets.only(
                        //                               left: 10, top: 10),
                        //                           child: Text(
                        //                             Languages.of(context)!
                        //                                 .canceldeliverylable,
                        //                             style: TextStyle(
                        //                                 color: Color(
                        //                                     Constants.redtext),
                        //                                 fontFamily:
                        //                                     Constants.app_font,
                        //                                 fontSize: 14),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       InkWell(
                        //                         onTap: () {
                        //                           Navigator.of(context).push(
                        //                               MaterialPageRoute(
                        //                                   builder: (context) =>
                        //                                       GetOrderKitchen()));
                        //                         },
                        //                         child: Container(
                        //                           margin: EdgeInsets.only(
                        //                               left: 12, top: 10),
                        //                           child: Text(
                        //                             Languages.of(context)!
                        //                                 .pickupanddeliverlable,
                        //                             style: TextStyle(
                        //                                 color: Color(Constants
                        //                                     .greentext),
                        //                                 fontFamily:
                        //                                     Constants.app_font,
                        //                                 fontSize: 14),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Container(
                        //                           margin: EdgeInsets.only(
                        //                               left: 5, top: 12),
                        //                           child: SvgPicture.asset(
                        //                               "images/right_arrow.svg")),
                        //                     ],
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //             Container(
                        //               margin: EdgeInsets.only(right: 20),
                        //               child: CachedNetworkImage(
                        //                 // imageUrl: imageurl,
                        //
                        //                 imageUrl: PreferenceUtils.getString(
                        //                     Constants
                        //                         .previos_order_vendor_image),
                        //                 fit: BoxFit.fill,
                        //                 width: ScreenUtil().setWidth(55),
                        //                 height: ScreenUtil().setHeight(55),
                        //
                        //                 imageBuilder:
                        //                     (context, imageProvider) =>
                        //                         ClipRRect(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10.0),
                        //                   child: Image(
                        //                     image: imageProvider,
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                 ),
                        //                 placeholder: (context, url) =>
                        //                     SpinKitFadingCircle(
                        //                         color:
                        //                             Color(Constants.greentext)),
                        //                 errorWidget: (context, url, error) =>
                        //                     Image.asset("images/no_image.png"),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )

                        // new Container(child: Body())
                      ],
                    );
                  }),
                ),
              )
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async{
    return true;
  }
  void _OpenCancelBottomSheet(String id, BuildContext context) {
    _cancelReason ="0";
    _text_cancel_reason_controller.text="";
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
                                Navigator.pop(context);
                              }
                            } else {
                              Constants.CheckNetwork().whenComplete(
                                      () => CallApiForCancelorder(id, _cancelReason));
                              Navigator.pop(context);
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

  _getCurrentLocation() async{
    LocationData locationData=await  mapController.location.getLocation();
  if(mounted){
    setState(() {
      current_lat = locationData.latitude!;
      current_long = locationData.longitude!;
      print(locationData.latitude!.toString()+","+locationData.latitude!.toString());
      print(current_lat.toString()+","+current_long.toString());

      print("current_lat852:${current_lat}");
      print("current_lang852:${current_long}");
    });
  }else{
    current_lat = locationData.latitude!;
    current_long = locationData.longitude!;

  }
  }

}