import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/truncated_flow_shopping_list_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/available_orders_viewmodel.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_details_card.dart';
import 'package:shop_assistant/ui/views/truncated_flow/truncatedFlowtest.dart';
import 'package:shop_assistant/ui/views/truncated_flow/truncated_flow_order_details.dart';

import '../../home_screen.dart';
import '../../viewmodel/truncated_flow_shoppping_viewmodel.dart';
import '../order_details_screen/order_details_screen.dart';
import 'order_details.dart';
import 'order_details_card_new.dart';

class AvailableOrdersScreenNew extends StatefulWidget {
  @override
  _AvailableOrdersScreenStateNew createState() => _AvailableOrdersScreenStateNew();
}

class _AvailableOrdersScreenStateNew extends State<AvailableOrdersScreenNew> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false).getAvailableOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID));
            //.getAvailableOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID));
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    setState(() {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(isShowDialog: false)));
    });

    return true;
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.filter_alt_outlined),
        //   backgroundColor: Theme.of(context).primaryColor,
        // ),
        body: Consumer<TruncatedFlowShoppingViewModel>(
            builder: (context,value, child) {
              if(value.isLoading){
                return Center(child: CircularProgressIndicator());
              }
              if(value.availableOrdersResponse.haserror){
                return RetryWidget(
                  onTap: () {
                    //value.getAvailableOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID);
                  },
                );
              }
              if(value.availableOrdersResponse.data.length == 0)
              {
                return Center(
                    child:EmptyOrders()
                );
              }
              /* return Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24),
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                          margin: EdgeInsets.only(
                              right: 15, top: 4, bottom: 4),
                          child: ProductDetailsCard(
                            productImage: 'https://source.unsplash.com/user/c_v_r/100x100',
                            price: '50',
                            promoPrice: '40',
                            uom: 'No.s',
                            productName: 'test',
                            quantity: 1,
                            shopAssistantQuantity: 2,
                          ));
                    }),
              );*/


                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  itemCount: value.availableOrdersResponse.data.length,
                  itemBuilder:(context,index){
                    return OrderDetailsCardNew(
                      value.availableOrdersResponse.data[index],
                      acceptActionButtonText: "Accept order",

                        onTapAcceptActionButton: (){

                          value.changeToShopping(orderId: value.shoppingOrderData[index].id,
                              context: context);

                          /*value.acceptOrder(userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                            orderID:  value.shoppingOrderData[index].id,
                            context: context);*/
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TruncatedFlowOrderDetails(value.shoppingOrderData[index].id,value.shoppingOrderData[index].orderNumber,false,value.shoppingOrderData[index].lastStatus!,value.shoppingOrderData[index].products!.length)));
                        },
                      rejectActionButtonText: "Reject order",
                      onTapRejectActionButton: (){
                          Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false).rejectOrder(context, Provider.of<UserDataViewModel>(context,listen: false).userID,value.shoppingOrderData[index].id);
                      },

                        onTapActionButton:() async{
                          await Navigator.of(context).push(MaterialPageRoute(builder:(context)=> TruncatedFlowOrderDetails(
                              value.shoppingOrderData[index].id,
                              value.shoppingOrderData[index].orderNumber,
                              false,value.shoppingOrderData[index].lastStatus!,
                              value.shoppingOrderData[index].products!.length
                          )));
                        }

//                 onTapActionButton:()async{
//                   showDialog(context:context,
//                       builder: (context)=>AlertDialog(
//                         title: Text('Warning'),
//                         content: Text('Are you sure you want to accept this order ?'),
//                         actions: [
//                           FlatButton(
//                               onPressed: ()async{
//                                 //Navigator.of(context).pop();
// //                         await value.assignOrder(
// //                             userId: Provider.of<UserDataViewModel>(context,listen: false).userid,
// //                             orderId: value.availableOrders[index].orderId,
// //                             context: context);
// //                         if(!value.assignResponse.haserror){
// //                           print('it reached here');
// //                           value.getOrders(
// //                             userId: Provider.of<UserDataViewModel>(context,listen: false).userid,
// //                           );
// //                           Navigator.of(context).pop();
// // //                                            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>
// // //                                                CustomerHomeScreen()),(Route<dynamic> route)  => false);
// //                         }
//
//                               },
//                               child:Text('Yes')),
//                           FlatButton(
//                               onPressed: (){
//                                 Navigator.of(context).pop();
//                               },
//                               child:Text('No')),
//                         ],
//                       ));
//                 },
                    );
                  } );
            }
        ),
      ),
    );
  }
}
