import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/utils/constants.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_screen.dart';

// ignore: must_be_immutable
class OrderDetailsCard extends StatefulWidget {
  OrderListModel? data;
  String? actionButtonText;
  VoidCallback? onTapActionButton;
  // bool fromAssignedOrders;

  OrderDetailsCard(this.data,{this.actionButtonText,this.onTapActionButton});
  @override
  _OrderDetailsCardState createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  final _HEADINGSTYLE =  TextStyle(
      fontSize: 18,fontWeight: FontWeight.bold
  );
  final _INFOSTYLE = TextStyle(
    fontSize: 15, color: Colors.black54
  );
  final _INFOSTYLEIMP = TextStyle(
    fontSize: 15, color: Colors.red
  );
 TextStyle _assignTextStyle(String time){
   if(time.contains(RegExp(r'[0-9]')))
    return _INFOSTYLE;
   return _INFOSTYLEIMP;
 }
  Widget infoBlock(var heading, var info){
    return Flexible(
      child: Column(
        children: [

          FittedBox(child: Text('$heading',style: _HEADINGSTYLE,)),
          SizedBox(height: 10,),
          Text("$info",style:heading == "Time"?_assignTextStyle(info): _INFOSTYLE,textAlign: TextAlign.center,),

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
      child: InkWell(
        onTap: (){
         // print("last staus on assignes list is ${widget.data.lastStatus}");
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(widget.data!.id,false)));
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //color: Theme.of(context).primaryColor,
          elevation: 5,
          child: Column(
            children: [
              Container(
               // margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(flex:5,child: Text("Order ID : ${widget.data!.orderNumber}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        //Expanded(flex:1,child: Container()),
                        //Spacer(),
                        Flexible(
                          flex: 4,
                          child: FittedBox(child: Text('TOTAL PRICE :₹ ${widget.data!.totalPriceDelivery!=null?widget.data!.totalPriceDelivery.toStringAsFixed(2):0.0}',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,
                            color: Theme.of(context).primaryColor),)),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(thickness: 1,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Address',style: _HEADINGSTYLE,),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text('${widget.data!.deliveryAddress}',
                            style: _INFOSTYLE)
                    ),
                    SizedBox(height: 10,),
                  Align(
                    alignment:Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delivery Date",style: _HEADINGSTYLE,),
                        //SizedBox(height:5),
                        Text("${widget.data!.deliveryDate}",style: _INFOSTYLE,),
                      ],
                    ),
                  ),
                    SizedBox(height: 10,),
                    //  Divider(thickness: 1,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoBlock('No of items',widget.data!.products!.length),
                        infoBlock('Time',widget.data!.deliveryTime),
                        infoBlock('Del.Charge','₹ ${widget.data!.deliveryCharge}'),
                      ]
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                decoration: BoxDecoration(
                  gradient: ThemeGradient,
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10) ),
                  color: Theme.of(context).primaryColor
                ),
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('STATUS : ${widget.data!.lastStatus!.toUpperCase()}',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                        InkWell(
                          onTap: widget.onTapActionButton,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Text(widget.actionButtonText!,
                                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                                ),
                                Icon(CupertinoIcons.arrow_right_circle_fill,color: Theme.of(context).primaryColor,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
