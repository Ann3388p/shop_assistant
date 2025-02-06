import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/utils/utilities.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_get_direction_butoon.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_product_item.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_share_location_button.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: must_be_immutable
class OrderDetailsScreen extends StatefulWidget {
 // bool startShopping;
  var orderID;
  bool isShowDialog;
  OrderDetailsScreen(this.orderID,this.isShowDialog
  );
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  fetchData(){
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<OrderDetailsViewModel>(context,listen: false)
            .getOrderDetails(context,widget.orderID));
  }

  @override
  void initState() {
    Provider.of<OrderDetailsViewModel>(context,listen: false).orderID = widget.orderID;
    print("isShow Dialog===>${widget.isShowDialog}");
    widget.isShowDialog = false;
    fetchData();
    super.initState();
  }

  final _SECTIONPADDING = EdgeInsets.symmetric(horizontal: 15);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,//Colors.grey[100],
    appBar: AppBar(
      title: Text("View Order"),
      elevation: 0,
      centerTitle: true,
    ),
     body: Consumer<OrderDetailsViewModel>(
       builder: (context,value, child) {
         if(value.isLoading){
           return Center(child: CircularProgressIndicator());
         }
         if(value.orderDetailsResponse.haserror){
           return RetryWidget(onTap:fetchData);
         }
         OrderDetailsModel _orderData = value.orderDetailsResponse.data;
         return Container(
           height:height,
           child: Stack(
             children: [
               SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Divider(thickness: 8,),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,10,0,0),
                       child: Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                             "Order ID :",
                             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,0,10),
                       child: Text(
                         "${_orderData.orderNumber}"
                       //'${data.deliveryAddress}'
                       ),
                     ),
                     Divider(thickness: 8,),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,10,0,0),
                       child: Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                             "Order created time :",
                             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,0,10),
                       child: Text(
                           "${_orderData.stats![0].created}  ${Utilities.convertTimeToString(_orderData.stats![0].createdTime!)}"
                         //'${data.deliveryAddress}'
                       ),
                     ),
                     Builder(
                       builder: (context) {
                         if(_orderData.specialInstructions != null && _orderData.specialInstructions!.isNotEmpty)
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Divider(thickness: 8),
                             Padding(
                               padding: const EdgeInsets.fromLTRB(15,10,0,0),
                               child: Align(
                                 alignment: Alignment.centerLeft,
                                 child: Text(
                                     "Special Instruction :",
                                     textAlign: TextAlign.left,
                                     style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.fromLTRB(15,8,0,10),
                               child: Text(
                                   "${_orderData.specialInstructions}"
                                 //'${data.deliveryAddress}'
                               ),
                             ),
                           ],
                         );
                         return Container();
                       }
                     ),
                     Divider(thickness: 8,),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,10,0,0),
                       child: Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                             "Customer Details :",
                             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,0,10),
                       child: Row(
                         children: [
                           Text(
                             "Name : ${_orderData.customerName}\nMobile Number : ${_orderData.mobileNumber}"
                           //'${data.deliveryAddress}'
                           ),
                           Spacer(),
                           IconButton(onPressed: () async {
                             await launch('tel:+91${_orderData.mobileNumber}');
                           }, icon: Icon(Icons.phone_outlined))
                         ],
                       ),
                     ),
                     Divider(thickness: 8,),
                     InkWell(
                       onTap: (){
                        // Utils.openMap(_orderData., longitude)
                       },
                       child: Padding(
                         padding: const EdgeInsets.fromLTRB(15,10,0,0),
                         child: Align(
                           alignment: Alignment.centerLeft,
                           child: Text(
                               "Delivery Address :",
                               style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                         ),
                       ),
                     ),
                     Row(
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.fromLTRB(15,8,0,10),
                             child: Text(
                               "${_orderData.deliveryAddress}"
                             //'${data.deliveryAddress}'
                             ),
                           ),
                         ),
                         //Spacer(),
                         OrderDetailsGetDirectionButton(
                             status: _orderData.lastStatus!,
                             lat: _orderData.deliveryLat,
                             lng: _orderData.deliveryLng
                         )
                         // TextButton.icon(
                         //     onPressed: () async {
                         //       final Uri uri= Uri.parse('google.navigation:q=8.56775,76.873516');
                         //       await launchUrl(uri);
                         //     },
                         //     icon: Icon(Icons.directions),
                         // label: Text("Directions"),)
                       ],
                     ),
                     OrderDetailsShareLocationButton(orderData: _orderData),
                     Divider(thickness: 8,),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,10,0,0),
                       child: Text(
                           "Bill details :",
                           style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,15,0),
                       child: Row(
                         children: [
                           Text('Total product price'),
                           Spacer(),
                           Text(
                             "₹ ${_orderData.totalPrice.toStringAsFixed(2)}"
                             //  '₹ ${data.totalPrice.toStringAsFixed(2)}'
                           ),
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,15,0),
                       child: Row(
                         children: [
                           Text('Delivery charge'),
                           Spacer(),
                           Text(
                               _orderData.deliveryCharge !=null ? "₹ ${_orderData.deliveryCharge.toStringAsFixed(2)}":""
                             //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                           ),
                         ],
                       ),
                     ),

                     Builder(
                       builder: (context) {
                         if(_orderData.discountPrice>0)
                         return Padding(
                           padding: const EdgeInsets.fromLTRB(15,8,15,0),
                           child: Row(
                             children: [
                               Text('Coupon discount'),
                               Spacer(),
                               Text("-₹ ${_orderData.discountPrice}"
                                 //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                               ),
                             ],
                           ),
                         );
                         return Container();
                       }
                     ),

                     Builder(
                         builder: (context) {
                           print("${_orderData.finalBillAmount}");
                           if(_orderData.finalBillAmount>0)
                             {
                               return Padding(
                                 padding: const EdgeInsets.fromLTRB(15,8,15,0),
                                 child: Row(
                                   children: [
                                     Text('Billed Amount',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                                     Spacer(),
                                     Text(
                                       "₹ ${_orderData.finalBillAmount!=0?_orderData.finalBillAmount.toStringAsFixed(2):0.0}",
                                       //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                       style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
                                   ],
                                 ),
                               );
                             }

                           return Container();
                         }
                     ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,8,15,0),
                       child: Row(
                         children: [
                           Text('Total',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                           Spacer(),
                           Text(
                             "₹ ${_orderData.totalPriceDelivery!=null?_orderData.totalPriceDelivery.toStringAsFixed(2):0.0}",
                             //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                             style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
                         ],
                       ),
                     ),

                     Divider(thickness: 8,),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(15,15,0,10),
                       child: Text("Product Items",
                       style: TextStyle(
                         fontWeight:FontWeight.bold,
                         fontSize: 16,
                       ),),
                     ),
                     ListView.builder(
                       shrinkWrap: true,
                         padding: EdgeInsets.only(bottom: 50),
                         physics: ScrollPhysics(),
                         itemCount: _orderData.products!.length,
                         itemBuilder: (context, index){
                         print("${_orderData.products![index].productid!.image}");
                           return OrderDetailsProductItem(_orderData.products![index]);
                         })
                   ],
                 ),
               ),
               Positioned(
                 left: 10,
                 right: 10,
                 bottom: 5,
                   child:Builder(
                     builder: (context) {
                       if(value.buttonIsLoading){
                         return Center(child: CircularProgressIndicator());
                       }
                       return value.showButtonAccordingToView(
                           context: context,
                           userID: Provider.of<UserDataViewModel>(context,listen: false).userID);
                     }
                   )
               )
             ],
           ),
         );
       }
     ),
    );
  }
}
