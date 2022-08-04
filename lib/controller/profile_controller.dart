import 'package:get/get.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';

class ProfileController extends GetxController{
  RxString payementPending="0".obs;
  Future<void> callPayementPendingApi()async{
    Map map=await RestClient(Api_Header().Dio_Data()).driverPaymentPending();
    payementPending.value=map['data'].toString();

  }
}