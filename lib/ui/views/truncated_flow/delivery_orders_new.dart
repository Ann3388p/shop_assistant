import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_new_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/ready_orders_viewmodel.dart';
import 'package:shop_assistant/ui/views/truncated_flow/truncated_flow_order_details.dart';

import '../../viewmodel/truncated_flow_delivery_viewmodel.dart';
import 'order_details.dart';
import 'order_details_card_new.dart';

class DeliveryOrdersNewScreen extends StatefulWidget {
  @override
  _DeliveryOrdersNewScreenState createState() => _DeliveryOrdersNewScreenState();
}

class _DeliveryOrdersNewScreenState extends State<DeliveryOrdersNewScreen> {
  @override
  void initState() {
    //fetchData();
    Future.delayed(Duration.zero).then((value) => Provider.of<TruncatedFlowDeliveryViewModel>(context,listen: false).getDeliveryOrders(
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
      body: Consumer<TruncatedFlowDeliveryViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.deliveryOrdersResponse.haserror){
              return RetryWidget(
                  onTap:(){
                    value.getDeliveryOrders(Provider.of<UserDataViewModel>(context,listen: false).storeID);
                  });
            }
            if(value.deliveryOrdersResponse.data.length == 0){
              return EmptyOrders();
            }
            return ListView.builder(
                itemCount: value.deliveryOrdersResponse.data.length,
                itemBuilder:(context,index){

                  return OrderDetailsCardNew(value.deliveryOrdersResponse.data[index],
                      onTapDeliveryActionButton: ()
                  {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TruncatedFlowOrderDetails(value.deliveryOrderData[index].id,
                                value.deliveryOrderData[index].orderNumber,false,value.deliveryOrderData[index].lastStatus!,value.deliveryOrderData[index].products!.length))
                    );
                  }
                  );
                  /*return OrderDetailsCardNew(
                    value.deliveryOrdersResponse.data[index],
                     actionButtonText: "View Order",

                    // acceptActionButtonText: "View Order",
                    //  rejectActionButtonText: "jhshfv",

                     // acceptActionButtonText: "View Order",

                    //actionButtonText: 'View Orderr',);
                  );*/
                } );
          }
      ),
    );
  }
}
