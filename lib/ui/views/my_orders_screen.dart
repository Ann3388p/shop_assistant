import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/views/assigned_orders_screen.dart';
import 'package:shop_assistant/ui/views/available_orders_screen.dart';
import 'package:shop_assistant/ui/views/ready_orders_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
                  title: Text('Shopping'),
                  centerTitle: true,
                  bottom: TabBar(
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
                  ),
                ),
                body: //Center(child: CircularProgressIndicator())
                TabBarView(
                  children: [
                    AvailableOrdersScreen(),
                    AssignedOrdersScreen(),
                 //   ReadyOrderScreen(),
                  ],
                ),
              )
    );


  }
}
