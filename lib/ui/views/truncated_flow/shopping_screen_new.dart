import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/home_screen.dart';
import 'package:shop_assistant/ui/views/assigned_orders_screen.dart';
import 'package:shop_assistant/ui/views/available_orders_screen.dart';
import 'package:shop_assistant/ui/views/ready_orders_screen.dart';

import 'AvailableOrderScreenNew.dart';

class MyOrdersScreenNew extends StatefulWidget {
  @override
  _MyOrdersScreenNew createState() => _MyOrdersScreenNew();
}

class _MyOrdersScreenNew extends State<MyOrdersScreenNew> {

  @override

  Future<bool> _onBackPressed() async {
    setState(() {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(isShowDialog: false)));
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                print("back button pressed");
                _onBackPressed();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen(isShowDialog: false)));
              },
            );
          }
        ),
        backgroundColor: Colors.white,
        title: Text('Shopping'),
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
      body: AvailableOrdersScreenNew(),
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
