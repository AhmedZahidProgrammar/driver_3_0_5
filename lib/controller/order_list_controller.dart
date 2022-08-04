import 'package:get/get.dart';
import 'package:driver_3_0_5/apiservice/Api_Header.dart';
import 'package:driver_3_0_5/apiservice/Apiservice.dart';
import 'package:driver_3_0_5/model/orderlistdata.dart';

class OrderListController extends GetxController{
  RxList<OrderData> orderdatalist = <OrderData>[].obs;
  RxBool nojob = true.obs;
  RxBool showduty = false.obs;
  RxBool hideduty = false.obs;
  RxBool isOnline = false.obs;
  Future<void> CallApiForGetOrderList() async {

    RestClient(Api_Header().Dio_Data()).driveorderlist().then((response) {
      print("OrderList:$response");
      if (response.success = true) {
        if (response.data!.length != 0) {
          orderdatalist.clear();
          orderdatalist.addAll(response.data!);
          print("orderdatalistLength:${orderdatalist.length}");
          nojob.value = false;
          showduty.value = true;
          // return true;
        } else {
          print("orderdatalistLength000:${orderdatalist.length}");


          nojob.value = true;
          showduty.value = false;

          // return false;
          //show no new order
        }
      } else {

        nojob.value = true;
        showduty.value = false;

        // return false;
      }
    }).catchError((Object obj) {

      nojob.value = true;
      showduty.value = false;
      // return false;
      //AppConstant.toastMessage("Internal Server Error");
    });
  }
}