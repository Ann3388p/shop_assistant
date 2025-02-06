import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/views/assigned_orders_screen.dart';
import 'package:shop_assistant/ui/views/available_orders_screen.dart';
import 'package:shop_assistant/ui/views/delivery_orders/delivery_new_screen/delivery_new_screen.dart';
import 'package:shop_assistant/ui/views/delivery_orders/delivery_pending_screen/delivery_pending_screen.dart';
import 'package:shop_assistant/ui/views/ready_orders_screen.dart';

class DeliveryOrderScreen extends StatefulWidget {
  @override
  _DeliveryOrderScreenState createState() => _DeliveryOrderScreenState();
}

class _DeliveryOrderScreenState extends State<DeliveryOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child:Scaffold(
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
            bottom: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(fontSize: 17),
              labelPadding: EdgeInsets.symmetric(vertical: 7),
              tabs: [
                Text("New "),
                Text("Del. Pending"),
              ],
            ),
          ),
          body: //Center(child: CircularProgressIndicator())
          TabBarView(
            children: [
              DeliveryNewScreen(),
              DeliveryPendingScreen()
            ],
          ),
        )
    );


  }
}
