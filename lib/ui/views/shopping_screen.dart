import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';
import 'package:shop_assistant/ui/views/done_screen.dart';
import 'package:shop_assistant/ui/views/review_screen.dart';
import 'package:shop_assistant/ui/views/todo_screen.dart';

import '../../core/models/user_data_viewmodel.dart';

class ShoppingScreen extends StatefulWidget {
  OrderDetailsModel? orderData;
  bool isShowDialog;
  ShoppingScreen(this.orderData,this.isShowDialog);
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  void initState() {
    Provider.of<ShoppingScreenViewModel>(context,listen: false).setOrderDetails(widget.orderData);
    Provider.of<ShoppingScreenViewModel>(context,listen: false).setProductData(widget.orderData!.products);
    Provider.of<UserDataViewModel>(context,listen: false).isShowDialog = false;
    print("isShow Dialog===>${widget.isShowDialog}");
    widget.isShowDialog = false;

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget _tabHeading({required String heading, required var quantity }){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(heading),
          SizedBox(width: 4,),
          Container(
            //color: Theme.of(context).primaryColor,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: Colors.red
              border: Border.all(width: 1,color: Theme.of(context).primaryColor)
            ),
            padding: EdgeInsets.all(6),
            child: Text("$quantity"),
          )
        ],
      );
    }
    return DefaultTabController(
      initialIndex: 0,
        length: 3,
        child: Consumer<ShoppingScreenViewModel>(
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text('#${widget.orderData!.orderNumber}'),
                centerTitle: true,
                bottom: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(fontSize: 18),
                  labelPadding: EdgeInsets.symmetric(vertical: 7),
                  tabs: [
                   _tabHeading(heading: "Shop", quantity:value.todo ),
                   _tabHeading(heading: "Review", quantity:value.review ),
                   _tabHeading(heading: "Done", quantity:value.done ),
                    // Text("Todos ${value.todo}"),
                  //  Text("Review ${value.review}"),
                 //   Text("Done ${value.done}"),
                  ],
                ),
              ),
              body: //Center(child: CircularProgressIndicator())
              TabBarView(
                children: [
                  TodoScreen(false), ReviewScreen(false), DoneScreen(false),
                ],
              ),
            );
          }
        )
    );
  }
}
