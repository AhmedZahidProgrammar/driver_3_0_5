import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/controller/profile_controller.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/screen/cashbalancescreen.dart';
import 'package:driver_3_0_5/screen/changepassword.dart';
import 'package:driver_3_0_5/screen/earinghistoryscreen.dart';
import 'package:driver_3_0_5/screen/editprofilescreen.dart';
import 'package:driver_3_0_5/screen/faqscreen.dart';
import 'package:driver_3_0_5/screen/historyscreen.dart';
import 'package:driver_3_0_5/screen/login_screen.dart';
import 'package:driver_3_0_5/screen/mydocumentscreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfile createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  // ProgressDialog pr;
  bool showSpinner = false;
  ProfileController _profileController=Get.find<ProfileController>();
  String name = "Driver";
  String? email = "driver@gmail.com";
  String? phone = "000 000 0000";
  String? phonecode = "+0";
  String? image = "";
  String? location = "Set Location";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    PreferenceUtils.init();

    if (mounted) {
      setState(() {
        Constants.CheckNetwork().whenComplete(() => CallApiForGetProfile());

        name = PreferenceUtils.getString(Constants.driverfirstname) +
            " " +
            PreferenceUtils.getString(Constants.driverlastname);
        email = PreferenceUtils.getString(Constants.driveremail);
        phone = PreferenceUtils.getString(Constants.driverphone);
        phonecode = PreferenceUtils.getString(Constants.driverphonecode);
        location = PreferenceUtils.getString(Constants.driverzone);
        image = PreferenceUtils.getString(Constants.driverimage);
      });
    }

    if (mounted) {
      Constants.CheckNetwork().whenComplete(() => CallApiForGetProfile());
    }
  }

  CallApiForGetProfile() {
    setState(() {
      showSpinner = true;
    });

    RestClient(Api_Header().Dio_Data()).driverprofile().then((response) {
      if (response.success == true) {
        setState(() {
          name = response.data!.firstName! + " " + response.data!.lastName!;
          email = response.data!.emailId;
          phone = response.data!.contact;
          phonecode = response.data!.phoneCode;
          if(response.data!.deliveryzone != null){
            location = response.data!.deliveryzone;
          }else{
            location = '';
          }

          image = response.data!.image;

          print("image123:$image");

          PreferenceUtils.setString(
              Constants.driverid, response.data!.id.toString());
          PreferenceUtils.setString(
              Constants.driverfirstname, response.data!.firstName!);
          PreferenceUtils.setString(
              Constants.driverlastname, response.data!.lastName!);
          PreferenceUtils.setString(Constants.driverimage, response.data!.image!);
          PreferenceUtils.setString(
              Constants.driveremail, response.data!.emailId!);
          PreferenceUtils.setString(
              Constants.driverphone, response.data!.contact!);
          PreferenceUtils.setString(
              Constants.driverphonecode, response.data!.phoneCode!);
          PreferenceUtils.setString(
              Constants.drivervehicletype, response.data!.vehicleType!);
          PreferenceUtils.setString(
              Constants.drivervehiclenumber, response.data!.vehicleNumber!);
          PreferenceUtils.setString(
              Constants.driverlicencenumber, response.data!.licenceNumber!);
          PreferenceUtils.setString(
              Constants.drivernationalidentity, response.data!.nationalIdentity!);
          PreferenceUtils.setString(
              Constants.driverlicencedoc, response.data!.licenceDoc!);
          if(response.data!.deliveryZoneId != null){
            PreferenceUtils.setString(Constants.driverdeliveryzoneid,
                response.data!.deliveryZoneId.toString());
          }else{
            PreferenceUtils.setString(Constants.driverdeliveryzoneid, '');
          }

          if(response.data!.otp != null){
            PreferenceUtils.setString(Constants.driverotp, response.data!.otp.toString());
          }else{
            PreferenceUtils.setString(Constants.driverotp, '');
          }

          if(response.data!.deliveryzone != null){
            PreferenceUtils.setString(Constants.driverzone, response.data!.deliveryzone!);
          }else{
            PreferenceUtils.setString(Constants.driverzone, '');
          }

          setState(() {
            showSpinner = false;
          });
        });
      } else {
        setState(() {
          showSpinner = false;
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
    /*ScreenUtil.init(context,
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
              appBar: AppBar(
                title: AutoSizeText(
                  Languages.of(context)!.myprofilelable,
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
                automaticallyImplyLeading: false,
              ),
              body: ModalProgressHUD(
                inAsyncCall: showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator:
                    SpinKitFadingCircle(color: Color(Constants.greentext)),
                child: new Stack(
                  children: <Widget>[
                    new SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.transparent,
                        child: Column(
                          // physics: NeverScrollableScrollPhysics(),
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                              child: InkWell(
                                onTap: () {
                                  print("all click");

                                  OpenshowprofileBottomSheet();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 0, right: 5, bottom: 0, left: 5),
                                  decoration: BoxDecoration(
                                      color: Color(Constants.itembgcolor),
                                      border: Border.all(
                                        color: Color(Constants.itembgcolor),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 2,
                                                left: 5,
                                                bottom: 5,
                                                right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: CachedNetworkImage(
                                                      // imageUrl: imageurl,

                                                      imageUrl: image == null
                                                          ? "http://ondemandscripts.com/App-Demo/MealUp-76850/public/images/upload/product_default.jpg"
                                                          : image!,
                                                      // height: ScreenUtil().setHeight(80),
                                                      width: screenWidth * 0.14,
                                                      height:
                                                          screenHeight * 0.1,
                                                      fit: BoxFit.cover,

                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(45.0),
                                                        child: Image(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),

                                                      placeholder: (context,
                                                              url) =>
                                                          SpinKitFadingCircle(
                                                              color: Color(
                                                                  Constants
                                                                      .greentext)),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              "images/no_image.png"),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        left: 10,
                                                        right: 5,
                                                        bottom: 0),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: ListView(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            name,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font_bold,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  left: 0,
                                                                  right: 5,
                                                                  bottom: 0),
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            email!,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greaytext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    left: 0,
                                                                    right: 5,
                                                                    bottom: 0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                print(
                                                                    "single click");

                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EditProfile()));
                                                              },
                                                              child: Container(
                                                                height:
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            30),
                                                                width: ScreenUtil()
                                                                    .setWidth(
                                                                        100),
                                                                decoration: new BoxDecoration(
                                                                    color: Color(
                                                                        Constants
                                                                            .bgcolor),
                                                                    borderRadius: new BorderRadius
                                                                        .all(const Radius
                                                                            .circular(
                                                                        20))),
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                2),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textScaleFactor:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                                                              child: SvgPicture.asset(
                                                                                "images/edit.svg",
                                                                                width: 13,
                                                                                height: 13,
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.only(left: 0, top: 5, bottom: 3, right: 0),
                                                                              child: Text(
                                                                                Languages.of(context)!.editprofilelable,
                                                                                style: TextStyle(
                                                                                  color: Color(Constants.greentext),
                                                                                  fontSize: 14,
                                                                                  fontFamily: Constants.app_font,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          //
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: 0,
                                                left: 20,
                                                bottom: 10,
                                                right: 5),
                                            child: Text(
                                              Languages.of(context)!
                                                  .taptoviewinfolable,
                                              style: (TextStyle(
                                                  color: Color(
                                                      Constants.greaytext),
                                                  fontFamily:
                                                      Constants.app_font,
                                                  fontSize: 14)),
                                            ),
                                          ),

                                        ]),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        History(selectIndex: 1,),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Payment Pending",
                                        style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .greaytext),
                                            fontFamily:
                                            Constants
                                                .app_font,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin:
                                      EdgeInsets.only(
                                          top: 2),
                                      child: Obx(()=>Text(
                                        "\$ " + _profileController.payementPending.value,
                                        style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .greentext),
                                            fontFamily:
                                            Constants
                                                .app_font,
                                            fontSize: 22),
                                      )),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Tao to view your pending payements",
                                        style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .greaytext),
                                            fontFamily:
                                            Constants
                                                .app_font,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5, right: 5, bottom: 0, left: 5),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(0),
                                      right: ScreenUtil().setWidth(0)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (PreferenceUtils.getBool(
                                                    Constants.isGlobalDriver) ==
                                                true) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyDocument(),
                                                ),
                                              );
                                            } else {
                                              Constants.toastMessage(Constants
                                                  .notGlobalDriverSlogan);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/documents.svg"),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 0,
                                                            left: 20,
                                                            bottom: 0,
                                                            right: 5),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          Languages.of(context)!
                                                              .mydocumentlable,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  Constants
                                                                      .app_font),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: false,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 0,
                                                                  left: 0,
                                                                  bottom: 0,
                                                                  right: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Verification on process...",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .redtext),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    History(selectIndex: 0,),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/history.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .historylable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (PreferenceUtils.getBool(
                                                    Constants.isGlobalDriver) ==
                                                true) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyCashBalance(),
                                                ),
                                              );
                                            } else {
                                              Constants.toastMessage(Constants
                                                  .notGlobalDriverSlogan);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/cash_balance.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .mycachebalancelable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (PreferenceUtils.getBool(
                                                    Constants.isGlobalDriver) ==
                                                true) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Earninghistory(),
                                                ),
                                              );
                                            } else {
                                              Constants.toastMessage(Constants
                                                  .notGlobalDriverSlogan);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/earning_his.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .earninghistorylable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (PreferenceUtils.getBool(
                                                    Constants.isGlobalDriver) ==
                                                true) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangePassword(),
                                                ),
                                              );
                                            } else {
                                              Constants.toastMessage(Constants
                                                  .notGlobalDriverSlogan);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/change_password.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .changepasswordlable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (PreferenceUtils.getBool(
                                                    Constants.isGlobalDriver) ==
                                                true) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => FAQs(),
                                                ),
                                              );
                                            } else {
                                              Constants.toastMessage(Constants
                                                  .notGlobalDriverSlogan);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/faq.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .faqlable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        // InkWell(
                                        //   onTap: () {
                                        //     Navigator.of(context).push(
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 Language()));
                                        //   },
                                        //   child: Container(
                                        //     margin: EdgeInsets.only(
                                        //         top: 10,
                                        //         left: 5,
                                        //         bottom: 10,
                                        //         right: 5),
                                        //     child: Row(
                                        //       children: [
                                        //         Container(
                                        //           alignment: Alignment.center,
                                        //           child: SvgPicture.asset(
                                        //               "images/language.svg"),
                                        //         ),
                                        //         Container(
                                        //           margin: EdgeInsets.only(
                                        //               top: 0,
                                        //               left: 20,
                                        //               bottom: 0,
                                        //               right: 5),
                                        //           alignment: Alignment.center,
                                        //           child: Text(
                                        //             Languages.of(context)!
                                        //                 .changemylanguagelable,
                                        //             style: TextStyle(
                                        //                 color: Color(Constants
                                        //                     .whitetext),
                                        //                 fontSize: 18,
                                        //                 fontFamily:
                                        //                     Constants.app_font),
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Container(
                                        //   margin: EdgeInsets.only(
                                        //       top: 10,
                                        //       left: 5,
                                        //       bottom: 5,
                                        //       right: 5),
                                        //   child: Divider(
                                        //     height: 1,
                                        //     thickness: 0.5,
                                        //     color: Color(Constants.dashline),
                                        //   ),
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            PreferenceUtils.clear();
                                            PreferenceUtils.setlogin(
                                                Constants.isLoggedIn, false);
                                            PreferenceUtils.putBool(
                                                Constants.isGlobalDriver,
                                                false);

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new LoginScreen()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                bottom: 10,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                      "images/logout.svg"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      bottom: 0,
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .logoutlable,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 18,
                                                        fontFamily:
                                                            Constants.app_font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.5,
                                            color: Color(Constants.dashline),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 0,
                                              bottom: 5,
                                              right: 0),
                                          child: Text(
                                            Languages.of(context)!.versionlable,
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontFamily: Constants.app_font,
                                                fontSize: 14),
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

                    // new Container(child: Body())
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async{
    return true;
  }

  void OpenshowprofileBottomSheet() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
   /* ScreenUtil.init(context,
        designSize: Size(screenWidth, screenHeight), allowFontScaling: true);
*/
    // final _formKey = GlobalKey<FormState>();
    // String _review = "";

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: false,
        backgroundColor: Color(Constants.itembgcolor),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Wrap(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 5, right: 5, bottom: 0, left: 5),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(0),
                                right: ScreenUtil().setWidth(0)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 5, bottom: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl: image == null
                                                  ? "http://ondemandscripts.com/App-Demo/MealUp-76850/public/images/upload/product_default.jpg"
                                                  : image!,
                                              // height: ScreenUtil().setHeight(80),
                                              width: screenWidth * 0.14,
                                              height: screenHeight * 0.1,
                                              fit: BoxFit.cover,

                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(45.0),
                                                child: Image(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              placeholder: (context, url) =>
                                                  SpinKitFadingCircle(
                                                      color: Color(
                                                          Constants.greentext)),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            color: Colors.transparent,
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                left: 10,
                                                right: 5,
                                                bottom: 0),
                                            alignment: Alignment.topLeft,
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 2),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontFamily: Constants
                                                            .app_font_bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: EdgeInsets.only(
                                                      top: 5,
                                                      left: 0,
                                                      right: 5,
                                                      bottom: 0),
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    email!,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .greaytext),
                                                        fontFamily:
                                                            Constants.app_font,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 0,
                                                        right: 5,
                                                        bottom: 0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print("single click");
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditProfile()));
                                                      },
                                                      child: Container(
                                                        height: ScreenUtil()
                                                            .setHeight(30),
                                                        width: ScreenUtil()
                                                            .setWidth(100),
                                                        decoration: new BoxDecoration(
                                                            color: Color(
                                                                Constants
                                                                    .bgcolor),
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .all(
                                                                    const Radius
                                                                            .circular(
                                                                        20))),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textScaleFactor:
                                                                  1,
                                                              text: TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/edit.svg",
                                                                        width:
                                                                            13,
                                                                        height:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  WidgetSpan(
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              3,
                                                                          right:
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        Languages.of(context)!
                                                                            .editprofilelable,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(Constants.greentext),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              Constants.app_font,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  //
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 20, bottom: 0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              Languages.of(context)!.contactnolable,
                              style: TextStyle(
                                  color: Color(Constants.greaytext),
                                  fontSize: 14,
                                  fontFamily: Constants.app_font),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 0, left: 20, bottom: 0, right: 5),
                            alignment: Alignment.center,
                            child: Text(
                              phonecode! + " " + phone!,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 16,
                                  fontFamily: Constants.app_font),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 20, bottom: 5, right: 10),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(Constants.dashline),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 20, bottom: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              Languages.of(context)!.locationlable,
                              style: TextStyle(
                                  color: Color(Constants.greaytext),
                                  fontSize: 14,
                                  fontFamily: Constants.app_font),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 0, left: 20, bottom: 0, right: 5),
                            alignment: Alignment.center,
                            child: Text(
                              location!,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 16,
                                  fontFamily: Constants.app_font),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
