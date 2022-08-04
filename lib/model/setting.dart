class setting {
  bool? success;
  Data? data;

  setting({this.success, this.data});

  setting.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? driverVehicalType;
  int? isDriverAcceptMultipleorder;
  String? driverAppId;
  String? driverAuthKey;
  String? driverApiKey;
  int? driverAcceptMultipleOrderCount;
  String? companyWhiteLogo;
  String? companyBlackLogo;
  int? driverAutoRefrese;
  String? cancelReason;
  String? globalDriver;
  String? whitelogo;
  String? blacklogo;
  int? driverNotification;

  Data(
      {this.driverVehicalType,
      this.isDriverAcceptMultipleorder,
      this.driverAppId,
      this.driverAuthKey,
      this.driverApiKey,
      this.driverAcceptMultipleOrderCount,
      this.companyWhiteLogo,
      this.companyBlackLogo,
      this.driverAutoRefrese,
      this.cancelReason,
      this.globalDriver,
      this.whitelogo,
      this.blacklogo,
      this.driverNotification});

  Data.fromJson(Map<String, dynamic> json) {
    driverVehicalType = json['driver_vehical_type'];
    isDriverAcceptMultipleorder = json['is_driver_accept_multipleorder'];
    driverAppId = json['driver_app_id'];
    driverAuthKey = json['driver_auth_key'];
    driverApiKey = json['driver_api_key'];
    driverAcceptMultipleOrderCount = json['driver_accept_multiple_order_count'];
    companyWhiteLogo = json['company_white_logo'];
    companyBlackLogo = json['company_black_logo'];
    driverAutoRefrese = json['driver_auto_refrese'];
    cancelReason = json['cancel_reason'];
    globalDriver = json['global_driver'];
    whitelogo = json['whitelogo'];
    blacklogo = json['blacklogo'];
    driverNotification=json['driver_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_vehical_type'] = this.driverVehicalType;
    data['is_driver_accept_multipleorder'] = this.isDriverAcceptMultipleorder;
    data['driver_app_id'] = this.driverAppId;
    data['driver_auth_key'] = this.driverAuthKey;
    data['driver_api_key'] = this.driverApiKey;
    data['driver_accept_multiple_order_count'] =
        this.driverAcceptMultipleOrderCount;
    data['company_white_logo'] = this.companyWhiteLogo;
    data['company_black_logo'] = this.companyBlackLogo;
    data['driver_auto_refrese'] = this.driverAutoRefrese;
    data['cancel_reason'] = this.cancelReason;
    data['global_driver'] = this.globalDriver;
    data['whitelogo'] = this.whitelogo;
    data['blacklogo'] = this.blacklogo;
    data['driver_notification']=this.driverNotification;
    return data;
  }
}
