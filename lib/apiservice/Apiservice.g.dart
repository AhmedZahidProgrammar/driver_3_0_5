// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Apiservice.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://backend.ozfoodz.com.au/api/driver/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<String?> driverlogin(email_id, password, device_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'email_id': email_id,
      'password': password,
      'device_token': device_token
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'driver_login',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<register> driverregister(first_name, last_name, email_id, phone,
      phone_code, password, address) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'first_name': first_name,
      'last_name': last_name,
      'email_id': email_id,
      'phone': phone,
      'phone_code': phone_code,
      'password': password,
      'address': address
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<register>(Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            contentType: 'application/x-www-form-urlencoded')
            .compose(_dio.options, 'driver_register',
            queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = register.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> drivercheckotp(driver_id, otp) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'driver_id': driver_id, 'otp': otp};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'driver_check_otp',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverresendotp(email_id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'email_id': email_id};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'driver_resendOtp',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<setting> driversetting() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<setting>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'driver_setting',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = setting.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> driveruploaddocument(vehicle_type, vehicle_number,
      licence_number, national_identity, licence_doc) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'vehicle_type': vehicle_type,
      'vehicle_number': vehicle_number,
      'licence_number': licence_number,
      'national_identity': national_identity,
      'licence_doc': licence_doc
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'update_document',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<deliveryzone> driverdelivery_zone() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<deliveryzone>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'delivery_zone',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = deliveryzone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> driversetdeliveryzone(delivery_zone_id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'delivery_zone_id': delivery_zone_id};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'set_location',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverupdatestatus(is_online) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'is_online': is_online};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'update_driver',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<displaydriver> driverprofile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<displaydriver>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'driver',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = displaydriver.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> driverupdateimage(image) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'image': image};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'update_driver_image',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> drivereditprofile(
      first_name, last_name, phone_code, email_id, phone) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'first_name': first_name,
      'last_name': last_name,
      'phone_code': phone_code,
      'email_id': email_id,
      'phone': phone
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'update_driver',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverchangepassword(
      old_password, password, password_confirmation) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'old_password': old_password,
      'password': password,
      'password_confirmation': password_confirmation
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'delivery_person_change_password',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<earninghistory> driverearninghistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<earninghistory>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'earning',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = earninghistory.fromJson(_result.data!);
    return value;
  }

  @override
  Future<orderlistdata> driveorderlist() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<orderlistdata>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'driver_order',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = orderlistdata.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> driveorderlist1() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, 'driver_order',
            queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<orderhistory> driverorderhistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<orderhistory>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'order_history',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = orderhistory.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Map<String, dynamic>> driverPaymentPending() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Map<String, dynamic>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'payment_pending',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    Map<String, dynamic> value = Map.from(_result.data!);
    return value;
  }

  @override
  Future<orderwiseearning> driverorderwiseearning() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<orderwiseearning>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'order_earning',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = orderwiseearning.fromJson(_result.data!);
    return value;
  }

  @override
  Future<notification> drivernotification() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<notification>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'notification',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = notification.fromJson(_result.data!);
    return value;
  }

  @override
  Future<faq> driverfaq() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<faq>(
        Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, 'driver_faq',
            queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = faq.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> orderstatuschange1(order_id, order_status) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'order_id': order_id, 'order_status': order_status};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'status_change',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> cancelorder(order_id, order_status, cancel_reason) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'order_id': order_id,
      'order_status': order_status,
      'cancel_reason': cancel_reason
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'status_change',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driveupdatelatlong(lat, lang) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'lat': lat, 'lang': lang};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'update_lat_lang',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverforgotpassotp(email_id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'email_id': email_id};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'forgot_password_otp',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverforgotcheckotp(driver_id, otp) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'driver_id': driver_id, 'otp': otp};
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'forgot_password_check_otp',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<String?> driverforgotpassword(
      password, password_confirmation, user_id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'password': password,
      'password_confirmation': password_confirmation,
      'user_id': user_id
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded')
        .compose(_dio.options, 'forgot_password',
        queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
