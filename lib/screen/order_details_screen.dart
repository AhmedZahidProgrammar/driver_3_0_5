
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../model/cart_master.dart';
import '../util/constants.dart';


class OrderDetailsScreen extends StatefulWidget {
  final CartMaster cartMaster;
  const OrderDetailsScreen({Key? key, required this.cartMaster,})
      : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<Cart> cart;
  @override
  initState(){
    cart=widget.cartMaster.cart;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        body: Container(
          decoration: BoxDecoration(
            
              image: DecorationImage(
                image: AssetImage('images/background_image.png'),
                fit: BoxFit.cover,
              )),
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    20.0),
              ),
              margin: EdgeInsets.only(
                  top: 20,
                  right: 5,
                  left: 5,
                  bottom: 20),
              child: ListView.builder(
                  itemCount: cart.length,
                  shrinkWrap: true,
                  itemBuilder: (context,itemIndex){
                    String category=cart[itemIndex].category;
                    MenuCategory? menuCategory=cart[itemIndex].menuCategory;
                    List<Menu> menu=cart[itemIndex].menu;
                    if(category=='SINGLE'){
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: menu.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,menuIndex){
                           Menu menuItem= menu[menuIndex];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child:  Padding(
                                  padding: const EdgeInsets.only(top: 20.0,left: 15.0),
                                  child: Row(
                                    children: [
                                      Text(menu[menuIndex].name+
                                          (cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')+' x ${cart[itemIndex].quantity}  ',
                                          style: TextStyle(color: Color(Constants.color_theme),fontWeight: FontWeight.w900, fontSize: 16)),
                                      Container(
                                        height: 20,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Color(Constants.color_theme),
                                          borderRadius: BorderRadius.all(Radius.circular(4.0))
                                        ),
                                        child: Center(
                                          child: Text('SINGLE',
                                            style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),

                                  itemCount: menuItem.addons.length,
                                  padding: EdgeInsets.only(left: 25),
                                  itemBuilder: (context,addonIndex){
                                    Addon addonItem=menuItem.addons[addonIndex];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Text(addonItem.name+' '),
                                          Container(
                                            height: 20,
                                            padding: EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0))
                                            ),
                                            child: Center(
                                              child: Text('ADDONS',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
                                            ),
                                          )
                                        ],
                                      ),
                                    );

                              }),
                            )
                          ],
                        );
                      });
                    }
                    else if(category=='HALF_N_HALF'){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Flexible(
                        fit: FlexFit.loose,
                        child:Padding(
                          padding: const EdgeInsets.only(top: 20.0,left: 15.0),
                          child: Row(
                            children: [
                              Text(menuCategory!.name
                                  +(cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')
                                  +' x ${cart[itemIndex].quantity}  '
                                  ,style: TextStyle(color: Color(Constants.color_theme),fontWeight: FontWeight.w900, fontSize: 16)
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Color(Constants.color_theme),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                                ),
                                child: Center(
                                  child: Text(' HALF & HALF ',
                                      style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 25),
                                physics: NeverScrollableScrollPhysics(),
                              itemCount: menu.length,
                              itemBuilder: (context,menuIndex){
                              Menu menuItem= menu[menuIndex];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child:Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
                                          if(menuIndex==0)
                                          Container(
                                            height: 20,
                                            padding: EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                                color: Color(Constants.color_theme),
                                                borderRadius: BorderRadius.all(Radius.circular(4.0))
                                            ),
                                            child: Center(
                                              child: Text('First Half'.toUpperCase(),
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
                                            ),
                                          )
                                          else
                                            Container(
                                              height: 20,
                                              padding: EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                  color: Color(Constants.color_theme),
                                                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                                              ),

                                              child: Center(
                                                child: Text('Second Half'.toUpperCase(),
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(left: 16,top: 5.0,),
                                      itemCount:menuItem.addons.length,
                                      itemBuilder: (context,addonIndex) {
                                        Addon addonItem=menuItem.addons[addonIndex];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Row(children: [
                                            Text(addonItem.name+' '),
                                            Container(
                                              height: 20,
                                              padding: EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                                              ),
                                              child: Center(
                                                child: Text('ADDONS',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
                                              ),
                                            ),
                                          ],),
                                        );
                                      }
                                    ),
                                  )
                                ],
                              );

                            }),
                          ),
                        ],
                      );
                    }else if(category=='DEALS'){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0,left: 15.0),
                              child: Row(
                                children: [
                                  Text(menuCategory!.name
                                      +'  x ${cart[itemIndex].quantity} '
                                      ,style: TextStyle(color: Color(Constants.color_theme),fontWeight: FontWeight.w900, fontSize: 16)
                                  ),
                                  Container(
                                      height: 20,
                                       padding: EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          color: Color(Constants.color_theme),
                                          borderRadius: BorderRadius.all(Radius.circular(4.0))
                                      ),
                                      child: Center(child: Text('DEALS',style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500 , fontSize: 14))))
                                ],
                              ),
                            ),
                    ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 25,top: 5.0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: menu.length,
                                itemBuilder: (context,menuIndex){
                                  Menu menuItem= menu[menuIndex];
                                  DealsItems dealsItems=menu[menuIndex].dealsItems!;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child:Row(
                                          children: [
                                            Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
                                            Container(
                                                height: 20,
                                                padding: EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    color: Color(Constants.color_theme),
                                                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                                                ),
                                                child: Center(child: Text('${dealsItems.name} ',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),)))
                                          ],
                                        )
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.only(left: 24,top: 5.0,),
                                            itemCount:menuItem.addons.length,
                                            itemBuilder: (context,addonIndex) {
                                              Addon addonItem=menuItem.addons[addonIndex];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 5.0),
                                                child: Row(children: [
                                                  Text(addonItem.name+' '),
                                                  Container(
                                                    height: 20,
                                                    padding: EdgeInsets.all(3.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.all(Radius.circular(4.0))
                                                    ),
                                                    child: Center(
                                                      child: Text('ADDONS',
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
                                                    ),
                                                  )
                                                ],),
                                              );
                                            }
                                        ),
                                      )
                                    ],
                                  );

                                }),
                          ),
                        ],
                      );
                    }
                    return Container();
              }),
            ),
          ),
        ),
      ),
    );
  }








}
