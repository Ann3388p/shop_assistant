import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_new_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/ready_orders_viewmodel.dart';

class DeliveryNewScreen extends StatefulWidget {
  @override
  _DeliveryNewScreenState createState() => _DeliveryNewScreenState();
}

class _DeliveryNewScreenState extends State<DeliveryNewScreen> {
  @override
  void initState() {
    //fetchData();
    Future.delayed(Duration.zero).then((value) => Provider.of<DeliveryNewOrdersViewModel>(context,listen: false).getDeliveryNewOrders(
        Provider.of<UserDataViewModel>(context,listen: false).storeID
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
      body: Consumer<DeliveryNewOrdersViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.deliveryNewOrderResponse.haserror){
              return RetryWidget(
                  onTap:(){
                    value.getDeliveryNewOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID);
                  });
            }
            if(value.deliveryNewOrderResponse.data.length == 0){
              return EmptyOrders();
            }
            return ListView.builder(
                itemCount: value.deliveryNewOrderList.length,
                itemBuilder:(context,index){
                  return OrderDetailsCard(
                    value.deliveryNewOrderList[index],
                    actionButtonText: 'View Order',);
                } );
          }
      ),
    );
  }
}
