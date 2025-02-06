import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/available_orders_viewmodel.dart';

class AvailableOrdersScreen extends StatefulWidget {
  @override
  _AvailableOrdersScreenState createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
    Provider.of<AvailableOrdersViewModel>(context,listen: false)
        .getAvailableOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.filter_alt_outlined),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Consumer<AvailableOrdersViewModel>(
        builder: (context,value, child) {
          if(value.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(value.availableOrdersResponse.haserror){
            return RetryWidget(
              onTap: () {
                value.getAvailableOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID);
              },
            );
          }
          if(value.availableOrdersResponse.data.length == 0){
            return Center(
                child:EmptyOrders()
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 6),
              itemCount: value.availableOrdersResponse.data.length,
              itemBuilder:(context,index){
                return OrderDetailsCard(
                    value.availableOrdersResponse.data[index],
                actionButtonText: "Accept order",
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
    );
  }
}
