import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/ready_orders_viewmodel.dart';

class ReadyOrderScreen extends StatefulWidget {
  @override
  _ReadyOrderScreenState createState() => _ReadyOrderScreenState();
}

class _ReadyOrderScreenState extends State<ReadyOrderScreen> {
  @override
  void initState() {
    //fetchData();
    Future.delayed(Duration.zero).then((value) => Provider.of<ReadyOrdersViewModel>(context,listen: false).getReadyOrders(
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
      body: Consumer<ReadyOrdersViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.readyOrderResponse.haserror){
              return RetryWidget(
                  onTap:(){
                    value.getReadyOrders(Provider.of<UserDataViewModel>(context,listen: false).userID);
                  });
            }
            return ListView.builder(
                itemCount: value.readyOrderList.length,
                itemBuilder:(context,index){
                  return OrderDetailsCard(
                    value.readyOrderList[index],
                    actionButtonText: 'View Order',);
                } );
          }
      ),
    );
  }
}
