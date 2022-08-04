import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/model/orderhistory.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class History extends StatefulWidget {
  final int selectIndex;

  const History({Key? key,required this.selectIndex}) : super(key: key);
  @override
  _History createState() => _History();
}

class _History extends State<History> with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool showSpinner = false;
  TabController? controller;

  TextEditingController com_controller = new TextEditingController();
  TextEditingController can_controller = new TextEditingController();

  Color seltabtext = Color(Constants.greentext);
  Color seltanindicator = Color(Constants.greentext);

  int seltabindex = 0;
  List<Complete> comsearchlist = <Complete>[];
  List<Cancel> cansearchlist = <Cancel>[];

  List<Complete> comporderdatalist = <Complete>[];
  List<Cancel> canorderdatalist = <Cancel>[];

  double current_lat = 0;
  double current_long = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    controller = TabController(initialIndex: widget.selectIndex,length: 2, vsync: this);

    if (mounted) {
      Constants.CheckNetwork().whenComplete(() => CallApiForGetOrderHistory());
    }
  }

  Future<void> CallApiForGetOrderHistory() async {
    setState(() {
      showSpinner = true;
    });
    RestClient(Api_Header().Dio_Data()).driverorderhistory().then((response) {
      if (mounted) {
        setState(() {
          if (response.success = true) {
            if (response.data!.complete != 0) {
              comporderdatalist.addAll(response.data!.complete!);
              setState(() {
                showSpinner = false;
              });
            } else {
              setState(() {
                showSpinner = false;
                Constants.toastMessage(Languages.of(context)!.nodatalable);
                Constants.createSnackBar(Languages.of(context)!.nodatalable,
                    this.context, Color(Constants.greentext));
              });
            }

            if (response.data!.cancel != 0) {
              canorderdatalist.addAll(response.data!.cancel!);
              setState(() {
                showSpinner = false;
              });
            } else {
              setState(() {
                showSpinner = false;
              });
            }
          } else {
            final snackBar = SnackBar(
              content: Text(Languages.of(context)!.servererrorlable),
              backgroundColor: Color(Constants.redtext),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);

            setState(() {
              showSpinner = false;
            });
          }
        });
      }
    }).catchError((e,stk) {
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
      print(stk);
      // print("error:$obj");
      // print(obj.runtimeType);

      setState(() {
        showSpinner = false;
      });
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
              // resizeToAvoidBottomPadding: true,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  Languages.of(context)!.historylable,
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
              body: RefreshIndicator(
                color: Color(Constants.greentext),
                backgroundColor: Colors.transparent,
                onRefresh: CallApiForGetOrderHistory,
                key: _refreshIndicatorKey,
                child: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  opacity: 1.0,
                  color: Colors.transparent.withOpacity(0.2),
                  progressIndicator:
                      SpinKitFadingCircle(color: Color(Constants.greentext)),
                  child: new Stack(
                    children: <Widget>[
                      new SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          height: screenHeight,
                          margin: EdgeInsets.only(bottom: 00),
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: ScreenUtil().setHeight(40),
                                color: Colors.transparent,
                                child: Container(
                                  height: ScreenUtil().setHeight(30),
                                  transform:
                                      Matrix4.translationValues(0.0, -0.0, 0.0),
                                  color: Colors.transparent,
                                  child: TabBar(
                                    onTap: (tabIndex) {
                                      setState(() {
                                        seltabindex = tabIndex;
                                        if (tabIndex == 0) {
                                          seltabindex = tabIndex;
                                          seltabtext =
                                              Color(Constants.greentext);
                                          seltanindicator =
                                              Color(Constants.greentext);
                                        } else {
                                          seltabindex = tabIndex;
                                          seltabtext = Color(Constants.redtext);
                                          seltanindicator =
                                              Color(Constants.redtext);
                                        }
                                      });
                                    },
                                    labelColor: seltabtext,
                                    unselectedLabelColor: Colors.white,
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: Constants.app_font),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding:
                                        EdgeInsets.only(left: 5, right: 5),
                                    indicatorColor: seltanindicator,
                                    indicatorWeight: 5.0,
                                    tabs: [
                                      Tab(
                                        text: Languages.of(context)!
                                            .completedtablable,
                                      ),
                                      new Tab(
                                        text:"Delivered"
                                      ),
                                    ],
                                    controller: controller,
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Card(
                                  color: Color(Constants.light_black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.name,
                                      onChanged: seltabindex == 0
                                          ? ComSearchTextChanged
                                          : CanSearchTextChanged,
                                      controller: seltabindex == 0
                                          ? com_controller
                                          : can_controller,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: Constants.app_font_bold),
                                      decoration: Constants
                                          .kTextFieldInputDecoration1
                                          .copyWith(
                                              hintText: Languages.of(context)!
                                                  .searchorderidlable),
                                    ),
                                  ),
                                ),
                              ),
                              //

                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 10, right: 5, bottom: 90, left: 5),
                                  child: TabBarView(
                                      controller: controller,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        /*  Completed  List*/

                                        Container(
                                            child:
                                                comsearchlist.length != 0 ||
                                                        com_controller
                                                            .text.isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount: comsearchlist
                                                            .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          String paymentstatus;
                                                          Color paymentcolor;
                                                          if (comsearchlist[
                                                                      index]
                                                                  .paymentStatus
                                                                  .toString() ==
                                                              "0") {
                                                            paymentstatus =
                                                                "Pending";
                                                            paymentcolor =
                                                                Color(Constants
                                                                    .redtext);
                                                          } else {
                                                            paymentstatus =
                                                                "Completed";
                                                            paymentcolor =
                                                                Color(Constants
                                                                    .greentext);
                                                          }

                                                          double user_lat =
                                                              double.parse(
                                                                  comsearchlist[
                                                                          index]
                                                                      .userAddress!
                                                                      .lat!);
                                                          double user_long =
                                                              double.parse(
                                                                  comsearchlist[
                                                                          index]
                                                                      .userAddress!
                                                                      .lang!);
                                                          // assert(user_lat
                                                          //     is double);
                                                          // assert(user_long
                                                          //     is double);
                                                          String distance = "0";
                                                          double
                                                              distanceInMeters =
                                                              Geolocator.distanceBetween(
                                                                  current_lat,
                                                                  current_long,
                                                                  user_lat,
                                                                  user_long);
                                                          double distanceinkm =
                                                              distanceInMeters /
                                                                  1000;
                                                          String str =
                                                              distanceinkm
                                                                  .toString();
                                                          var distance12 =
                                                              str.split('.');
                                                          distance =
                                                              distance12[0];

                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .all(ScreenUtil()
                                                                    .setWidth(
                                                                        8)),
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      right: 5,
                                                                      bottom: 0,
                                                                      left: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          Constants
                                                                              .itembgcolor),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Color(
                                                                            Constants.itembgcolor),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(12))),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: ScreenUtil()
                                                                        .setWidth(
                                                                            0),
                                                                    right: ScreenUtil()
                                                                        .setWidth(
                                                                            0)),
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              Languages.of(context)!.oidlable + "   " + comsearchlist[index].orderId!,
                                                                              style: TextStyle(color: Colors.white, fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            ),
                                                                            Text(
                                                                              Languages.of(context)!.dollersignlable + comsearchlist[index].amount.toString(),
                                                                              style: TextStyle(color: Color(Constants.color_theme), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        itemCount: comsearchlist[index]
                                                                            .orderItems!
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                                position) {
                                                                          return Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10, left: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  comsearchlist[index].orderItems![position].itemName!,
                                                                                  style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 12),
                                                                                ),
                                                                                Text(
                                                                                  "  x " + comsearchlist[index].orderItems![position].qty.toString(),
                                                                                  style: TextStyle(color: Color(Constants.greentext), fontFamily: Constants.app_font, fontSize: 12),
                                                                                ),

                                                                                // Text("No",style:TextStyle(color: Color(Constants.greaytext),fontFamily: Constants.app_font,fontSize: 12),),
                                                                                // Text(" ",style:TextStyle(color: Color(Constants.greentext),fontFamily: Constants.app_font,fontSize: 12),),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      border: Border.all(
                                                                                        color: Colors.transparent,
                                                                                      ),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                  margin: EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 30),
                                                                                  alignment: Alignment.center,
                                                                                  child: CachedNetworkImage(
                                                                                    // imageUrl: imageurl,

                                                                                    imageUrl: comsearchlist[index].vendor!.image!,
                                                                                    fit: BoxFit.fill,
                                                                                    width: screenWidth * 0.15,
                                                                                    height: screenHeight * 0.09,

                                                                                    imageBuilder: (context, imageProvider) => ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                                      child: Image(
                                                                                        image: imageProvider,
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) => SpinKitFadingCircle(color: Color(Constants.greentext)),
                                                                                    errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 4,
                                                                              child: Container(
                                                                                // width: screenWidth * 0.65,
                                                                                height: screenHeight * 0.15,
                                                                                color: Color(Constants.itembgcolor),
                                                                                margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: AutoSizeText(
                                                                                            comsearchlist[index].vendor!.name!,
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.visible,
                                                                                            style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: 0, left: 5, right: 10, bottom: 0),
                                                                                              alignment: Alignment.topRight,
                                                                                              child: SvgPicture.asset(
                                                                                                "images/veg.svg",
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
                                                                                              alignment: Alignment.topRight,
                                                                                              child: SvgPicture.asset(
                                                                                                "images/nonveg.svg",
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.topLeft,
                                                                                      margin: EdgeInsets.only(top: 10, left: 0, right: 5, bottom: 0),

                                                                                      color: Colors.transparent,
                                                                                      // height:screenHeight * 0.03,
                                                                                      child: AutoSizeText(
                                                                                        comsearchlist[index].vendor!.mapAddress!,
                                                                                        overflow: TextOverflow.visible,
                                                                                        maxLines: 3,
                                                                                        style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 14),
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
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                20,
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        width:
                                                                            screenWidth,
                                                                        child:
                                                                            DottedLine(
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          lineLength:
                                                                              double.infinity,
                                                                          lineThickness:
                                                                              1.0,
                                                                          dashLength:
                                                                              8.0,
                                                                          dashColor:
                                                                              Color(Constants.dashline),
                                                                          dashRadius:
                                                                              0.0,
                                                                          dashGapLength:
                                                                              5.0,
                                                                          dashGapColor:
                                                                              Colors.transparent,
                                                                          dashGapRadius:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              comsearchlist[index].user!.name!,
                                                                              style: TextStyle(color: Colors.white, fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            ),
                                                                            RichText(
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textScaleFactor: 1,
                                                                              text: TextSpan(
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
                                                                                        distance + " " + Languages.of(context)!.kmfarawaylable,
                                                                                        style: TextStyle(
                                                                                          color: Color(Constants.whitetext),
                                                                                          fontSize: 12,
                                                                                          fontFamily: Constants.app_font,
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
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          comsearchlist[index]
                                                                              .userAddress!
                                                                              .address!,
                                                                          overflow:
                                                                              TextOverflow.visible,
                                                                          maxLines:
                                                                              5,
                                                                          style: TextStyle(
                                                                              color: Color(Constants.greaytext),
                                                                              fontFamily: Constants.app_font,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                30,
                                                                            bottom:
                                                                                20,
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        width:
                                                                            screenWidth,
                                                                        child:
                                                                            DottedLine(
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          lineLength:
                                                                              double.infinity,
                                                                          lineThickness:
                                                                              1.0,
                                                                          dashLength:
                                                                              8.0,
                                                                          dashColor:
                                                                              Color(Constants.dashline),
                                                                          dashRadius:
                                                                              0.0,
                                                                          dashGapLength:
                                                                              5.0,
                                                                          dashGapColor:
                                                                              Colors.transparent,
                                                                          dashGapRadius:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                2,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: ListView(
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                          margin: EdgeInsets.only(left: 0),
                                                                                          child: Text(
                                                                                            Languages.of(context)!.paymentlable,
                                                                                            style: TextStyle(color: Color(Constants.whitetext), fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                          )),
                                                                                      Container(
                                                                                          margin: EdgeInsets.only(left: 5),
                                                                                          child: Text(
                                                                                            "(" + paymentstatus + ")",
                                                                                            style: TextStyle(color: paymentcolor, fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                  Text(
                                                                                    Languages.of(context)!.cashondeliverylable,
                                                                                    style: TextStyle(color: Color(Constants.greaytext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Container(
                                                                                    margin: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                                                                                    alignment: Alignment.topRight,
                                                                                    child: Text(
                                                                                      Languages.of(context)!.ordercompletesucesslable,
                                                                                      maxLines: 3,
                                                                                      overflow: TextOverflow.visible,
                                                                                      style: TextStyle(color: Color(Constants.greentext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            comporderdatalist
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          String paymentstatus;
                                                          Color paymentcolor;
                                                          if (comporderdatalist[
                                                                      index]
                                                                  .paymentStatus
                                                                  .toString() ==
                                                              "0") {
                                                            paymentstatus =
                                                                "Pending";
                                                            paymentcolor =
                                                                Color(Constants
                                                                    .redtext);
                                                          } else {
                                                            paymentstatus =
                                                                "Completed";
                                                            paymentcolor =
                                                                Color(Constants
                                                                    .greentext);
                                                          }

                                                          double user_lat =
                                                              double.parse(
                                                                  comporderdatalist[
                                                                          index]
                                                                      .userAddress!
                                                                      .lat!);
                                                          double user_long =
                                                              double.parse(
                                                                  comporderdatalist[
                                                                          index]
                                                                      .userAddress!
                                                                      .lang!);
                                                          // assert(user_lat
                                                          //     is double);
                                                          // assert(user_long
                                                          //     is double);
                                                          String distance = "0";
                                                          double
                                                              distanceInMeters =
                                                              Geolocator.distanceBetween(
                                                                  current_lat,
                                                                  current_long,
                                                                  user_lat,
                                                                  user_long);
                                                          double distanceinkm =
                                                              distanceInMeters /
                                                                  1000;
                                                          String str =
                                                              distanceinkm
                                                                  .toString();
                                                          var distance12 =
                                                              str.split('.');
                                                          distance =
                                                              distance12[0];

                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .all(ScreenUtil()
                                                                    .setWidth(
                                                                        8)),
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      right: 5,
                                                                      bottom: 0,
                                                                      left: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          Constants
                                                                              .itembgcolor),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Color(
                                                                            Constants.itembgcolor),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(12))),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: ScreenUtil()
                                                                        .setWidth(
                                                                            0),
                                                                    right: ScreenUtil()
                                                                        .setWidth(
                                                                            0)),
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              Languages.of(context)!.oidlable + "  " + comporderdatalist[index].orderId!,
                                                                              style: TextStyle(color: Colors.white, fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            ),
                                                                            Text(
                                                                              Languages.of(context)!.dollersignlable + " " + comporderdatalist[index].amount.toString(),
                                                                              style: TextStyle(color: Color(Constants.color_theme), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        itemCount: comporderdatalist[index]
                                                                            .orderItems!
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                                position) {
                                                                          return Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10, left: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  comporderdatalist[index].orderItems![position].itemName!,
                                                                                  style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 12),
                                                                                ),
                                                                                Text(
                                                                                  "  x " + comporderdatalist[index].orderItems![position].qty.toString(),
                                                                                  style: TextStyle(color: Color(Constants.greentext), fontFamily: Constants.app_font, fontSize: 12),
                                                                                ),

                                                                                // Text("No",style:TextStyle(color: Color(Constants.greaytext),fontFamily: Constants.app_font,fontSize: 12),),
                                                                                // Text(" ",style:TextStyle(color: Color(Constants.greentext),fontFamily: Constants.app_font,fontSize: 12),),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      border: Border.all(
                                                                                        color: Colors.transparent,
                                                                                      ),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                  margin: EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 30),
                                                                                  alignment: Alignment.center,
                                                                                  child: CachedNetworkImage(
                                                                                    // imageUrl: imageurl,

                                                                                    imageUrl: comporderdatalist[index].vendor!.image!,
                                                                                    fit: BoxFit.fill,
                                                                                    width: screenWidth * 0.15,
                                                                                    height: screenHeight * 0.09,

                                                                                    imageBuilder: (context, imageProvider) => ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                                      child: Image(
                                                                                        image: imageProvider,
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) => SpinKitFadingCircle(color: Color(Constants.greentext)),
                                                                                    errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 4,
                                                                              child: Container(
                                                                                // width: screenWidth * 0.65,
                                                                                height: screenHeight * 0.15,
                                                                                color: Color(Constants.itembgcolor),
                                                                                margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: AutoSizeText(
                                                                                            comporderdatalist[index].vendor!.name!,
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.visible,
                                                                                            style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: 0, left: 5, right: 10, bottom: 0),
                                                                                              alignment: Alignment.topRight,
                                                                                              child: SvgPicture.asset(
                                                                                                "images/veg.svg",
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
                                                                                              alignment: Alignment.topRight,
                                                                                              child: SvgPicture.asset(
                                                                                                "images/nonveg.svg",
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.topLeft,
                                                                                      margin: EdgeInsets.only(top: 10, left: 0, right: 5, bottom: 0),

                                                                                      color: Colors.transparent,
                                                                                      // height:screenHeight * 0.03,
                                                                                      child: AutoSizeText(
                                                                                        comporderdatalist[index].vendor!.mapAddress ?? '',
                                                                                        overflow: TextOverflow.visible,
                                                                                        maxLines: 3,
                                                                                        style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 14),
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
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                20,
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        width:
                                                                            screenWidth,
                                                                        child:
                                                                            DottedLine(
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          lineLength:
                                                                              double.infinity,
                                                                          lineThickness:
                                                                              1.0,
                                                                          dashLength:
                                                                              8.0,
                                                                          dashColor:
                                                                              Color(Constants.dashline),
                                                                          dashRadius:
                                                                              0.0,
                                                                          dashGapLength:
                                                                              5.0,
                                                                          dashGapColor:
                                                                              Colors.transparent,
                                                                          dashGapRadius:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              comporderdatalist[index].user!.name!,
                                                                              style: TextStyle(color: Colors.white, fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                            ),
                                                                            RichText(
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textScaleFactor: 1,
                                                                              text: TextSpan(
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
                                                                                        distance + " " + Languages.of(context)!.kmfarawaylable,
                                                                                        style: TextStyle(
                                                                                          color: Color(Constants.whitetext),
                                                                                          fontSize: 12,
                                                                                          fontFamily: Constants.app_font,
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
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          comporderdatalist[index]
                                                                              .userAddress!
                                                                              .address!,
                                                                          overflow:
                                                                              TextOverflow.visible,
                                                                          maxLines:
                                                                              5,
                                                                          style: TextStyle(
                                                                              color: Color(Constants.greaytext),
                                                                              fontFamily: Constants.app_font,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                30,
                                                                            bottom:
                                                                                20,
                                                                            right:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        width:
                                                                            screenWidth,
                                                                        child:
                                                                            DottedLine(
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          lineLength:
                                                                              double.infinity,
                                                                          lineThickness:
                                                                              1.0,
                                                                          dashLength:
                                                                              8.0,
                                                                          dashColor:
                                                                              Color(Constants.dashline),
                                                                          dashRadius:
                                                                              0.0,
                                                                          dashGapLength:
                                                                              5.0,
                                                                          dashGapColor:
                                                                              Colors.transparent,
                                                                          dashGapRadius:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                2,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: ListView(
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                          margin: EdgeInsets.only(left: 0),
                                                                                          child: Text(
                                                                                            Languages.of(context)!.paymentlable,
                                                                                            style: TextStyle(color: Color(Constants.whitetext), fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                          )),
                                                                                      Container(
                                                                                          margin: EdgeInsets.only(left: 5),
                                                                                          child: Text(
                                                                                            "(" + paymentstatus + ")",
                                                                                            style: TextStyle(color: paymentcolor, fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                  Text(
                                                                                    Languages.of(context)!.cashondeliverylable,
                                                                                    style: TextStyle(color: Color(Constants.greaytext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Container(
                                                                                    margin: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                                                                                    alignment: Alignment.topRight,
                                                                                    child: Text(
                                                                                      Languages.of(context)!.ordercompletesucesslable,
                                                                                      maxLines: 3,
                                                                                      overflow: TextOverflow.visible,
                                                                                      style: TextStyle(color: Color(Constants.greentext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),

                                            ),

                                        /*  Cancel List*/

                                        Container(
                                          child:
                                              cansearchlist.length != 0 ||
                                                      can_controller
                                                          .text.isNotEmpty
                                                  ? ListView.builder(
                                                      itemCount:
                                                          cansearchlist.length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          AlwaysScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        String paymentstatus;
                                                        Color paymentcolor;
                                                        if (cansearchlist[index]
                                                                .paymentStatus
                                                                .toString() ==
                                                            "0") {
                                                          paymentstatus =
                                                              "Pending";
                                                          paymentcolor = Color(
                                                              Constants
                                                                  .redtext);
                                                        } else {
                                                          paymentstatus =
                                                              "Completed";
                                                          paymentcolor = Color(
                                                              Constants
                                                                  .greentext);
                                                        }

                                                        double user_lat =
                                                            double.parse(
                                                                cansearchlist[
                                                                        index]
                                                                    .userAddress!
                                                                    .lat!);
                                                        double user_long =
                                                            double.parse(
                                                                cansearchlist[
                                                                        index]
                                                                    .userAddress!
                                                                    .lang!);
                                                        // assert(
                                                        //     user_lat is double);
                                                        // assert(user_long
                                                        //     is double);
                                                        String distance = "0";
                                                        double
                                                            distanceInMeters =
                                                            Geolocator
                                                                .distanceBetween(
                                                                    current_lat,
                                                                    current_long,
                                                                    user_lat,
                                                                    user_long);
                                                        double distanceinkm =
                                                            distanceInMeters /
                                                                1000;
                                                        String str =
                                                            distanceinkm
                                                                .toString();
                                                        var distance12 =
                                                            str.split('.');
                                                        distance =
                                                            distance12[0];
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .all(ScreenUtil()
                                                                  .setWidth(8)),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 5,
                                                                    bottom: 0,
                                                                    left: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color(
                                                                        Constants
                                                                            .itembgcolor),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Color(
                                                                          Constants
                                                                              .itembgcolor),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(12))),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: ScreenUtil()
                                                                      .setWidth(
                                                                          0),
                                                                  right: ScreenUtil()
                                                                      .setWidth(
                                                                          0)),
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            Languages.of(context)!.oidlable +
                                                                                "   " +
                                                                                cansearchlist[index].orderId!,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          ),
                                                                          Text(
                                                                            Languages.of(context)!.dollersignlable +
                                                                                cansearchlist[index].amount.toString(),
                                                                            style: TextStyle(
                                                                                color: Color(Constants.color_theme),
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    ListView
                                                                        .builder(
                                                                      itemCount: cansearchlist[
                                                                              index]
                                                                          .orderItems!
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              position) {
                                                                        return Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              left: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                cansearchlist[index].orderItems![position].itemName!,
                                                                                style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 12),
                                                                              ),
                                                                              Text(
                                                                                "  x " + cansearchlist[index].orderItems![position].qty.toString(),
                                                                                style: TextStyle(color: Color(Constants.greentext), fontFamily: Constants.app_font, fontSize: 12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    border: Border.all(
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                margin: EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 30),
                                                                                alignment: Alignment.center,
                                                                                child: CachedNetworkImage(
                                                                                  // imageUrl: imageurl,

                                                                                  imageUrl: cansearchlist[index].vendor!.image!,
                                                                                  fit: BoxFit.fill,
                                                                                  width: screenWidth * 0.15,
                                                                                  height: screenHeight * 0.09,

                                                                                  imageBuilder: (context, imageProvider) => ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                    child: Image(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  placeholder: (context, url) => SpinKitFadingCircle(color: Color(Constants.greentext)),
                                                                                  errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              // width: screenWidth * 0.65,
                                                                              height: screenHeight * 0.15,
                                                                              color: Color(Constants.itembgcolor),
                                                                              margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        alignment: Alignment.topLeft,
                                                                                        child: AutoSizeText(
                                                                                          cansearchlist[index].vendor!.name!,
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.visible,
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 0, left: 5, right: 2, bottom: 0),
                                                                                            alignment: Alignment.topRight,
                                                                                            child: SvgPicture.asset(
                                                                                              "images/veg.svg",
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 0, left: 2, right: 10, bottom: 0),
                                                                                            alignment: Alignment.topRight,
                                                                                            child: SvgPicture.asset(
                                                                                              "images/nonveg.svg",
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.topLeft,
                                                                                    margin: EdgeInsets.only(top: 10, left: 0, right: 5, bottom: 0),

                                                                                    color: Colors.transparent,
                                                                                    // height:screenHeight * 0.03,
                                                                                    child: AutoSizeText(
                                                                                      cansearchlist[index].vendor!.mapAddress!,
                                                                                      overflow: TextOverflow.visible,
                                                                                      maxLines: 3,
                                                                                      style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 14),
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
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              20,
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                      width:
                                                                          screenWidth,
                                                                      child:
                                                                          DottedLine(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        lineLength:
                                                                            double.infinity,
                                                                        lineThickness:
                                                                            1.0,
                                                                        dashLength:
                                                                            8.0,
                                                                        dashColor:
                                                                            Color(Constants.dashline),
                                                                        dashRadius:
                                                                            0.0,
                                                                        dashGapLength:
                                                                            5.0,
                                                                        dashGapColor:
                                                                            Colors.transparent,
                                                                        dashGapRadius:
                                                                            0.0,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            cansearchlist[index].user!.name!,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          ),
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
                                                                                      distance + " " + Languages.of(context)!.kmfarawaylable,
                                                                                      style: TextStyle(
                                                                                        color: Color(Constants.whitetext),
                                                                                        fontSize: 12,
                                                                                        fontFamily: Constants.app_font,
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
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        cansearchlist[index]
                                                                            .userAddress!
                                                                            .address!,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        maxLines:
                                                                            5,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(Constants.greaytext),
                                                                            fontFamily: Constants.app_font,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              30,
                                                                          bottom:
                                                                              20,
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                      width:
                                                                          screenWidth,
                                                                      child:
                                                                          DottedLine(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        lineLength:
                                                                            double.infinity,
                                                                        lineThickness:
                                                                            1.0,
                                                                        dashLength:
                                                                            8.0,
                                                                        dashColor:
                                                                            Color(Constants.dashline),
                                                                        dashRadius:
                                                                            0.0,
                                                                        dashGapLength:
                                                                            5.0,
                                                                        dashGapColor:
                                                                            Colors.transparent,
                                                                        dashGapRadius:
                                                                            0.0,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                          2,
                                                                          left:
                                                                          10,
                                                                          right:
                                                                          10,
                                                                          bottom:
                                                                          20),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 2,
                                                                            child: ListView(
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        margin: EdgeInsets.only(left: 0),
                                                                                        child: Text(
                                                                                          Languages.of(context)!.paymentlable,
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                        )),
                                                                                    Container(
                                                                                        margin: EdgeInsets.only(left: 5),
                                                                                        child: Text(
                                                                                          "(" + paymentstatus + ")",
                                                                                          style: TextStyle(color: paymentcolor, fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                                Text(
                                                                                  Languages.of(context)!.cashondeliverylable,
                                                                                  style: TextStyle(color: Color(Constants.greaytext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Container(
                                                                              child: Container(
                                                                                  margin: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                                                                                  alignment: Alignment.topRight,
                                                                                  child: Text(
                                                                                    "Order Delivered",
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.visible,
                                                                                    style: TextStyle(color: Color(Constants.greentext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                  ]),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : ListView.builder(
                                                      itemCount:
                                                          canorderdatalist
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          AlwaysScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        String paymentstatus;
                                                        Color paymentcolor;
                                                        if (canorderdatalist[
                                                                    index]
                                                                .paymentStatus
                                                                .toString() ==
                                                            "0") {
                                                          paymentstatus =
                                                              "Pending";
                                                          paymentcolor = Color(
                                                              Constants
                                                                  .redtext);
                                                        } else {
                                                          paymentstatus =
                                                              "Completed";
                                                          paymentcolor = Color(
                                                              Constants
                                                                  .greentext);
                                                        }

                                                        double user_lat =
                                                            double.parse(
                                                                canorderdatalist[
                                                                        index]
                                                                    .userAddress!
                                                                    .lat!);
                                                        double user_long =
                                                            double.parse(
                                                                canorderdatalist[
                                                                        index]
                                                                    .userAddress!
                                                                    .lang!);
                                                        // assert(
                                                        //     user_lat is double);
                                                        // assert(user_long
                                                        //     is double);
                                                        String distance = "0";
                                                        double
                                                            distanceInMeters =
                                                            Geolocator
                                                                .distanceBetween(
                                                                    current_lat,
                                                                    current_long,
                                                                    user_lat,
                                                                    user_long);
                                                        double distanceinkm =
                                                            distanceInMeters /
                                                                1000;
                                                        String str =
                                                            distanceinkm
                                                                .toString();
                                                        var distance12 =
                                                            str.split('.');
                                                        distance =
                                                            distance12[0];
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .all(ScreenUtil()
                                                                  .setWidth(8)),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 5,
                                                                    bottom: 0,
                                                                    left: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color(
                                                                        Constants
                                                                            .itembgcolor),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Color(
                                                                          Constants
                                                                              .itembgcolor),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(12))),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: ScreenUtil()
                                                                      .setWidth(
                                                                          0),
                                                                  right: ScreenUtil()
                                                                      .setWidth(
                                                                          0)),
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            Languages.of(context)!.oidlable +
                                                                                "   " +
                                                                                canorderdatalist[index].orderId!,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          ),
                                                                          Text(
                                                                            Languages.of(context)!.dollersignlable +
                                                                                canorderdatalist[index].amount.toString(),
                                                                            style: TextStyle(
                                                                                color: Color(Constants.color_theme),
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    ListView
                                                                        .builder(
                                                                      itemCount: canorderdatalist[
                                                                              index]
                                                                          .orderItems!
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              position) {
                                                                        return Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              left: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                canorderdatalist[index].orderItems![position].itemName!,
                                                                                style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 12),
                                                                              ),
                                                                              Text(
                                                                                "  x " + canorderdatalist[index].orderItems![position].qty.toString(),
                                                                                style: TextStyle(color: Color(Constants.greentext), fontFamily: Constants.app_font, fontSize: 12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    border: Border.all(
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                margin: EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 30),
                                                                                alignment: Alignment.center,
                                                                                child: CachedNetworkImage(
                                                                                  // imageUrl: imageurl,

                                                                                  imageUrl: canorderdatalist[index].vendor!.image!,
                                                                                  fit: BoxFit.fill,
                                                                                  width: screenWidth * 0.15,
                                                                                  height: screenHeight * 0.09,

                                                                                  imageBuilder: (context, imageProvider) => ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                    child: Image(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  placeholder: (context, url) => SpinKitFadingCircle(color: Color(Constants.greentext)),
                                                                                  errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              // width: screenWidth * 0.65,
                                                                              height: screenHeight * 0.15,
                                                                              color: Color(Constants.itembgcolor),
                                                                              margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        alignment: Alignment.topLeft,
                                                                                        child: AutoSizeText(
                                                                                          canorderdatalist[index].vendor!.name!,
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.visible,
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.app_font_bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 0, left: 5, right: 2, bottom: 0),
                                                                                            alignment: Alignment.topRight,
                                                                                            child: SvgPicture.asset(
                                                                                              "images/veg.svg",
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 0, left: 2, right: 10, bottom: 0),
                                                                                            alignment: Alignment.topRight,
                                                                                            child: SvgPicture.asset(
                                                                                              "images/nonveg.svg",
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.topLeft,
                                                                                    margin: EdgeInsets.only(top: 10, left: 0, right: 5, bottom: 0),

                                                                                    color: Colors.transparent,
                                                                                    // height:screenHeight * 0.03,
                                                                                    child: AutoSizeText(
                                                                                      canorderdatalist[index].vendor!.mapAddress ?? '',
                                                                                      overflow: TextOverflow.visible,
                                                                                      maxLines: 3,
                                                                                      style: TextStyle(color: Color(Constants.greaytext), fontFamily: Constants.app_font, fontSize: 14),
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
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              20,
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                      width:
                                                                          screenWidth,
                                                                      child:
                                                                          DottedLine(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        lineLength:
                                                                            double.infinity,
                                                                        lineThickness:
                                                                            1.0,
                                                                        dashLength:
                                                                            8.0,
                                                                        dashColor:
                                                                            Color(Constants.dashline),
                                                                        dashRadius:
                                                                            0.0,
                                                                        dashGapLength:
                                                                            5.0,
                                                                        dashGapColor:
                                                                            Colors.transparent,
                                                                        dashGapRadius:
                                                                            0.0,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            canorderdatalist[index].user!.name!,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: Constants.app_font_bold,
                                                                                fontSize: 16),
                                                                          ),
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
                                                                                      distance + " " + Languages.of(context)!.kmfarawaylable,
                                                                                      style: TextStyle(
                                                                                        color: Color(Constants.whitetext),
                                                                                        fontSize: 12,
                                                                                        fontFamily: Constants.app_font,
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
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        canorderdatalist[index]
                                                                            .userAddress!
                                                                            .address!,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        maxLines:
                                                                            5,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(Constants.greaytext),
                                                                            fontFamily: Constants.app_font,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              30,
                                                                          bottom:
                                                                              20,
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                      width:
                                                                          screenWidth,
                                                                      child:
                                                                          DottedLine(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        lineLength:
                                                                            double.infinity,
                                                                        lineThickness:
                                                                            1.0,
                                                                        dashLength:
                                                                            8.0,
                                                                        dashColor:
                                                                            Color(Constants.dashline),
                                                                        dashRadius:
                                                                            0.0,
                                                                        dashGapLength:
                                                                            5.0,
                                                                        dashGapColor:
                                                                            Colors.transparent,
                                                                        dashGapRadius:
                                                                            0.0,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                          2,
                                                                          left:
                                                                          10,
                                                                          right:
                                                                          10,
                                                                          bottom:
                                                                          20),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 2,
                                                                            child: ListView(
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        margin: EdgeInsets.only(left: 0),
                                                                                        child: Text(
                                                                                          Languages.of(context)!.paymentlable,
                                                                                          style: TextStyle(color: Color(Constants.whitetext), fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                        )),
                                                                                    Container(
                                                                                        margin: EdgeInsets.only(left: 5),
                                                                                        child: Text(
                                                                                          "(" + paymentstatus + ")",
                                                                                          style: TextStyle(color: paymentcolor, fontSize: 16, fontFamily: Constants.app_font_bold),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                                Text(
                                                                                  Languages.of(context)!.cashondeliverylable,
                                                                                  style: TextStyle(color: Color(Constants.greaytext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Container(
                                                                              child: Container(
                                                                                  margin: EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 0),
                                                                                  alignment: Alignment.topRight,
                                                                                  child: Text(
                                                                                    "Order Delivered",
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.visible,
                                                                                    style: TextStyle(color: Color(Constants.greentext), fontSize: 14, fontFamily: Constants.app_font),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                  ]),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // new Container(child: Body())
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async{
    return true;
  }

  ComSearchTextChanged(String text) async {
    print("searchtext123456:$text");
    comsearchlist.clear();

    setState(() {
      if (text.isNotEmpty) {
        print("searchtext852:$text");

        comporderdatalist.forEach((comsearchdata) {
          if (comsearchdata.orderId!.contains(text))
            comsearchlist.add(comsearchdata);
          print("com_searchtextlength:${comsearchlist.length}");
        });
      } else {
        return;
      }
    });

    setState(() {});
  }

  CanSearchTextChanged(String text) async {
    print("searchtext:$text");
    cansearchlist.clear();

    setState(() {
      if (text.isNotEmpty) {
        print("searchtext852:$text");

        canorderdatalist.forEach((cansearchdata) {
          if (cansearchdata.orderId!.contains(text) ||
              cansearchdata.orderId!.contains(text))
            cansearchlist.add(cansearchdata);
          print("can_searchtextlength:${cansearchlist.length}");
        });
      } else {
        return;
      }
    });

    setState(() {});
  }
}
