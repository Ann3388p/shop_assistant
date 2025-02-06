import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_pending_viewmodel.dart';

class DeliveryPendingScreen extends StatefulWidget {
  @override
  _DeliveryPendingScreenState createState() => _DeliveryPendingScreenState();
}

class _DeliveryPendingScreenState extends State<DeliveryPendingScreen> {
  @override
  void initState() {
    //fetchData();
    Future.delayed(Duration.zero).then((value) => Provider.of<DeliveryPendingViewModel>(context,listen: false).getDeliveryPendingOrders(
        Provider.of<UserDataViewModel>(context,listen: false).userID
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: (){
      //       Navigator.of(context).pop();
      //     },
      //     icon: Icon(Icons.arrow_back,color: Colors.black,),
      //   ),
      //   backgroundColor: Colors.white,
      //   title: Text("Order History",style: TextStyle(color: Colors.black),),
      //   centerTitle: true,
      // ),
      body: Consumer<DeliveryPendingViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.deliveryPendingResponse.haserror){
              return RetryWidget(
                  onTap:(){
                    value.getDeliveryPendingOrders(Provider.of<UserDataViewModel>(context,listen: false).userID);
                  });
            }
            if(value.deliveryPendingResponse.data.length == 0){

              return EmptyOrders();

            }
            return ListView.builder(
                itemCount: value.deliveryPendingList.length,
                itemBuilder:(context,index){
                  return OrderDetailsCard(
                    value.deliveryPendingList[index],
                    actionButtonText: 'View Order',);
                } );
          }
      ),
    );
  }
}
