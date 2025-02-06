import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/truncated_flow_shopping_list_model.dart';
import 'package:shop_assistant/core/utils/constants.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_shoppping_viewmodel.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_screen.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_details_card.dart';

import '../../../core/models/truncated_flow_delivery_model.dart';
import '../../../core/models/user_data_viewmodel.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import 'input_field.dart';
import 'order_details.dart';

// ignore: must_be_immutable
class OrderDetailsCardNew extends StatefulWidget {
  TruncatedFlowOrderDetailsModel? data;

  String? acceptActionButtonText;
  String? rejectActionButtonText;
  String? actionButtonText;
  VoidCallback? onTapAcceptActionButton;
  VoidCallback? onTapRejectActionButton;

  VoidCallback? onTapActionButton;

  VoidCallback? onTapDeliveryActionButton;
  // bool fromAssignedOrders;

  OrderDetailsCardNew(this.data,{this.acceptActionButtonText,
    this.rejectActionButtonText,
    this.onTapAcceptActionButton,
    this.onTapRejectActionButton,
    this.onTapActionButton,
    this.actionButtonText,
  this.onTapDeliveryActionButton});
  @override
  _OrderDetailsCardStateNew createState() => _OrderDetailsCardStateNew();
}

class _OrderDetailsCardStateNew extends State<OrderDetailsCardNew> {
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
      /*child: InkWell(
        onTap: (){
          // print("last staus on assignes list is ${widget.data.lastStatus}");
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(widget.data!.id)));
        },*/
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
                        Expanded(flex:5,child: Text("Order ID : ${widget.data!.orderNumber}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                        //Expanded(flex:1,child: Container()),
                        //Spacer(),
                        Flexible(
                          flex: 4,
                          child: FittedBox(child: Text('TOTAL PRICE :₹ ${widget.data!.totalPrice!=null?widget.data!.totalPrice!.toStringAsFixed(2):0.0}',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,
                                color: Theme.of(context).primaryColor),)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Divider(thickness: 1,),
                    SizedBox(height: 10,),
                    Row(
                      children: [

                        Text('Address',style: _HEADINGSTYLE,),
                        SizedBox(width:100,),
                        Text("Delivery Date",style: _HEADINGSTYLE,),
                      ],
                    ),
                    Row(
                      children: [
                      Container(
                      width: 162, // set the maximum width of the text
                      child: Text(
                        "${widget.data!.deliveryAddress}",style: _INFOSTYLE,
                        textAlign: TextAlign.left, // justify the text
                        overflow: TextOverflow.visible,
                        maxLines: 3,// display the entire text even if it overflows
                      ),
                    ),
                       /* Text("${widget.data!.deliveryAddress}",
                            style: _INFOSTYLE,
                        maxLines: 2,),*/
                        //SizedBox(width: 30,),
                        Text("${widget.data!.deliveryDate}\n ${widget.data!.deliveryTime}",style: _INFOSTYLE,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    /*Align(
                      alignment:Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Delivery Date",style: _HEADINGSTYLE,),
                          //SizedBox(height:5),
                          Text("${widget.data!.deliveryDate}",style: _INFOSTYLE,),
                        ],
                      ),
                    ),*/
                    Divider(thickness: 1,),

                    Row(
                      children: [
                        Text('No of items: ${widget.data!.products!.length}',
                        style: _HEADINGSTYLE,)
                      ],
                    )
                    //  Divider(thickness: 1,),
                   /* Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          infoBlock('No of items',widget.data!.products!.length),
                          *//*infoBlock('Time',widget.data!.deliveryTime),
                          infoBlock('Del.Charge','₹ ${widget.data!.deliveryCharge}'),*//*
                        ]
                    ),*/
                  ],
                ),
              ),

        Container(
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24),
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.data!.products!.length,
              itemBuilder: (BuildContext context, int i) {
                print("Quantity & Uom ===. ${widget.data!.products![i].productid!.uom.toString()}  ${widget.data!.products![i].productid!.quantity}");
                return Container(
                    margin: EdgeInsets.only(
                        right: 15, top: 4, bottom: 4),
                    child: ProductDetailsCard(

                     // productImage: 'https://source.unsplash.com/user/c_v_r/100x100',
                      productImage: widget.data!.products![i].productid!.image!.primary,

                      price: widget.data!.products![i].productid!.price!,
                      promoPrice: widget.data!.products![i].productid!.promoprice,
                      uom: widget.data!.products![i].productid!.uom.toString(),
                      productName: widget.data!.products![i].productid!.productname,
                      quantity: int.parse(widget.data!.products![i].quantity!.toString()),
                      shopAssistantQuantity:widget.data!.products![i].shopAssistantQuantity,
                      perQuantity: int.parse(widget.data!.products![i].productid!.quantity.toString()),




                    ));
              }),
        ),




              Builder(builder: (context){
                if(widget.data!.lastStatus == "Order-Placed" ){
                  return Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: CommonPrimaryButton(
                              title: widget.rejectActionButtonText,
                              buttonColor: Colors.red,



                              onPressed:
                                widget.onTapRejectActionButton,

                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: CommonPrimaryButton(
                              title: widget.acceptActionButtonText,
                              onPressed:
                                widget.onTapAcceptActionButton,


                          ),
                        ),
                      ],
                    ),
                  );


                }
                if(widget.data!.lastStatus == "Order-Accepted"){
                  return Container(
                    width: 250,
                    child: CommonPrimaryButton(
                        title: "View Order",
                        onPressed:
                          widget.onTapActionButton,
                            //startShopping(userID: userID, orderID: _orderdata.id, context: context)
                    ),
                  );
                }

                if(widget.data!.lastStatus == "Shopping-In-Progress"){
                  return Container(
                   // height: 50,
                    width: 250,
                    child: CommonPrimaryButton(
                        title: "View Order",
                        onPressed:

                          widget.onTapActionButton,

                    ),
                  );
                }


                if(widget.data!.lastStatus == "Order-Ready" && widget.data!.deliveryPartnerId == null){
                  return Container(
                    width: 250,
                    child: CommonPrimaryButton(
                      title: "View Order",
                      onPressed: widget.onTapDeliveryActionButton,
                    ),
                  );
                }

                if(widget.data!.lastStatus == "Order-Ready"){
                  return Container(
                    width: 250,
                    child: CommonPrimaryButton(
                        title: "View Order",

                        onPressed:widget.onTapDeliveryActionButton,//deliveryComplete(userID: userID, orderID: _orderdata.id, context: context)
                    ),
                  );
                }
                return Container();
              }

              ),


              /*Builder(
                builder: (context) {
                  print("ORDERDATAAA===>${widget.data!.lastStatus}");

                  if(widget.data!.lastStatus! != "Order-Placed" && widget.data!.lastStatus != "Order-Accepted") {
                    print("ORDERDATA===>${widget.data!.lastStatus}");
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),

                      *//*decoration: BoxDecoration(
                        gradient: ThemeGradient,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10) ),
                        color: Theme.of(context).primaryColor
                    ),*//*
                      child: Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            *//* Expanded(
                            child: Text('STATUS : ${widget.data!.lastStatus!.toUpperCase()}',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),*//*

                            InkWell(
                              onTap: widget.onTapRejectActionButton,

                              *//*(){
                              Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false).rejectOrder(context, Provider.of<UserDataViewModel>(context,listen: false).userID,widget.data!.id);
                            },*//*
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                ),
                                child: Row(

                                  children: [
                                    Text(widget.rejectActionButtonText!,
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    //Icon(CupertinoIcons.arrow_left_to_line_alt,color: Theme.of(context).primaryColor,)
                                  ],
                                ),

                              ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            InkWell(
                              onTap:
                              widget.onTapAcceptActionButton,

                              *//*Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OrderDetails(widget.data!.id)));

                                  Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false).acceptOrder(userID: Provider.of<UserDataViewModel>(context,listen: false).userID, orderID:  widget.data!.id, context: context);*//*


                              //widget.onTapAcceptActionButton,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                ),
                                child: Row(
                                  children: [
                                    Text(widget.acceptActionButtonText!,
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //Icon(CupertinoIcons.arrow_right_circle_fill,color: Theme.of(context).primaryColor,)
                                  ],
                                ),
                              ),
                            ),

                          ],

                        ),
                      ),

                    );
                  }


                    return Container();



                }

              ),*/
              SizedBox(height: 20,),



       /* Container(

            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CachedNetworkImage(
                      imageUrl:'https://source.unsplash.com/user/c_v_r/100x100',
                      //'${product.productid.images}',
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 75,
                      width: 75,
                      fit: BoxFit.cover,)),
                SizedBox(width: 30,),
                Expanded(
                  child: Container(
                    height: 85,
                    // color: Colors.orange,
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "product name",
                            //"${product.productid.productname} ",
                            overflow:TextOverflow.ellipsis,maxLines:2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                        Text(
                            "₹ 150",
                            //" ₹ ${product.price}",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                        // SizedBox(height: 8),
                        Builder(
                            builder: (context) {
                              print("shop ass quantity is 1");
                              print("product status is placed");

                              *//*if(shoppingIsComplete()){
                                return Row(
                                  children: [
                                    Text(" Qty: ",
                                        style: TextStyle(color: Colors.black54,)
                                    ),

                                    Text("${widget.product.quantity}",
                                        style: TextStyle(color: Colors.black54,
                                            decoration:widget.product.shopAssistantQuantity!>=0 && widget.product.quantity!=widget.product.shopAssistantQuantity?TextDecoration.lineThrough:TextDecoration.none)
                                    ),
                                    Builder(
                                        builder: (context) {
                                          if(widget.product.shopAssistantQuantity!>=0 && widget.product.quantity != widget.product.shopAssistantQuantity){
                                            return Text(" ${widget.product.shopAssistantQuantity}",
                                              style: TextStyle(color: Colors.red,
                                              ),
                                            );
                                          }
                                          return Container();
                                        }
                                    )
                                  ],
                                );
                              }*//*
                              return Text(
                                //"Qty : ${getProductQuantity()}",
                                  " Qty: "+"3",
                                  style: TextStyle(color: Colors.black54));
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))*/
             /* Container(
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
              )*/


            ],
          ),
        ),
      //),
    );
  }
}
