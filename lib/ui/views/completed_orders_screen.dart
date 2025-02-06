import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/order_details_card.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/viewmodel/completed_orders_viewmodel.dart';

import '../shared_widgets/empty_order.dart';

class CompletedOrderScreen extends StatefulWidget {
  @override
  _CompletedOrderScreenState createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen> {
  @override
  void initState() {
    //fetchData();
    // Future.delayed(Duration.zero).then((value) => Provider.of<CompletedOrdersViewModel>(context,listen: false).getCompletedOrders(
    //     Provider.of<UserDataViewModel>(context,listen: false).userID
    // ));
    fillData();
    super.initState();
  }
  fillData()async{
   await Provider.of<CompletedOrdersViewModel>(context,listen: false).getCompletedOrders(
        Provider.of<UserDataViewModel>(context,listen: false).userID
    );
   fillMoreData();
  }

  fillMoreData(){
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // print("first condition satisfied");
        // print("${!Provider.of<CompletedOrdersViewModel>(context,listen: false).showLoader}");
        if(!Provider.of<CompletedOrdersViewModel>(context,listen: false).showLoader)
          if( Provider.of<CompletedOrdersViewModel>(context,listen: false).completedOrderResponse.data.count >  Provider.of<CompletedOrdersViewModel>(context,listen: false).offset){
            print("condition is satisfied");
            Provider.of<CompletedOrdersViewModel>(context,listen: false).getMoreCompletedOrder(
                Provider.of<UserDataViewModel>(context,listen: false).userID);
          }
      }

    });
  }
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        title: Text("Order History",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Consumer<CompletedOrdersViewModel>(
          builder: (context, value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(value.completedOrderResponse.haserror){
              return RetryWidget(
                  onTap: (){
                    value.getCompletedOrders(Provider.of<UserDataViewModel>(context,listen: false).userID);
                  },);
            }
            if(value.completedOrderList!.length ==0){
              return EmptyOrders(text: "You have not yet completed any order",);
            }
            // if(value.completedOrderResponse.data.length == 0){
            //   return EmptyOrders();
            // }
            return ListView(
              controller: _scrollController,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount:value.completedOrderList!.length,
                    itemBuilder:(context,index){
                     // print("${value.completedOrderList}");
                      return OrderDetailsCard(
                        value.completedOrderList![index],
                        actionButtonText: 'View Order');
                    } ),
                Builder(
                    builder: (context) {
                      if(value.showLoader){
                        return Center(child: CircularProgressIndicator());
                      }
                      return Container();
                    }
                )
              ],
            );
          }
      ),
    );
  }
}
