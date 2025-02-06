import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/empty_order.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/assigned_order_viewmodel.dart';


class AssignedOrdersScreen extends StatefulWidget {
  @override
  _AssignedOrdersScreenState createState() => _AssignedOrdersScreenState();
}

class _AssignedOrdersScreenState extends State<AssignedOrdersScreen> {
  fetchData()async{
    Provider.of<AssignedOrderViewModel>(context,listen: false).getAssignedOrders(
      Provider.of<UserDataViewModel>(context,listen: false).userID
    );
  }
  @override
  void initState() {
    //fetchData();
    Future.delayed(Duration.zero).then((value) => Provider.of<AssignedOrderViewModel>(context,listen: false).getAssignedOrders(
        Provider.of<UserDataViewModel>(context,listen: false).userID
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<AssignedOrderViewModel>(context,listen: false).clearData();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: (){
        //       Navigator.of(context).pop();
        //     },
        //     icon: Icon(Icons.arrow_back,color: Colors.black,),
        //   ),
        //   backgroundColor: Colors.white,
        //   title: Text("Assigned Orders",style: TextStyle(color: Colors.black),),
        //   centerTitle: true,
        // ),
        body: Consumer<AssignedOrderViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.assignedOrdersResponse.haserror){
              return RetryWidget(onTap:(){
                value.getAssignedOrders(Provider.of<UserDataViewModel>(context,listen: false).userID);
              });
            }
            /// FILTER OUT READY AND COMPLETED ORDERS IN THE PROVIDER
            if(value.assignedOrdersResponse.data.length == 0){
              return Center(child: EmptyOrders());
            }
            return ListView.builder(
                itemCount: value.assignedOrderList.length,
                itemBuilder:(context,index){
                  return OrderDetailsCard(
                      value.assignedOrderList[index],
                  actionButtonText: 'Start Shopping');
                } );
          }
        ),
      ),
    );
  }
}
