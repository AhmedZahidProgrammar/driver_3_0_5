import 'package:dio/dio.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';

class Api_Header {
  Dio Dio_Data() {
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer" +
        "  " + PreferenceUtils.getString(Constants.headertoken); // config your dio headers globally
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    // dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;

    // print("tokwen123:${PreferenceUtils.getString(Constants.headertoken)}");

    return dio;
  }
}
