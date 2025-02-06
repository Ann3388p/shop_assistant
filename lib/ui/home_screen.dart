import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/UserDataTruncatedFlow.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/local_notification_service.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/critical_order_dialog.dart';
import 'package:shop_assistant/ui/shared_widgets/dialogs.dart';
import 'package:shop_assistant/ui/shared_widgets/log_out_confirmation.dart';
import 'package:shop_assistant/ui/shared_widgets/show_toast.dart';
import 'package:shop_assistant/ui/views/delivery_orders/delivery_orders_screen.dart';
import 'package:shop_assistant/ui/views/my_account_screen/my_account_screen.dart';
import 'package:shop_assistant/ui/views/completed_orders_screen.dart';
import 'package:shop_assistant/ui/views/my_orders_screen.dart';
import 'package:shop_assistant/ui/views/truncated_flow/delivery_screen_new.dart';
import 'package:shop_assistant/ui/views/truncated_flow/shopping_screen_new.dart';

import 'package:shop_assistant/ui/views/order_details_screen/order_details_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/critical_order.dart';
import '../core/services/navigation_service.dart';
class HomeScreen extends StatefulWidget {
  bool ? isShowDialog;
  HomeScreen(
      {
        required this.isShowDialog,
        Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IO.Socket? socket;
  checkNotificationPermission()async{
    PermissionStatus permissionStatus = await
    NotificationPermissions.getNotificationPermissionStatus();
    print(permissionStatus);
    if(permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.unknown) {
      Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions(
          iosSettings:NotificationSettingsIos(
              sound: true, badge: true, alert: true));
    }

  }
  bool _shouldDisplayDialog = true;

  @override
  void initState()  {
    // print("after redirect==>${widget.isShowDialog}");
    Provider.of<UserDataViewModel>(context,listen: false).isShowDialog = true;
    Provider.of<UserDataViewModel>(context,listen: false).checkForAppUpdate();
    Provider.of<UserDataViewModel>(context,listen: false).updatetruncatevalue();
    // Provider.of<UserDataViewModel>(context,listen: false).getCriticalOrders
    //   (context,Provider.of<UserDataViewModel>(context,listen: false).storeID);



    connect();

    // TODO: implement initState
    super.initState();
  }

  // Socket Connection
  connect()
  {
    socket = IO.io("https://testserver.nearshopz.com", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    final userViewModel = Provider.of<UserDataViewModel>(context,listen: false);
    socket!.onConnect((data) {
      print("Connected");
      socket!.on("${userViewModel.storeID}_criticalOrder", (order) {
        print(order);
        // userViewModel.updateCriticalOrderFromLiveData(jsonDecode(jsonEncode(order)),context);

      });
    });
  }


  bool repeatDialog = false;

  Future<bool> _onWillPop() async {  return false;}
  @override
  Widget build(BuildContext context) {
    final userDataViewModel = Provider.of<UserDataViewModel>(context);
    /////////////////////////////////////////////////////////////////////////////
    // Future<void> showCustomDialogWithDelay(
    //     BuildContext context, List<CriticalOrder> criticalOrder,int delay, bool Visible) async {
    //   await Future.delayed(Duration(seconds: delay)); // delay for 2 seconds
    //     if(userDataViewModel.isShowDialog==true)
    //       {
    //         showDialog(
    //             context: context,
    //             builder: (BuildContext context) {
    //               // if(isDialogVisible)
    //               //   {
    //               //     if(userDataViewModel.isShowDialog==true)
    //               //       {
    //               return CriticalOrderDialog(
    //                 criticalOrder: userDataViewModel.criticalOrderList,
    //                 isVisible: Visible,
    //                 onSelected: (criticalOrder){
    //                   print(criticalOrder);
    //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //                   Visible = false;
    //                 },
    //               );
    //               // }
    //
    //               // return Container(
    //               //   color: Color(0x00ffffff),
    //               // );
    //
    //
    //             }
    //
    //
    //         );
    //       }
    //
    //
    //
    //
    // }
    //
    // if(userDataViewModel.criticalOrderList.isNotEmpty)
    //   {
    //      print("First Dialog");
    //     showCustomDialogWithDelay(context,userDataViewModel.criticalOrderList,0,true);
    //   }
    //
    // if(userDataViewModel.livecriticalOrderData != null) {
    //   if (userDataViewModel.livecriticalOrderData!.counter == 2) {
    //      Provider.of<UserDataViewModel>(context, listen: false)
    //                   .getCriticalOrders
    //                 (Provider
    //                   .of<UserDataViewModel>(context, listen: false)
    //                   .storeID);
    //      // hideDialog();
    //      showCustomDialogWithDelay(context,userDataViewModel.criticalOrderList,5,true);
    //   }
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    /////////recent dialog///////////////////////////////
    // print("isShow Dialog ==> ${userDataViewModel.isShowDialog}");
    // Future.delayed(Duration.zero, ()
    // {
    //   if(userDataViewModel.isShowDialog==true)
    //     {
    //       if (userDataViewModel.criticalOrderList.isNotEmpty) {
    //
    //         showDialog(
    //           barrierDismissible: false,
    //             barrierColor: Color(0x00ffffff),
    //             context: context,
    //             builder: (context) {
    //
    //               return Consumer<UserDataViewModel>(
    //                   builder: (context, provider, child) {
    //                     // if (provider.criticalLoading == true) {
    //                     //   return Center(child: CircularProgressIndicator());
    //                     // }
    //                     // if(provider.criticalOrderResponse.data != null)
    //                     //   {
    //                         return WillPopScope(
    //                           onWillPop: _onWillPop,
    //                           child: CriticalOrderDialog(
    //                               criticalOrder: userDataViewModel.criticalOrderList,
    //                               onSelected: (criticalOrder) async
    //                               {
    //                                 print(criticalOrder.orderid!.id);
    //                                 Navigator.push(context, MaterialPageRoute(
    //                                     builder: (context) =>
    //                                         OrderDetailsScreen(
    //                                             criticalOrder.orderid!.id)));
    //
    //                                 // repeatDialog = false;
    //                               }
    //
    //
    //                           ),
    //                         );
    //                       // }
    //                     // return WillPopScope(
    //                     //   onWillPop: _onWillPop,
    //                     //   child: CriticalOrderDialog(
    //                     //       criticalOrder: userDataViewModel.criticalOrderList,
    //                     //       onSelected: (criticalOrder) async
    //                     //       {
    //                     //         print(criticalOrder.orderid!.id);
    //                     //         Navigator.push(context, MaterialPageRoute(
    //                     //             builder: (context) =>
    //                     //                 OrderDetailsScreen(
    //                     //                     criticalOrder.orderid!.id)));
    //                     //
    //                     //         // repeatDialog = false;
    //                     //       }
    //                     //
    //                     //
    //                     //   ),
    //                     // );
    //
    //                   });
    //               // return CriticalOrderDialog(
    //               //   criticalOrder: userDataViewModel.criticalOrderList,
    //               //   onSelected: (criticalOrder) async
    //               //   {
    //               //     print(criticalOrder.orderid!.id);
    //               //     // if(userDataViewModel.isShowDialog)
    //               //     // {
    //               //     //   Navigator.of(context).pop();
    //               //     //   userDataViewModel.isShowDialog = false;
    //               //     //   Navigator.of(NavigationService.navigatorKey.currentContext!)..pop();
    //               //     //   await Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //               //     // }
    //               //     // // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(criticalOrder.orderid!.id)), (route) => false);
    //               //     await Navigator.push(context, MaterialPageRoute(
    //               //         builder: (context) =>
    //               //             OrderDetailsScreen(criticalOrder.orderid!.id)));
    //               //     // Navigator.of(context).pop();
    //               //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(criticalOrder.orderid!.id)), (route) => false);
    //               //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id))).then((value) =>  Navigator.of(context).pop());
    //               //     // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //               //
    //               //   },
    //               //
    //               // );
    //
    //               // return Consumer<UserDataViewModel>(
    //               //     builder: (context, provider, child) {
    //               //       // if (provider.criticalOrderList.isNotEmpty) {
    //               //       //   return CriticalOrderDialog(
    //               //       //       criticalOrder: userDataViewModel.criticalOrderList,
    //               //       //       onSelected: (criticalOrder) async
    //               //       //       {
    //               //       //         print(criticalOrder.orderid!.id);
    //               //       //         Navigator.push(context, MaterialPageRoute(
    //               //       //             builder: (context) =>
    //               //       //                 OrderDetailsScreen(
    //               //       //                     criticalOrder.orderid!.id)));
    //               //       //
    //               //       //         // repeatDialog = false;
    //               //       //       }
    //               //       //
    //               //       //
    //               //       //   );
    //               //       // }
    //               //       return CriticalOrderDialog(
    //               //           criticalOrder: userDataViewModel.criticalOrderList,
    //               //           onSelected: (criticalOrder) async
    //               //           {
    //               //             print(criticalOrder.orderid!.id);
    //               //             Navigator.push(context, MaterialPageRoute(
    //               //                 builder: (context) =>
    //               //                     OrderDetailsScreen(
    //               //                         criticalOrder.orderid!.id)));
    //               //
    //               //             // repeatDialog = false;
    //               //           }
    //               //
    //               //
    //               //       );
    //               //     });
    //
    //
    //             });
    //       }
    //
    //     }
    //
    // }
    //
    //     );
/////////////////////////recent dialog////////////////////////////////

    // Future.delayed(Duration.zero, ()
    // {
    //   if (userDataViewModel.isShowDialog == true) {
    //   if (userDataViewModel.livecriticalOrderData != null) {
    //     if (userDataViewModel.livecriticalOrderData!.counter == 2) {
    //       showDialog(
    //           barrierDismissible: false,
    //           barrierColor: Color(0x00ffffff),
    //           context: context,
    //           builder: (context) {
    //             // if (userDataViewModel.livecriticalOrderData != null) {
    //             //   if (userDataViewModel.livecriticalOrderData!.counter == 2) {
    //             // dismissDailog();
    //             print("The value is counter");
    //             // Provider.of<UserDataViewModel>(context, listen: false)
    //             //     .getCriticalOrders
    //             //   (Provider
    //             //     .of<UserDataViewModel>(context, listen: false)
    //             //     .storeID);
    //             // if(repeatDialog== true)
    //             //   {
    //             //     Consumer<UserDataViewModel>(
    //             //         builder: (context, provider, child) {
    //             // if(userDataViewModel.isShowDialog==true)
    //             //   {
    //             return Consumer<UserDataViewModel>(
    //                 builder: (context, provider, child) {
    //                   if (provider.criticalLoading == true) {
    //                     return Center(child: CircularProgressIndicator());
    //                   }
    //                   return WillPopScope(
    //                     onWillPop: _onWillPop,
    //                     child: CriticalOrderDialog(
    //                         criticalOrder: userDataViewModel.criticalOrderList,
    //                         onSelected: (criticalOrder) async
    //                         {
    //                           print(criticalOrder.orderid!.id);
    //                           Navigator.push(context, MaterialPageRoute(
    //                               builder: (context) =>
    //                                   OrderDetailsScreen(
    //                                       criticalOrder.orderid!.id)));
    //
    //                           // repeatDialog = false;
    //                         }
    //
    //
    //                     ),
    //                   );
    //                 });
    //
    //             // }
    //
    //             //     }
    //             // );
    //
    //
    //             // }
    //             //
    //             //   }
    //             // }
    //             // return Container();
    //           }
    //
    //       );
    //     }
    //
    //   }
    //
    //   }
    //
    // }
    //
    // );




    ////////////////////////////////////////////////////
    // Future.delayed(Duration(seconds: 5 ), ()   =>   showDialog(
    //   // barrierDismissible: false,
    //   //   barrierColor: Color(0x00ffffff),
    //     context: context,
    //     // routeSettings: false,
    //     builder:(context) {
    //       if(userDataViewModel.livecriticalOrderData != null) {
    //         if (userDataViewModel.livecriticalOrderData!.counter == 2) {
    //           print("The value is counter");
    //           Provider.of<UserDataViewModel>(context, listen: false)
    //               .getCriticalOrders
    //             (Provider
    //               .of<UserDataViewModel>(context, listen: false)
    //               .storeID);
    //           return CriticalOrderDialog(
    //             criticalOrder: userDataViewModel.criticalOrderList,
    //             onSelected:(criticalOrder) async
    //             {
    //               print(criticalOrder.orderid!.id);
    //               if(userDataViewModel.isShowDialog)
    //               {
    //                 // Navigator.of(context).pop();
    //                 userDataViewModel.isShowDialog = false;
    //                 Navigator.of(NavigationService.navigatorKey.currentContext!)..pop();
    //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id))).then((value) =>  Navigator.of(context).pop());
    //               }
    //               // Navigator.pop(context);
    //               // await Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id))).then((value) =>  Navigator.of(context).pop());
    //               // Navigator.of(context).pop();
    //               // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(criticalOrder.orderid!.id)), (route) => false);
    //               Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //               // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //
    //             },
    //             // onSelectedOrderDetails:(criticalOrder)
    //             //     {
    //             //       Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //             //       // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //             //
    //             //     },
    //
    //             //     onSelectedReject:(criticalOrder)
    //             // {
    //             //   Provider.of<UserDataViewModel>(context, listen: false).rejectOrder(context,Provider.of<UserDataViewModel>(context, listen: false).userID,criticalOrder);
    //             //
    //             // }
    //             // onPressedAccept: (){
    //             //   print("Accepted Order");
    //             // },
    //             // onPressedReject: (){
    //             //   print("Reject Order");
    //             // },
    //           );
    //         }
    //       }
    //
    //       return Container();
    //       // return Text("");
    //     }
    //
    //     )
    //
    // );
    //////////////////////////////////////////////







    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget  _optionsButton({required String imageUrl,String title = "My orders",VoidCallback? onTap}){
      return InkWell(
        onTap: onTap,
        child: Card(
          elevation: 8,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              children: [
                Image(
                  height: 110,
                  //image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxpyTCquBu-jEbhlllU_hJJQM0wgb0BnviHQ&usqp=CAU'),
                  image: AssetImage(imageUrl),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 5,),
                Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black54),),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      );
    }

    Widget _dashBoardHeader(){
      return Stack(
        children: [
          Container(
            width: width,
            height: height*.25,
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: width*.05),
            // color: Colors.blue,
            //  decoration: BoxDecoration(
            //    image: DecorationImage(
            //    image: NetworkImage("http://image/jpeg;base64,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")
            //    )
            //  ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      //width: 50,
                      height: 50,
                      // child: Image(
                      //   image: NetworkImage("https://koms.korloy.com/resource/lib/ace-admin/assets/avatars/profile-pic.jpg"),
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${userDataViewModel.firstName} ${userDataViewModel.lastName} ",
                        style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                      FittedBox(child: Text("Employee of ${userDataViewModel.storeName}",style: TextStyle(color: Colors.white,fontSize: 22 ),))
                    ],
                  ),
                )

              ],
            ),
          ),
          Positioned(
              top: 20,
              right: 20,
              child: TextButton.icon(
                icon: Icon(Icons.logout,color: Colors.white,), onPressed: () =>showDialog(context: context, builder: (dcontext)=>LogOutConfirm()),
                label: Text("Logout",style: TextStyle(color: Colors.white),),

              ) )
        ],
      );
    }
    // Future.delayed(Duration(seconds: 1), ()   =>  showDialog(
    //     barrierDismissible: false,
    //     barrierColor: Color(0x00ffffff),
    //     context: context,
    //     builder:(context) {
    //       if(Provider.of<UserDataViewModel>(context, listen: false).criticalOrderList.isNotEmpty)
    //       {
    //         return CriticalOrderDialog(
    //           criticalOrder: Provider.of<UserDataViewModel>(context, listen: false).criticalOrderList,
    //           onSelected:(criticalOrder) async
    //           {
    //             print(criticalOrder.orderid!.id);
    //
    //             await Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //             // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //
    //           },
    //           // onSelectedOrderDetails:(criticalOrder)
    //           // {
    //           //  print(criticalOrder.orderNumber);
    //           //  Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //           //  // if(criticalOrder.lastStatus=="Order-Placed")
    //           //  //   {
    //           //  //     Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context,data: criticalOrder);
    //           //  //   }
    //           //  //  if(criticalOrder.lastStatus=="Order-Accepted")
    //           //  //    {
    //           //  //      Provider.of<UserDataViewModel>(context, listen: false).startShopping(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context,data: criticalOrder);
    //           //  //    }
    //           //  // if(criticalOrder.lastStatus=="Shopping-In-Progress")
    //           //  // {
    //           //  //   Provider.of<UserDataViewModel>(context, listen: false).shoppinginProgress(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context,data: criticalOrder);
    //           //  // }
    //           //  //
    //           //  // if(criticalOrder.lastStatus=="Order-Ready")
    //           //  // {
    //           //  //   Provider.of<UserDataViewModel>(context, listen: false).orderComplete(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context,data: criticalOrder);
    //           //  // }
    //           //  // else{
    //           //  //   ShowToast(context, "Order status completed");
    //           //  // }
    //           //
    //           //
    //           // }
    //         );
    //       }
    //
    //       return Container();
    //       // return Text("");
    //     })
    //
    // );
    //
    // Future.delayed(Duration.zero, ()   => showDialog(
    //   // barrierDismissible: false,
    //     barrierDismissible: false,
    //     // barrierColor: Color(0x00ffffff),
    //     context: context,
    //     builder:(context) {
    //       // if(userDataViewModel.criticalOrderList.isNotEmpty)
    //       //   {
    //       //     return CriticalOrderDialog(
    //       //       criticalOrder: userDataViewModel.criticalOrderList,
    //       //
    //       //     );
    //       //   }
    //       // Provider.of<UserDataViewModel>(context, listen: false)
    //       //     .getCriticalOrders
    //       //   (Provider
    //       //     .of<UserDataViewModel>(context, listen: false)
    //       //     .storeID);
    //       if(userDataViewModel.livecriticalOrderData != null) {
    //         if (userDataViewModel.livecriticalOrderData!.counter == 2) {
    //           print("The value is counter");
    //           Provider.of<UserDataViewModel>(context, listen: false)
    //               .getCriticalOrders
    //             (Provider
    //               .of<UserDataViewModel>(context, listen: false)
    //               .storeID);
    //           return CriticalOrderDialog(
    //             criticalOrder: userDataViewModel.criticalOrderList,
    //             onSelected:(criticalOrder) async
    //             {
    //               print(criticalOrder.orderid!.id);
    //               await Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //               // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //
    //             },
    //             onSelectedOrderDetails:(criticalOrder) async
    //             {
    //               await Navigator.push(context, MaterialPageRoute(builder: (context)=>    OrderDetailsScreen(criticalOrder.orderid!.id)));
    //               // Provider.of<UserDataViewModel>(context, listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context, listen: false).userID, context: context, data: criticalOrder);
    //
    //             },
    //
    //             //     onSelectedReject:(criticalOrder)
    //             // {
    //             //   Provider.of<UserDataViewModel>(context, listen: false).rejectOrder(context,Provider.of<UserDataViewModel>(context, listen: false).userID,criticalOrder);
    //             //
    //             // }
    //             // onPressedAccept: (){
    //             //   print("Accepted Order");
    //             // },
    //             // onPressedReject: (){
    //             //   print("Reject Order");
    //             // },
    //           );
    //         }
    //       }
    //       // return CriticalOrderDialog(
    //       //   criticalOrder: userDataViewModel.criticalOrderList,
    //       //
    //       // );
    //       // }
    //       // for(int i=2;i<=userDataViewModel.liveCriticalList!.map((e) => e.counter).length;i++) {
    //       //   if (userDataViewModel.liveCriticalList[i].counter
    //       //        == 0) {
    //       //     Provider.of<UserDataViewModel>(context, listen: false)
    //       //         .getCriticalOrders
    //       //       (Provider
    //       //         .of<UserDataViewModel>(context, listen: false)
    //       //         .storeID);
    //       //     // if (Provider
    //       //     //     .of<UserDataViewModel>(context, listen: false)
    //       //     //     .isLoading == true) {
    //       //     //   return CircularProgressIndicator();
    //       //     // }
    //       //     return CriticalOrderDialog(
    //       //       criticalOrder: userDataViewModel.criticalOrderList,
    //       //
    //       //     );
    //       //   }
    //       // }
    //       // }
    //       //////
    //       return Container();
    //       // return Text("");
    //     }));
    return WillPopScope(
      onWillPop: () async {
          bool exitConfirmed = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Exit NearShopz"),
              content: Text("Are you sure you want to exit NearShopz?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Yes"),
                ),
              ],
            ),
          );

          if (exitConfirmed) {
            SystemNavigator.pop();
          }

          return false;
        },

      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          // floatingActionButton: FloatingActionButton(
          //   child: Text('Notification'),
          //   onPressed: ()async{
          //     String? token = await FirebaseMessaging.instance.getToken();
          //   print( token);
          //   //LocalNotificationService.createNotification(title: "title", body:"body");
          //     //print(Provider.of<UserDataViewModel>(context,listen: false).shoppingCountResponse.data.toString());
          //   },
          // ),
          body: Consumer<UserDataViewModel>(
              builder: (context, value, child) {


                print("Truncated Flow value${value.userTruncatedModel!.shopAsstTruncatedFlow}");
                // print("Truncated Flow value${value.userdatatruncateflow!.map((e) => e.shopAsstTruncatedFlow)}");
                // if(value.criticalLoading==true)
                //   {
                //     return Center(child: CircularProgressIndicator(),);
                //   }
                // if(value.Loading==true)
                // {
                //   return Center(child: CircularProgressIndicator(),);
                // }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dashBoardHeader(),
                    Container(
                      width: width,
                      height: height*.75 -24 - MediaQuery.of(context).padding.top,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                          color: Colors.grey[100]
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height:30),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                badge.Badge(
                                 // padding:value.shoppingCount.totalCountShopping==0? EdgeInsets.zero:EdgeInsets.all(8.0),
                                  badgeContent: value.shoppingCount.totalCountShopping==0? Container():Text(value.shoppingCount.totalCountShopping.toString(),style: TextStyle(color: Colors.white),),
                                  child: _optionsButton(
                                      imageUrl: 'assets/dashboard/my_orders.png',
                                      title: "Shopping",
                                      onTap:()
                                      {
                                        value.resetShoppingCount();
                                        if(value.userTruncatedModel!.shopAsstTruncatedFlow == true) {
                                          print("truncated flow");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyOrdersScreenNew()));
                                        }
                                        else{
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyOrdersScreen()));
                                        }
                                      }


                                  ),
                                ),

                                badge.Badge(
                                  //padding:value.shoppingCount.totalCountDelivery==0? EdgeInsets.zero:EdgeInsets.all(8.0),
                                  badgeContent: value.shoppingCount.totalCountDelivery==0 ? Container():Text(value.shoppingCount.totalCountDelivery.toString(),style: TextStyle(color: Colors.white),),
                                  child: _optionsButton(
                                      imageUrl: 'assets/dashboard/my_orders.png',
                                      title: "Delivery",
                                      onTap:(){
                                        value.resetDeliveryCount();
                                        if(value.userTruncatedModel!.shopAsstTruncatedFlow == true ){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DeliveryScreenNew()));
                                        }
                                        else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DeliveryOrderScreen()));
                                        }
                                      }
                                  ),
                                ),
                                _optionsButton(
                                    imageUrl: 'assets/dashboard/order_history.png',
                                    title: "Order History",onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CompletedOrderScreen()))),
                                // _optionsButton(
                                //     imageUrl: 'assets/dashboard/log_out.png',
                                //     title: "Log out", onTap: ()=>showDialog(context: context, builder: (dcontext)=>LogOutConfirm())),
                                _optionsButton(
                                    imageUrl: 'assets/dashboard/my_account.png',
                                    title: "My Account", onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAccountScreen())))

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

}


