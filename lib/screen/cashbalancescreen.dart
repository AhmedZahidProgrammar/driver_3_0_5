import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/model/orderwiseearning.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class MyCashBalance extends StatefulWidget {
  @override
  _MyCashBalance createState() => _MyCashBalance();
}

class _MyCashBalance extends State<MyCashBalance> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;

  String totalamount = "0";
  bool showdata = false;
  bool nodata = false;

  List<EarningData> earningdata = <EarningData>[];
  List<EarningData> searchlist = <EarningData>[];
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // final DateTime  now = DateTime.parse("2020-12-26");
    // // final DateTime =  DateTime.parse("2020-12-26T12:57:12.000000Z");
    // final DateFormat formatter = DateFormat('EEEE');
    // final String formatted = formatter.format(now);
    //
    //
    // final DateFormat formatter1 = DateFormat('MMMM dd, yyyy');
    // final String formatted1 = formatter1.format(now);
    //
    // print("formatted:$formatted");
    // print("formatted1:$formatted1");

    if (mounted) {
      Constants.CheckNetwork().whenComplete(() => CallApiForGetOrHistory());
    }
  }

  void CallApiForGetOrHistory() {
    setState(() {
      showSpinner = true;
    });

    RestClient(Api_Header().Dio_Data())
        .driverorderwiseearning()
        .then((response) {
      if (response.success == true) {
        setState(() {
          showSpinner = false;
        });

        setState(() {
          totalamount = response.totalEarning.toString();

          if (response.data!.length != 0) {
            earningdata.addAll(response.data!);
            nodata = false;
            showdata = true;
          } else {
            setState(() {
              showSpinner = false;
              nodata = true;
              showdata = false;
            });
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          nodata = true;
          showdata = false;
        });
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text(
          Languages.of(context)!.servererrorlable,
        ),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        showSpinner = false;
        nodata = true;
        showdata = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  @override
  Widget build(BuildContext context) {
  //  ScreenUtil.init(context, designSize: Size(screenWidth, screenHeight), allowFontScaling: true);

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
                    Languages.of(context)!.mycachebalancelable,
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
                              margin: EdgeInsets.only(bottom: 10),
                              color: Colors.transparent,
                              child: Column(
                                // physics: NeverScrollableScrollPhysics(),

                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(0)),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 0,
                                          right: 20,
                                          bottom: 0,
                                          left: 20),
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
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  right: 10,
                                                  bottom: 10,
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            Languages.of(
                                                                    context)!
                                                                .totalbalancelable,
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
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 2),
                                                          child: Text(
                                                            "\$ " + totalamount,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greentext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 22),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: false,
                                                    child: Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: ScreenUtil()
                                                            .setHeight(45),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(Constants
                                                                  .itembgcolor)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          35)),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: <Color>[
                                                              Color(0xFF6a7eff),
                                                              Color(0xFF3d6feb),
                                                              Color(0xFF1863db),
                                                            ],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Transfer To The Bank",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .whitetext),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      Constants
                                                                          .app_font),
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "images/white_right.svg"))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 10),
                                              child: Card(
                                                color: Color(Constants.bgcolor),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                elevation: 5.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: TextFormField(
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: controller,
                                                    onChanged:
                                                        onSearchTextChanged,
                                                    validator: Constants
                                                        .kvalidateEmail,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: Constants
                                                            .app_font_bold),
                                                    decoration: Constants
                                                        .kTextFieldInputDecoration1
                                                        .copyWith(
                                                            hintText: Languages
                                                                    .of(context)!
                                                                .searchorderidlable,
                                                            hintStyle: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .color_hint),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: showdata,
                                    child: searchlist.length != 0 ||
                                            controller.text.isNotEmpty
                                        ? new ListView.builder(
                                            itemCount: searchlist.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              bool divider = false;

                                              if (index ==
                                                  searchlist.length - 1) {
                                                divider = false;
                                              } else {
                                                divider = true;
                                              }

                                              final DateTime now =
                                                  DateTime.parse(
                                                      searchlist[index].date!);
                                              final DateFormat formatter =
                                                  DateFormat('EEEE');
                                              final String day =
                                                  formatter.format(now);

                                              final DateFormat formatter1 =
                                                  DateFormat('MMMM dd, yyyy');
                                              final String date =
                                                  formatter1.format(now);

                                              print("formated_day:$day");
                                              print("formated_date:$date");

                                              return Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 0, right: 0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            Languages.of(
                                                                        context)!
                                                                    .oidlable +
                                                                "   " +
                                                                searchlist[
                                                                        index]
                                                                    .orderId,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font_bold,
                                                                fontSize: 16),
                                                          ),
                                                          Text(
                                                            "+ " +
                                                                "\$" +
                                                                searchlist[
                                                                        index]
                                                                    .earning
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greentext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 14),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 2,
                                                          left: 20,
                                                          right: 20),
                                                      child: Text(
                                                        searchlist[index]
                                                            .userName!,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greaytext),
                                                            fontFamily: Constants
                                                                .app_font_bold,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 2,
                                                          left: 20,
                                                          right: 20),
                                                      child: Text(
                                                        day + " - " + date,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greaytext),
                                                            fontFamily:
                                                                Constants
                                                                    .app_font,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: divider,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 15,
                                                            left: 20,
                                                            bottom: 0,
                                                            right: 20),
                                                        child: Divider(
                                                          height: 1,
                                                          thickness: 0.5,
                                                          color: Color(Constants
                                                              .dashline),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : ListView.builder(
                                            itemCount: earningdata.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              bool divider = false;

                                              if (index ==
                                                  earningdata.length - 1) {
                                                divider = false;
                                              } else {
                                                divider = true;
                                              }

                                              final DateTime now =
                                                  DateTime.parse(
                                                      earningdata[index].date!);
                                              // final DateTime =  DateTime.parse("2020-12-26T12:57:12.000000Z");
                                              final DateFormat formatter =
                                                  DateFormat('EEEE');
                                              final String day =
                                                  formatter.format(now);

                                              final DateFormat formatter1 =
                                                  DateFormat('MMMM dd, yyyy');
                                              final String date =
                                                  formatter1.format(now);

                                              print("formated_day:$day");
                                              print("formated_date:$date");

                                              return Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 0, right: 0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            Languages.of(
                                                                        context)!
                                                                    .oidlable +
                                                                "   " +
                                                                earningdata[
                                                                        index]
                                                                    .orderId,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .whitetext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font_bold,
                                                                fontSize: 16),
                                                          ),
                                                          Text(
                                                            "+ " +
                                                                "\$" +
                                                                earningdata[
                                                                        index]
                                                                    .earning
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greentext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 14),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 2,
                                                          left: 20,
                                                          right: 20),
                                                      child: Text(
                                                        earningdata[index]
                                                            .userName!,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greaytext),
                                                            fontFamily: Constants
                                                                .app_font_bold,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 2,
                                                          left: 20,
                                                          right: 20),
                                                      child: Text(
                                                        day + " - " + date,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greaytext),
                                                            fontFamily:
                                                                Constants
                                                                    .app_font,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: divider,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 15,
                                                            left: 20,
                                                            bottom: 0,
                                                            right: 20),
                                                        child: Divider(
                                                          height: 1,
                                                          thickness: 0.5,
                                                          color: Color(Constants
                                                              .dashline),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  Visibility(
                                    visible: nodata,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    .nodatalable,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )),
          ),
        ));
  }

  // ignore: missing_return
  Future<bool> _onWillPop() async{
   return true;
  }

  onSearchTextChanged(String text) async {
    print("searchtext:$text");
    searchlist.clear();

    setState(() {
      if (text.isNotEmpty) {
        print("searchtext852:$text");

        earningdata.forEach((earningdata) {
          if (earningdata.orderId.contains(text) ||
              earningdata.orderId.contains(text)) searchlist.add(earningdata);
        });
      } else {
        return;
      }
    });

    setState(() {});
  }
}
