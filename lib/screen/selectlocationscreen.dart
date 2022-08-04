import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/model/deliveryzone.dart';
import 'package:driver_3_0_5/screen/homescreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:driver_3_0_5/widget/app_lable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocation createState() => _SelectLocation();
}

class _SelectLocation extends State<SelectLocation> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool showSpinner = false;
  // final _formKey = new GlobalKey<FormState>();
  String strCountryCode = '+61';
  // String _birthvalue = "1";
  List<ZoneData> zonedatalist = <ZoneData>[];
  ZoneData? zoneData;
  String? zondata = " ";
  String zonid = " ";


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    setState(() {
      zondata = PreferenceUtils.getString(Constants.driverzone);
      zonid = PreferenceUtils.getString(Constants.driverdeliveryzoneid);

      print("zondataertt:$zondata");
    });

    if (mounted) {
      Constants.CheckNetwork().whenComplete(() => CallApiForGetDeliveryZone());
    }
  }

  CallApiForGetDeliveryZone() {
    setState(() {
      showSpinner = true;
    });

    RestClient(Api_Header().Dio_Data()).driverdelivery_zone().then((response) {
      if (mounted) {
        setState(() {
          if (response.success = true) {
            setState(() {
              showSpinner = false;
            });

            if (response.data!.length != 0) {
              zonedatalist.addAll(response.data!);

              if (zondata == null && zondata!.isEmpty) {
                zondata = response.data![0].name;
                zonid = response.data![0].id.toString();
              } else {
                zondata = PreferenceUtils.getString(Constants.driverzone);
                zonid =
                    PreferenceUtils.getString(Constants.driverdeliveryzoneid);
              }

              for (int i = 0; i< response.data!.length; i++) {
                zoneData = response.data![i];
              }
            } else {
              zondata = " ";
              zonid = "0";
            }
          } else {
            setState(() {
              showSpinner = false;
            });
          }
        });
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
    });
  }

  CallApiForSetDeliveryZone(
      String zonid, String? zondata, BuildContext context) {
    setState(() {
      showSpinner = true;
    });
    RestClient(Api_Header().Dio_Data())
        .driversetdeliveryzone(zonid)
        .then((response) {
      if (mounted) {
        setState(() {
          final body = json.decode(response!);
          bool? sucess = body['success'];
          if (sucess = true) {
            setState(() {
              showSpinner = false;
            });
            var msg = body['data'];
            print(msg);
            Constants.createSnackBar(msg, this.context, Color(Constants.greentext));
            PreferenceUtils.setString(Constants.driverzone, zondata!);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(0)),
            );
          } else if (sucess == false) {
            setState(() {
              showSpinner = false;
            });
            var msg = body['data'];
            print(msg);
            Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
          }
        });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
   /* ScreenUtil.init(context,
        designSize: Size(screenWidth, screenHeight), allowFontScaling: true);*/
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
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  Languages.of(context)!.selectlocation,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(Constants.whitetext),
                    fontFamily: Constants.app_font_bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                automaticallyImplyLeading: true,
              ),
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
                        new SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 60),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(8)),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 5, bottom: 0, left: 5),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(0),
                                          right: ScreenUtil().setWidth(0)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: AppLableWidget(
                                                title: Languages.of(context)!
                                                    .selectdeliveryzonelable,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth,
                                              height:
                                                  ScreenUtil().setHeight(55),
                                              child: Card(
                                                color: Color(
                                                    Constants.light_black),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 5.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 10),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                            ZoneData>(
                                                        // value:zoneData,
                                                        hint: new Text(
                                                          zondata!,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .greaytext),
                                                              fontFamily:
                                                                  Constants
                                                                      .app_font,
                                                              fontSize: 12),
                                                        ),
                                                        icon: SvgPicture.asset(
                                                            "images/drop_dwon.svg"),
                                                        isDense: true,
                                                        items: zonedatalist
                                                            .map((user) {
                                                          return DropdownMenuItem<
                                                              ZoneData>(
                                                            value: user,
                                                            child: new Text(
                                                              user.name!,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .greaytext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .app_font_bold,
                                                                  fontSize: 14),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            zoneData = value;
                                                            zonid = value!.id
                                                                .toString();
                                                            zondata =
                                                                value.name;
                                                            print(zonid);
                                                            print(zondata);
                                                            PreferenceUtils
                                                                .setString(
                                                                    Constants
                                                                        .driverzone,
                                                                    zondata!);
                                                          });
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Container(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              child: GestureDetector(
                            onTap: () {
                              // Constants.CheckNetwork().whenComplete(() => pr.show());
                              Constants.CheckNetwork().whenComplete(() =>
                                  CallApiForSetDeliveryZone(
                                      zonid, zondata, context));
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13.0),
                                  color: Color(Constants.greentext),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 0.0), //(x,y)
                                      // blurRadius: 0.0,
                                    ),
                                  ],
                                ),
                                width: screenWidth,
                                height: screenHeight * 0.08,
                                child: Center(
                                  child: Container(
                                    color: Color(Constants.greentext),
                                    child: Text(
                                      Languages.of(context)!
                                          .setthislocationlable,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: Constants.app_font),
                                    ),
                                  ),
                                )),
                          )),
                        ))
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
}

class Body extends StatelessWidget {
  final _formKey;

  Body(this._formKey);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
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
            height: screenHeight * 0.08,
            child: Center(
              child: Container(
                color: Color(Constants.greentext),
                child: Text(
                  Languages.of(context)!.setthislocationlable,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: Constants.app_font),
                ),
              ),
            )),
      )),
    );
  }
}
