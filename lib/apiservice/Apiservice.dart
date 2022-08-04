import 'package:dio/dio.dart' hide Headers;
import 'package:driver_3_0_5/model/deliveryzone.dart';
import 'package:driver_3_0_5/model/displaydriver.dart';
import 'package:driver_3_0_5/model/earninghistory.dart';
import 'package:driver_3_0_5/model/faq.dart';
import 'package:driver_3_0_5/model/notification.dart';
import 'package:driver_3_0_5/model/orderhistory.dart';
import 'package:driver_3_0_5/model/orderlistdata.dart';
import 'package:driver_3_0_5/model/orderwiseearning.dart';
import 'package:driver_3_0_5/model/register.dart';
import 'package:driver_3_0_5/model/setting.dart';
import 'package:retrofit/retrofit.dart';

part 'Apiservice.g.dart';

@RestApi(baseUrl: 'http://www.menucart.com.au/ozpos/public/api/driver/')
//please don't remove "/api/driver".
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  // @POST("/posts")
  // Future<List<loginmodel>> getTasks();

  @POST("driver_login")
  @FormUrlEncoded()
  Future<String?> driverlogin(@Field() String email_id, @Field() String password,
      @Field() String device_token);

  @POST("driver_register")
  @FormUrlEncoded()
  Future<register> driverregister(
    @Field() String first_name,
    @Field() String last_name,
    @Field() String email_id,
    @Field() String phone,
    @Field() String phone_code,
    @Field() String password,
    @Field() String address,
  );

  @POST("driver_check_otp")
  @FormUrlEncoded()
  Future<String?> drivercheckotp(
    @Field() String driver_id,
    @Field() String otp,
  );

  @POST("driver_resendOtp")
  @FormUrlEncoded()
  Future<String?> driverresendotp(
    @Field() String email_id,
  );

  @GET("driver_setting")
  Future<setting> driversetting();


  @POST("update_document")
  @FormUrlEncoded()
  Future<String?> driveruploaddocument(
    @Field() String? vehicle_type,
    @Field() String vehicle_number,
    @Field() String licence_number,
    @Field() String national_identity,
    @Field() String licence_doc,
  );

  @GET("delivery_zone")
  Future<deliveryzone> driverdelivery_zone();

  @POST("set_location")
  @FormUrlEncoded()
  Future<String?> driversetdeliveryzone(
    @Field() String delivery_zone_id,
  );

  @POST("update_driver")
  @FormUrlEncoded()
  Future<String?> driverupdatestatus(
    @Field() String is_online,
  );

  @GET("driver")
  Future<displaydriver> driverprofile();

  @POST("update_driver_image")
  @FormUrlEncoded()
  Future<String?> driverupdateimage(
    @Field() String image,
  );

  @POST("update_driver")
  @FormUrlEncoded()
  Future<String?> drivereditprofile(
    @Field() String? first_name,
    @Field() String? last_name,
    @Field() String? phone_code,
    @Field() String email_id,
    @Field() String? phone,
  );

  @POST("delivery_person_change_password")
  @FormUrlEncoded()
  Future<String?> driverchangepassword(
    @Field() String old_password,
    @Field() String password,
    @Field() String password_confirmation,
  );

  @GET("earning")
  Future<earninghistory> driverearninghistory();

  @GET("driver_order")
  Future<orderlistdata> driveorderlist();

  @GET("driver_order")
  Future<String?> driveorderlist1();

  @GET("order_history")
  Future<orderhistory> driverorderhistory();

  @GET("payment_pending")
  Future<Map> driverPaymentPending();

  //
  @GET("order_earning")
  Future<orderwiseearning> driverorderwiseearning();

  //
  //
  @GET("notification")
  Future<notification> drivernotification();

  //
  @GET("driver_faq")
  Future<faq> driverfaq();

  // @POST("status_change")
  // @FormUrlEncoded()
  // Future<orderstatus> orderstatuschange(
  //     @Field() String order_id,
  //     @Field() String order_status,
  //    );

  @POST("status_change")
  @FormUrlEncoded()
  Future<String?> orderstatuschange1(
    @Field() String? order_id,
    @Field() String order_status,
  );

  @POST("status_change")
  @FormUrlEncoded()
  Future<String?> cancelorder(
    @Field() String? order_id,
    @Field() String order_status,
    @Field() String? cancel_reason,
  );

  @POST("update_lat_lang")
  @FormUrlEncoded()
  Future<String?> driveupdatelatlong(
    @Field() String lat,
    @Field() String lang,
  );

  @POST("forgot_password_otp")
  @FormUrlEncoded()
  Future<String?> driverforgotpassotp(
    @Field() String email_id,
  );

  @POST("forgot_password_check_otp")
  @FormUrlEncoded()
  Future<String?> driverforgotcheckotp(
    @Field() String driver_id,
    @Field() String otp,
  );

  @POST("forgot_password")
  @FormUrlEncoded()
  Future<String?> driverforgotpassword(
    @Field() String password,
    @Field() String password_confirmation,
    @Field() String user_id,
  );
}
