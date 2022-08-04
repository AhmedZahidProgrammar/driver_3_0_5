import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/controller/profile_controller.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/screen/myprofilescreen.dart';
import 'package:driver_3_0_5/screen/orderlistscreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int initalindex;

  HomeScreen(this.initalindex);

  @override
  _HomeScreen createState() => new _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String name = "User";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Constants.CheckNetwork().whenComplete(() => callApiForsetting());
  }

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/background_image.png'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          // resizeToAvoidBottomPadding: true,
          key: _drawerscaffoldkey,
          bottomNavigationBar: BottomBar(widget.initalindex),
        ),
      )),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(Languages.of(context)!.areyousurelable),
            content: new Text(Languages.of(context)!.wanttoexitlable),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(Languages.of(context)!.nolable),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(Languages.of(context)!.yeslable),
              ),
            ],
          ),
        ).then((value) => value as bool);
  }

  void callApiForsetting() {
    RestClient(Api_Header().Dio_Data()).driversetting().then((response) {
      if (response.success == true) {
        print("Setting true");

        if (response.data!.globalDriver == "true") {
          setState(() {
            PreferenceUtils.putBool(Constants.isGlobalDriver, true);
          });
        }

        PreferenceUtils.setString(
            Constants.driversetvehicaltype, response.data!.driverVehicalType!);
        PreferenceUtils.setString(Constants.is_driver_accept_multipleorder,
            response.data!.isDriverAcceptMultipleorder.toString());

        response.data!.driverAcceptMultipleOrderCount != null
            ? PreferenceUtils.setString(Constants.driver_accept_multiple_order_count,
            response.data!.driverAcceptMultipleOrderCount.toString())
            : PreferenceUtils.setString(Constants.driver_accept_multiple_order_count, '');

        response.data!.driverAutoRefrese != null
            ? PreferenceUtils.setString(Constants.driver_auto_refrese,
                response.data!.driverAutoRefrese.toString())
            : PreferenceUtils.setString(Constants.driver_auto_refrese, '');

        response.data!.driverAppId != null
            ? PreferenceUtils.setString(Constants.one_signal_app_id,
            response.data!.driverAppId.toString())
            : PreferenceUtils.setString(Constants.one_signal_app_id, '');

        response.data!.cancelReason != null
            ? PreferenceUtils.setString(Constants.cancel_reason,
            response.data!.cancelReason.toString())
            : PreferenceUtils.setString(Constants.cancel_reason, '');


        print(PreferenceUtils.getString(Constants.is_driver_accept_multipleorder));
        print(PreferenceUtils.getString(Constants.driversetvehicaltype));
        print("Vehicletype:${response.data!.driverVehicalType}");
      } else {}
    }).catchError((Object obj) {
      // pr.hide();
      print("error:$obj.");
      print(obj.runtimeType);

      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response!;
          print(res);

          var responsecode = res.statusCode;
          // print(responsecode);

          if (responsecode == 401) {
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            print("code:$responsecode");
          }

          break;
        default:
      }
    });
  }
}
//ignore: must_be_immutable
class BottomBar extends StatefulWidget {
   int _currentIndex;


  BottomBar(this._currentIndex);

  @override
  State<StatefulWidget> createState() {
    return BottomBar1();
  }
}

class BottomBar1 extends State<BottomBar> {
  ProfileController _profileController=Get.put(ProfileController());
  final List<Widget> _children = [
    OrderList(),
    //NotificationList(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: _children[widget._currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          selectedItemColor:Color(Constants.color_theme),
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
              color: Color(Constants.color_theme),
              fontSize: 12,
              fontFamily: Constants.app_font),
          unselectedLabelStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: Constants.app_font),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(Constants.itembgcolor),
          currentIndex: widget._currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset("images/orders.svg"),
                activeIcon: SvgPicture.asset("images/order_green.svg"),
                label: Languages.of(context)!.orderslable),
            // BottomNavigationBarItem(
            //     icon: SvgPicture.asset("images/notification.svg"),
            //     activeIcon: SvgPicture.asset("images/notification_green.svg"),
            //     label: Languages.of(context)!.notificationlable),
            BottomNavigationBarItem(
                icon: Image.asset("images/profile.png"),
                activeIcon: Image.asset("images/profile_green.png"),
                label: Languages.of(context)!.profilelable)
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) async{
    if(index==1){
      await _profileController.callPayementPendingApi();
    }
    setState(() {
      widget._currentIndex = index;
    });
  }
}
