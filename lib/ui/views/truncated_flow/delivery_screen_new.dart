import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/ui/views/assigned_orders_screen.dart';
import 'package:shop_assistant/ui/views/available_orders_screen.dart';
import 'package:shop_assistant/ui/views/ready_orders_screen.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_count.dart';

import 'AvailableOrderScreenNew.dart';
import 'delivery_orders_new.dart';

class DeliveryScreenNew extends StatefulWidget {
  @override
  _DeliveryScreenNew createState() => _DeliveryScreenNew();
}

class _DeliveryScreenNew extends State<DeliveryScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            print("back button pressed");
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text('Delivery Orders'),
        centerTitle: true,
        /*bottom: TabBar(
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black,
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(fontSize: 17),
          labelPadding: EdgeInsets.symmetric(vertical: 7),
          tabs: [
            Text("New"),
            Text("Ongoing"),
            //   Text("Del. Pending"),
          ],
        ),*/
      ),
      body: DeliveryOrdersNewScreen(),


      //Center(child: CircularProgressIndicator())
      /*TabBarView(
        children: [
          AvailableOrdersScreen(),
         // AssignedOrdersScreen(),
          //   ReadyOrderScreen(),
        ],
      ),*/
    );


  }
}
