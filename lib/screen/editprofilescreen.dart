import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/localization/language/languages.dart';
import 'package:driver_3_0_5/screen/homescreen.dart';
import 'package:driver_3_0_5/util/constants.dart';
import 'package:driver_3_0_5/util/preferenceutils.dart';
import 'package:driver_3_0_5/widget/app_lable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  final _formKey = new GlobalKey<FormState>();
  String? strCountryCode = '+61';

  String? _birthvalue = "1";

  // ProgressDialog pr ;

  String? firstname = "Driver";
  String? lastname = "Driver";
  String email = "driver@gmail.com";
  String? phone = "000 000 0000";
  String phonecode = "+0";
  String image = "";
  String location = "Set Location";

  File? _Proimage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();

    if (mounted) {
      setState(() {
        firstname = PreferenceUtils.getString(Constants.driverfirstname);
        lastname = PreferenceUtils.getString(Constants.driverlastname);
        email = PreferenceUtils.getString(Constants.driveremail);
        phone = PreferenceUtils.getString(Constants.driverphone);
        strCountryCode = PreferenceUtils.getString(Constants.driverphonecode);
        location = PreferenceUtils.getString(Constants.driverzone);
        image = PreferenceUtils.getString(Constants.driverimage);
      });
    }
  }

  callApiForUploadProfilePic(String proimageB64, BuildContext context) {
    print("profileimage:$proimageB64");

    setState(() {
      showSpinner = true;
    });
    RestClient(Api_Header().Dio_Data())
        .driverupdateimage(proimageB64)
        .then((response) {
      if (mounted) {
        print(response.toString());
        final body = json.decode(response!);

        bool? sucess = body['success'];
        print(sucess);

        if (sucess == true) {
          setState(() {
            showSpinner = false;
          });

          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Color(Constants.greentext));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(2)),
          );
        } else {
          setState(() {
            showSpinner = false;
          });
          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
        }
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  CallEditProfile(String? firstname, String? lastname, String email,
      String? strCountryCode, String? phone, BuildContext context) {
    setState(() {
      showSpinner = true;
    });
    RestClient(Api_Header().Dio_Data())
        .drivereditprofile(firstname, lastname, strCountryCode, email, phone)
        .then((response) {
      if (mounted) {
        print(response.toString());
        final body = json.decode(response!);
        bool? sucess = body['success'];
        print(sucess);

        if (sucess == true) {
          setState(() {
            showSpinner = false;
          });
          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Color(Constants.greentext));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(2)),
          );
        } else {
          setState(() {
            showSpinner = false;
          });
          var msg = body['data'];

          Constants.createSnackBar(msg, this.context, Color(Constants.redtext));
        }
      }
    }).catchError((Object obj) {
      final snackBar = SnackBar(
        content: Text(Languages.of(context)!.servererrorlable),
        backgroundColor: Color(Constants.redtext),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        showSpinner = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      //AppConstant.toastMessage("Internal Server Error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
   /* ScreenUtil.init(context,
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
                resizeToAvoidBottomInset: true,
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text(
                    Languages.of(context)!.editprofilelable,
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
                  child: LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return new Stack(
                      children: <Widget>[
                        new SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 60),
                            color: Colors.transparent,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                // physics: NeverScrollableScrollPhysics(),
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(8)),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 0, right: 5, bottom: 0, left: 5),
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
                                                    top: 0,
                                                    left: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _ChooseProfileImage();
                                                      },
                                                      child: Container(
                                                        child:  ClipOval(
                                            child: _Proimage != null
                                                ? Image.file(
                                              _Proimage!,
                                              width: ScreenUtil().setWidth(100),
                                              height: ScreenUtil().setHeight(100),
                                              fit: BoxFit.cover,
                                            )
                                                : CachedNetworkImage(
                                              width: ScreenUtil().setWidth(100),
                                              height: ScreenUtil().setHeight(100),
                                              imageUrl: image,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      margin: EdgeInsets.only(
                                                          top: 0,
                                                          left: 10,
                                                          right: 5,
                                                          bottom: 0),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (_Proimage ==
                                                              null) {
                                                            Constants.createSnackBar(
                                                                Languages.of(
                                                                        context)!
                                                                    .selectprofilepiclable,
                                                                this.context,
                                                                Color(Constants
                                                                    .redtext));
                                                          } else {
                                                            List<int>
                                                                liimageBytes =
                                                                _Proimage!
                                                                    .readAsBytesSync();
                                                            String proimageB64 =
                                                                base64Encode(liimageBytes);
                                                            Constants
                                                                    .CheckNetwork()
                                                                .whenComplete(() =>
                                                                    callApiForUploadProfilePic(
                                                                        proimageB64,
                                                                        context));
                                                          }
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            Languages.of(
                                                                    context)!
                                                                .changepiclable,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .greentext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      margin: EdgeInsets.only(
                                                          top: 0,
                                                          left: 10,
                                                          right: 5,
                                                          bottom: 0),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Visibility(
                                                        visible: false,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            Languages.of(
                                                                    context)!
                                                                .removepiclable,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    Constants
                                                                        .redtext),
                                                                fontFamily:
                                                                    Constants
                                                                        .app_font,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: AppLableWidget(
                                                  title: Languages.of(context)!
                                                      .firstnamelable,
                                                ),
                                              ),
                                              Card(
                                                color: Color(
                                                    Constants.light_black),
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
                                                        TextInputAction.next,
                                                    initialValue: firstname,
                                                    validator: Constants
                                                        .kvalidateFirstName,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onSaved: (name) =>
                                                        firstname = name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: Constants
                                                            .app_font_bold),
                                                    decoration: Constants
                                                        .kTextFieldInputDecoration
                                                        .copyWith(
                                                            hintText: Languages
                                                                    .of(context)!
                                                                .enterfirstnamelable),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: AppLableWidget(
                                                  title: Languages.of(context)!
                                                      .lastnamelable,
                                                ),
                                              ),
                                              Card(
                                                color: Color(
                                                    Constants.light_black),
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
                                                        TextInputAction.next,
                                                    initialValue: lastname,
                                                    onSaved: (name) =>
                                                        lastname = name,
                                                    validator: Constants
                                                        .kvalidatelastName,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: Constants
                                                            .app_font_bold),
                                                    decoration: Constants
                                                        .kTextFieldInputDecoration
                                                        .copyWith(
                                                            hintText: Languages
                                                                    .of(context)!
                                                                .enterlastnamelable),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: AppLableWidget(
                                                  title: Languages.of(context)!
                                                      .emaillabel,
                                                ),
                                              ),
                                              Card(
                                                color: Color(
                                                    Constants.light_black),
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
                                                        TextInputAction.next,
                                                    initialValue: email,
                                                    onSaved: (email) =>
                                                        email = email,
                                                    validator: Constants
                                                        .kvalidateEmail,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    // controller: _text_Email,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: Constants
                                                            .app_font_bold),
                                                    decoration: Constants
                                                        .kTextFieldInputDecoration
                                                        .copyWith(
                                                            hintText: Languages
                                                                    .of(context)!
                                                                .enteremaillabel),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: AppLableWidget(
                                                  title: Languages.of(context)!
                                                      .contactnolable,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Color(Constants
                                                          .light_black),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 5.0,
                                                      child: Container(
                                                        height: ScreenUtil()
                                                            .setHeight(50),
                                                        child:
                                                            CountryCodePicker(
                                                          onChanged: (c) {
                                                            setState(() {
                                                              strCountryCode =
                                                                  c.dialCode;
                                                            });
                                                          },
                                                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                          initialSelection:
                                                              'AU',
                                                          favorite: [
                                                            '+61',
                                                            'AU'
                                                          ],
                                                          hideMainText: true,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Card(
                                                      color: Color(Constants
                                                          .light_black),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 5.0,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: ScreenUtil()
                                                                .setWidth(15)),
                                                        child: IntrinsicHeight(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                strCountryCode!,
                                                                style:
                                                                    TextStyle(
                                                                        color:
                                                                            Color(
                                                                          Constants
                                                                              .whitetext,
                                                                        ),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            Constants.app_font),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.fromLTRB(
                                                                    0,
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            10),
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            10),
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            10)),
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      VerticalDivider(
                                                                    color: Colors
                                                                        .white,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            5),
                                                                    thickness:
                                                                        1.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 4,
                                                                child:
                                                                    TextFormField(
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  initialValue:
                                                                      phone,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                        Constants
                                                                            .whitetext,
                                                                      ),
                                                                      fontSize: 14,
                                                                      fontFamily: Constants.app_font),

                                                                  // controller: _text_contactNo,
                                                                  validator:
                                                                      Constants
                                                                          .kvalidateCotactNum,
                                                                  onSaved: (contact) =>
                                                                      phone =
                                                                          contact,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  onFieldSubmitted:
                                                                      (v) {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .nextFocus();
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      errorStyle: TextStyle(
                                                                          fontFamily: Constants
                                                                              .app_font_bold,
                                                                          color: Colors
                                                                              .red),
                                                                      hintText:
                                                                          '000 000 000',
                                                                      hintStyle: TextStyle(
                                                                          color: Color(Constants
                                                                              .color_hint)),
                                                                      border: InputBorder
                                                                          .none),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Visibility(
                                                visible: false,
                                                child: Container(
                                                  width: screenWidth,
                                                  height: ScreenUtil()
                                                      .setHeight(55),
                                                  child: Card(
                                                    color: Color(
                                                        Constants.light_black),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    elevation: 5.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 25.0,
                                                              right: 10),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: new DropdownButton<
                                                                String>(
                                                            hint: new Text(
                                                              "Select Delivery Zone",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .greaytext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .app_font,
                                                                  fontSize: 12),
                                                            ),
                                                            value: _birthvalue,
                                                            icon: SvgPicture.asset(
                                                                "images/drop_dwon.svg"),
                                                            isDense: true,
                                                            items: [
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "Rajkot",
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .greaytext),
                                                                      fontFamily:
                                                                          Constants
                                                                              .app_font,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                value: "1",
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "Rajkot",
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          Constants
                                                                              .greaytext),
                                                                      fontFamily:
                                                                          Constants
                                                                              .app_font,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                value: "2",
                                                              ),
                                                              DropdownMenuItem(
                                                                  child: Text(
                                                                    "Rajkot",
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: Color(Constants
                                                                            .greaytext),
                                                                        fontFamily:
                                                                            Constants
                                                                                .app_font,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  value: "3"),
                                                            ],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _birthvalue =
                                                                    value;
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                  ),
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
                        ),
                        new Container(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              child: GestureDetector(
                            onTap: () {
                              // Navigator.pop(context);

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                print(firstname);
                                print(lastname);
                                print(email);
                                print(strCountryCode);
                                print(phone);
                                Constants.CheckNetwork().whenComplete(() =>
                                    CallEditProfile(firstname, lastname, email,
                                        strCountryCode, phone, context));
                              }
                              },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.0),
                                  color: Color(Constants.greentext),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 0.0), //(x,y)
                                      blurRadius: 0.0,
                                    ),
                                  ],
                                ),
                                width: screenWidth,
                                height: screenHeight * 0.08,
                                child: Center(
                                  child: Container(
                                    color: Color(Constants.greentext),
                                    child: Text(
                                      Languages.of(context)!.changeinfolable,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: Constants.app_font),
                                    ),
                                  ),
                                )),
                          )),
                        ))
                      ],
                    );
                  }),
                ))),
      ),
    );
  }

  Future<bool> _onWillPop() async{
    return true;
  }

  void _ChooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      Languages.of(context)!.photoliblable,
                      style: TextStyle(fontFamily: Constants.app_font),
                    ),
                    onTap: () {
                      _ProimgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    Languages.of(context)!.cameralable,
                    style: TextStyle(fontFamily: Constants.app_font),
                  ),
                  onTap: () {
                    _ProimgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    print("Licence");
  }

  void _ProimgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _Proimage = File(pickedFile.path);
              
        List<int> imageBytes = _Proimage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        print("_Proimage:$_Proimage");
      } else {
        print('No image selected.');
      }
    });
  }

  void _ProimgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _Proimage = File(pickedFile.path);
        List<int> imageBytes = _Proimage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        print("_Proimage:$_Proimage");
      } else {
        print('No image selected.');
      }
    });
  }
}