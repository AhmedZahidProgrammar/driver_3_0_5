import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {

  static final String androidKey = 'AIzaSyCfl4ZvZl3ptxZDO_4D8J4F0T_yqzzIVes';
  static final String iosKey = 'AIzaSyCfl4ZvZl3ptxZDO_4D8J4F0T_yqzzIVes';

  static int color_black = 0xFF090E21;
  static int color_gray = 0xFF999999;
  static int color_like = 0xFFff6060;
  static int color_theme = 0xFFd12828;
  static int color_theme_op = 0xFF9BE6C2;
  static int color_backgroud = 0xFFFAFAFA;
  static int color_blue = 0xFF1492e6;
  static int color_screen_backgroud = 0xFFf2f2f2;
  static int color_hint = 0xFF999999;

  static int light_black = 0xFF213741;
  static int itembgcolor = 0xFF213741;
  static int bgcolor = 0xFF132229;
  static int greaytext = 0xFF999999;
  static int whitetext = 0xFFffffff;
  static int greentext = 0xFFd12828;
  static int dashline = 0xFFcccccc;
  static int redtext = 0xFFff6060;
  static final String driverfirstname = "driverfirstname";
  static final String driverlastname = "driverlastname";
  static final String driverid = "driverid";
  static final String headertoken = "headertoken";
  static final String driveremail = "driveremail";
  static final String driverphone = "driverphone";
  static final String driverotp = "driverotp";
  static final String driverphonecode = "driverphonecode";
  static final String driverimage = "driverimage";
  static final String imagePath = "imagePath";
  static final String isLoggedIn = "isLoggedIn";
  static final String isonline = "isonline";
  static final String isverified = "isverified";
  static final String drivervehicletype = "drivervehicletype";
  static final String drivervehiclenumber = "drivervehiclenumber";
  static final String driverlicencenumber = "driverlicencenumber";
  static final String drivernationalidentity = "drivernationalidentity";
  static final String driverlicencedoc = "driverlicencedoc";
  static final String driverdeliveryzoneid = "driverdeliveryzoneid";
  static final String drivernotification = "drivernotification";
  static final String driverzone = "driverzone";
  static final String driverdevicetoken = "driverdevicetoken";

  /*Setting data*/

  static final String driversetvehicaltype = "driversetvehicaltype";
  static final String is_driver_accept_multipleorder =
      "is_driver_accept_multipleorder";
  static final String driver_accept_multiple_order_count =
      "driver_accept_multiple_order_count";
  static final String driver_auto_refrese = "driver_auto_refrese";
  static final String cancel_reason = "cancel_reason";
  static final String one_signal_app_id = "one_signal_app_id";
  static final String languagecode = "languagecode";

  /*Lat Long*/

  static final String previos_order_status = "previos_order_status";
  static final String previos_order_orderid = "previos_order_orderid";
  static final String previos_order_id = "previos_order_id";
  static final String previos_order_vendor_name = "previos_order_vendor_name";
  static final String previos_order_vendor_address =
      "previos_order_vendor_address";
  static final String previos_order_distance = "previos_order_distance";
  static final String previos_order_vendor_lat = "previos_order_vendor_lat";
  static final String previos_order_vendor_lang = "previos_order_vendor_lang";
  static final String previos_order_vendor_image = "previos_order_vendor_image";
  static final String previos_order_user_lat = "previos_order_user_lat";
  static final String previos_order_user_lang = "previos_order_user_lang";
  static final String previos_order_user_address = "previos_order_user_address";
  static final String previos_order_user_name = "previos_order_user_name";

  /*Chekc driver is golobaldriver or not*/
  static final String isGlobalDriver = 'isGlobalDriver';
  static final String notGlobalDriverSlogan =
      'Sorry, Restaurant Driver can\'t access this feature';

  // static final String baseUrl =
  //     'baseUrl';

  /*Lat Long*/

  static double currentlat = 0;
  static double currentlong = 0;
  static String currentaddress = "0";

  static String app_font = 'Proxima';
  static String app_font_bold = 'ProximaBold';

  static Future<bool> CheckNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Constants.toastMessage("No Internet Connection");
      return false;
    }
  }

  static var kAppLableWidget = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.white,
      fontFamily: Constants.app_font_bold);

  static var kTextFieldInputDecoration = InputDecoration(
      hintStyle: TextStyle(color: Color(Constants.color_hint)),
      border: InputBorder.none,
      errorStyle:
      TextStyle(fontFamily: Constants.app_font_bold, color: Colors.red));

  static var kTextFieldInputDecoration1 = InputDecoration(
      hintStyle: TextStyle(color: Color(Constants.color_hint)),
      border: InputBorder.none,
      suffixIcon: Image.asset("images/search.png", width: 20, height: 20),
      errorStyle:
      TextStyle(fontFamily: Constants.app_font_bold, color: Colors.red));

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String? kvalidateFullName(String? value) {
    if (value!.length == 0) {
      return 'Data is Required';
    } else
      return null;
  }

  static String? kvalidateFirstName(String? value) {
    if (value!.length == 0) {
      return 'First Name is Required';
    } else
      return null;
  }

  static String? kvalidatelastName(String? value) {
    if (value!.length == 0) {
      return 'Last Name is Required';
    } else
      return null;
  }

  static String? kvalidateCotactNum(String? value) {
    if (value!.length == 0) {
      return 'Contact Number is Required';
    } else
      return null;
  }

  static String? kvalidatePassword(String? value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern as String);

    if (value!.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    } else if (!regex.hasMatch(value))
      return 'Password required';
    else
      return null;
  }

  static String? kvalidateConfPassword(String? value,
      TextEditingController _text_Password,
      TextEditingController _text_confPassword) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return "Password is Required";
    } else if (_text_Password.text != _text_confPassword.text)
      return 'Password and Confirm Password does not match.';
    else if (!regex.hasMatch(value))
      return 'Password required';
    else
      return null;
  }

  static String? kvalidateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (value!.length == 0) {
      return "Email is Required";
    } else if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static void createSnackBar(String message, BuildContext scaffoldContext,
      Color color) {
    final snackBar = new SnackBar(
        content: new Text(
          message,
          style: TextStyle(
              color: Color(whitetext), fontFamily: app_font, fontSize: 16),
        ),
        backgroundColor: color);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    //Scaffold.of(scaffoldContext).showSnackBar(snackBar);
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(snackBar);
  }
}
