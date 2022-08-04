import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/controller/firebase_controller.dart';
import 'package:driver_3_0_5/screen/homescreen.dart';
import 'package:driver_3_0_5/screen/login_screen.dart';
import 'package:driver_3_0_5/screen/orderlistscreen.dart';
import 'package:driver_3_0_5/screen/otp_screen.dart';
import 'package:driver_3_0_5/screen/selectlocationscreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print(message.data);
}
Future selectNotification(String? payload) async {
  print('payload');
  print(payload);
  //Handle notification tapped logic here
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '12345', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    if (GetPlatform.isAndroid ) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (_,value1,value2,value3){

      },
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        print(channel.id);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                '12345', // id
                'High Importance Notifications',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
                showWhen: false,
                styleInformation: BigTextStyleInformation(notification.body??''),
                // other properties...
              ),
            ));
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    Get.put(FirebaseController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // status bar color
    ));
    PreferenceUtils.init();

    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  MyApp(),
      routes: {
        '/order_list_screen':(context)=>OrderList(),
      },
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
        Locale('ar', ''),
        /* Locale('hi', ''),*/

      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
  //SdkContext.init(IsolateOrigin.main);
}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    PreferenceUtils.putBool(Constants.isGlobalDriver, false);
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,

        )
      ),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      title: 'Multi Language',
      locale: _locale,
      home: SplashScreen(),
      routes: {
        '/order_list_screen':(context)=>OrderList(),
      },
      supportedLocales: [Locale('en', ''), Locale('es', ''), Locale('ar', ''),],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    print("navigation");

    if (PreferenceUtils.getlogin(Constants.isLoggedIn) == true) {
      if (PreferenceUtils.getverify(Constants.isverified) == true) {
        if (PreferenceUtils.getString(Constants.driverdeliveryzoneid).toString() == "0") {
          print("doc true");
          // go to set location screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectLocation()),
          );
        } else {
          // go to home screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(0)),
          );
        }
      } else {
        //go to verify
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new OTPScreen()));
      }
    } else {
      // go to login

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();

    checkforpermission();

    if (mounted) {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          Constants.CheckNetwork().whenComplete(() => callApiForsetting());
        });
      });
    }
  }

  void checkforpermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("denied");
    } else if (permission == LocationPermission.whileInUse) {
      print("whileInUse56362");
    } else if (permission == LocationPermission.always) {
      print("always");
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    dynamic screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    ScreenUtil.init(
      context,
      designSize: Size(360, 690),);

    // ScreenUtil.init(context, designSize: Size(screenWidth, screenHeight), allowFontScaling: true);
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/order_list_screen':(context)=>OrderList(),
      },
      home: new SafeArea(
        child: Scaffold(
          body:Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/splash_image.png'),
                    fit: BoxFit.cover,
                  )),
              alignment: Alignment.center,
              child:SpinKitFadingCircle(
                color: Color(0xFFd12828),
              )
            // Align(
            //   alignment: Alignment.center,
            //   child: SvgPicture.asset(
            //     "images/main_logo.svg",
            //     width: ScreenUtil().setWidth(40),
            //     height: ScreenUtil().setHeight(40),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  void callApiForsetting() {
    RestClient(Api_Header().Dio_Data()).driversetting().then((response) {
      if (response.success == true) {
        print("Setting true");

        PreferenceUtils.setString(
            Constants.driversetvehicaltype, response.data!.driverVehicalType!);
        PreferenceUtils.setString(Constants.is_driver_accept_multipleorder,
            response.data!.isDriverAcceptMultipleorder.toString());
        PreferenceUtils.setString(Constants.driver_accept_multiple_order_count,
            response.data!.driverAcceptMultipleOrderCount.toString());
        PreferenceUtils.setString(
            Constants.driver_auto_refrese, response.data!.driverAutoRefrese.toString());
        PreferenceUtils.setString(
            Constants.one_signal_app_id, response.data!.driverAppId.toString());
        PreferenceUtils.setString(Constants.cancel_reason, response.data!.cancelReason!);
        print(PreferenceUtils.getString(Constants.is_driver_accept_multipleorder));
        print(PreferenceUtils.getString(Constants.driversetvehicaltype));
        print("Vehicletype:${response.data!.driverVehicalType}");

        if (PreferenceUtils
            .getString(Constants.one_signal_app_id)
            .isNotEmpty) {

        }

        startTime();
      } else {
        startTime();
      }
    }).catchError((obj) {
      print("error:$obj.");
      print(obj.runtimeType);

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          print(res);
          var responsecode = res.statusCode;
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
