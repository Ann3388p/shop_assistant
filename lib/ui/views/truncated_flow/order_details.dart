import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/models/truncated_flow_delivery_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/utils/utilities.dart';
import 'package:shop_assistant/ui/shared_widgets/retry_widget.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_shoppping_viewmodel.dart';
import 'package:shop_assistant/ui/views/available_orders_screen.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_get_direction_butoon.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_product_item.dart';
import 'package:shop_assistant/ui/views/order_details_screen/order_details_share_location_button.dart';

import 'package:shop_assistant/ui/views/truncated_flow/product_count.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_details.dart';
import 'package:shop_assistant/ui/views/truncated_flow/shopping_screen_new.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/utils/validations.dart';
import '../../shared_widgets/common_primary_button.dart';
import '../../shared_widgets/dialogs.dart';
import '../../shared_widgets/payment_verification_dialog.dart';
import '../../shared_widgets/product_block.dart';
import '../order_billing_screen/bill_amount.dart';
import '../todo_screen.dart';
import 'AvailableOrderScreenNew.dart';
import 'Payment_Veification_Dialog_Truncated.dart';
import 'delivery_screen_new.dart';
// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  // bool startShopping;
  int? count;
  var orderID;
  var orderNumber;
  bool isShowDialog;
  String lastStatus;
  OrderDetails(
      this.orderID,
      this.orderNumber,
      this.isShowDialog,
      this.lastStatus,
      {this.count,

      }
      );

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();

  fetchData(){
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<OrderDetailsViewModel>(context,listen: false)
            .getOrderDetails(context,widget.orderID));
  }

  IO.Socket? socket;

  late TimeOfDay _time;

  @override
  void initState() {
    Provider.of<OrderDetailsViewModel>(context,listen: false).orderID = widget.orderID;
    Provider.of<OrderDetailsViewModel>(context,listen: false).cleardata();
    Provider.of<OrderDetailsViewModel>(context,listen: false).billAmount = 0;

    Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.lastStatus = widget.lastStatus;
   // print("ORDER-ACCEPTED${Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.lastStatus}");

    print("ORDER-ACCEPTED${Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.lastStatus}");

    if(Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.lastStatus == 'Order-Accepted') {
      print("ORDER-ACCEPTED${Provider
          .of<OrderDetailsViewModel>(context, listen: false)
          .orderData
          .lastStatus}");
      Provider.of<OrderDetailsViewModel>(context, listen: false).
      updateOrderStatus(userID: Provider
          .of<UserDataViewModel>(context, listen: false)
          .userID,
          orderID: Provider
              .of<OrderDetailsViewModel>(context, listen: false)
              .orderID,
          context: context);
    }
     /* if (Provider
          .of<OrderDetailsViewModel>(context, listen: false)
          .isShopping == true) {
        CircularProgressIndicator();
      }*/
     /* else
      {
        print("ORDER-ACCEPTED${Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.lastStatus}");
        Provider.of<OrderDetailsViewModel>(context, listen: false).
        updateOrderStatus(userID: Provider
            .of<UserDataViewModel>(context, listen: false)
            .userID,
            orderID: Provider
                .of<OrderDetailsViewModel>(context, listen: false)
                .orderID,
            context: context);
      }*/
  //  }

    fetchData();

    //_time = Provider.of<OrderDetailsViewModel>(context,listen: false).orderData.estimatedDeliveryTime.toString() as TimeOfDay;
    _time = TimeOfDay.now();
    print("PRODUCTCOUNT==>${widget.count}");
    super.initState();

  }

  @override

  Future<bool> _onBackPressed() async {
     setState(() {

       Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (context) => MyOrdersScreenNew()));
     });

     return true;
     }

  @override

  Future<bool> _onBackPressedDelivery() async {
    setState(() {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DeliveryScreenNew()));
    });

    return true;
  }


  @override
  void dispose() {

    //close();
    super.dispose();
  }

  final _SECTIONPADDING = EdgeInsets.symmetric(horizontal: 15);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        print(_time);
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<OrderDetailsViewModel>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.white,//Colors.grey[100],
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            print("status in order details${widget.lastStatus}");
            // if(provider.orderData.lastStatus == 'Order-Ready') {
            //   return IconButton(
            //     icon: Icon(Icons.arrow_back),
            //     onPressed: () {
            //       // _onBackPressedDelivery();
            //       // print("back button pressed");
            //       // Navigator.pushReplacement(context,
            //       //     MaterialPageRoute(
            //       //         builder: (context) => DeliveryScreenNew()));
            //       // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>AvailableOrdersScreenNew()));
            //       Navigator.of(context).pop();
            //     },
            //   );
            // }
            if(widget.lastStatus == 'Order-Accepted'||widget.lastStatus == 'Shopping-In-Progress'||widget.lastStatus == 'Order-Placed')
              {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _onBackPressed();
                    print("else back button pressed");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (context) =>  MyOrdersScreenNew()));
              }

            // else{
            //
            //       // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>AvailableOrdersScreenNew()));
            //       // Navigator.of(context).pop();
            //     },
              );
            }
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // _onBackPressedDelivery();
                // print("back button pressed");
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(
                //         builder: (context) => DeliveryScreenNew()));
                // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>AvailableOrdersScreenNew()));
                Navigator.of(context).pop();
              },
            );


          }

        ),
        title: Text("#${widget.orderNumber}"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<OrderDetailsViewModel>(
          builder: (context,value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator());
            }
            if(value.orderDetailsResponse.haserror)
            {
              //return RetryWidget(onTap:fetchData);
            }
            //   OrderDetailsModel _orderData = value.orderDetailsResponse.data;

            //   _amountController.text = value.billAmount;

            return Container(
              height:height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(thickness: 8,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,10,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Order created Date :",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,15,0,10),
                              child: Text(
                                  "${provider.orderData.stats![0].created}"
                                //'${data.deliveryAddress}'
                              ),
                            ),
                          ],
                        ),


                        Divider(thickness: 8,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,10,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Order created time :",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,15,0,10),
                              child: Text(
                                  "${Utilities.convertTimeToString(provider.orderData.stats![0].createdTime!)}"

                                //'${data.deliveryAddress}'
                              ),
                            ),

                          ],
                        ),

                        /* Builder(
                            builder: (context) {
                              if(_orderData.specialInstructions != null && _orderData.specialInstructions!.isNotEmpty)
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(thickness: 8),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Special Instruction :",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15,8,0,10),
                                      child: Text(
                                          "${_orderData.specialInstructions}"
                                        //'${data.deliveryAddress}'
                                      ),
                                    ),

                                  ],
                                );
                              return Container();
                            }),*/

                        /*Divider(thickness: 8,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,10,0,0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Customer Details :",
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,8,0,10),
                          child: Row(
                            children: [
                              Text(
                                  "Name : ${_orderData.customerName}\nMobile Number : ${_orderData.mobileNumber}"
                                //'${data.deliveryAddress}'
                              ),
                              Spacer(),
                              IconButton(onPressed: () async {
                                await launch('tel:+91${_orderData.mobileNumber}');
                              }, icon: Icon(Icons.phone_outlined))
                            ],
                          ),
                        ),
                        Divider(thickness: 8,),
                        InkWell(
                          onTap: (){
                            // Utils.openMap(_orderData., longitude)
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,10,0,0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Delivery Address :",
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15,8,0,10),
                                child: Text(
                                    "${_orderData.deliveryAddress}"
                                  //'${data.deliveryAddress}'
                                ),
                              ),
                            ),
                            //Spacer(),
                            OrderDetailsGetDirectionButton(
                                status: _orderData.lastStatus!,
                                lat: _orderData.deliveryLat,
                                lng: _orderData.deliveryLng
                            )
                            // TextButton.icon(
                            //     onPressed: () async {
                            //       final Uri uri= Uri.parse('google.navigation:q=8.56775,76.873516');
                            //       await launchUrl(uri);
                            //     },
                            //     icon: Icon(Icons.directions),
                            // label: Text("Directions"),)
                          ],
                        ),*/
                        //OrderDetailsShareLocationButton(orderData: _orderData),
                        Divider(thickness: 8,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,10,0,0),
                          child: Text(
                              "Bill details :",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,8,15,0),
                          child: Row(
                            children: [
                              Text('Total product price'),
                              Spacer(),
                              Text(
                                   "₹ ${provider.orderData.totalPrice!.toStringAsFixed(2)}"
                                //"₹ ${provider.orderData.products!.map((e) => e.productPrice)}"
                                //  '₹ ${data.totalPrice.toStringAsFixed(2)}'
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,8,15,0),
                          child: Row(
                            children: [
                              Text('Delivery charge'),
                              Spacer(),
                              Text(
                                  "₹ ${provider.orderData.deliveryCharge!
                                      .toStringAsFixed(2)}"
                                //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                              ),
                            ],
                          ),
                        ),

                        Builder(
                            builder: (context) {
                              if(provider.orderData.discountPrice>0)
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,0),
                                  child: Row(
                                    children: [
                                      Text('Coupon discount'),
                                      Spacer(),
                                      Text("-₹ ${provider.orderData.discountPrice}"
                                        //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                                      ),
                                    ],
                                  ),
                                );
                              return Container();
                            }
                        ),

                        /*Builder(
                            builder: (context) {
                              if(_orderData!.discountPrice>0)
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,0),
                                  child: Row(
                                    children: [
                                      Text('Coupon discount'),
                                      Spacer(),
                                      Text("-₹ ${_orderData.discountPrice}"
                                        //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                                      ),
                                    ],
                                  ),
                                );
                              return Container();
                            }
                        ),*/

                        /* Builder(
                            builder: (context) {
                              print("${_orderData.finalBillAmount}");
                              if(_orderData.finalBillAmount>0)
                              {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,0),
                                  child: Row(
                                    children: [
                                      Text('Billed Amount',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                                      Spacer(),
                                      Text(
                                        "₹ ${_orderData.finalBillAmount!=0?_orderData.finalBillAmount.toStringAsFixed(2):0.0}",
                                        //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            }
                        ),*/
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,8,15,0),
                          child: Row(
                            children: [
                              Text('Total',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                              Spacer(),
                              Builder(
                                  builder: (context) {
                                    if(provider.orderData.deliveryCharge == 0){
                                      return Text("₹ ${provider.orderData.totalPrice
                                          .toStringAsFixed(2) }",
                                        //'₹ ${data.totalPriceDelivery!=n.ull?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                        style: TextStyle(fontSize: 17,
                                            fontWeight: FontWeight.w600),);
                                    }

                                    else if(provider.orderData.totalPrice != 0) {
                                      print("DELIVERY CHARGE HERE${provider.orderData.deliveryCharge}");

                                      return Text("₹ ${provider.orderData
                                          .totalPriceDelivery != null ? provider
                                          .orderData.totalPriceDelivery!
                                          .toStringAsFixed(2) : 0.0}",
                                        //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                        style: TextStyle(fontSize: 17,
                                            fontWeight: FontWeight.w600),);

                                    }
                                    else{
                                      return Text("₹ 0",
                                        //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                        style: TextStyle(fontSize: 17,
                                            fontWeight: FontWeight.w600),);
                                    }
                                  }
                              )

                            ],
                          ),
                        ),

                        Divider(thickness: 8,),

                        /*ProductDetailsCardWithCheckBox(
                          title:'Product Details',
                          productName: 'test',
                          productImage: 'https://source.unsplash.com/user/c_v_r/100x100',
                          price: '50',
                          promoPrice: '40',
                          uom: 'No.s',
                          quantity: 1,
                          shopAssistantQuantity: 2,
                        ),*/

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,15,0,10),
                              child: Text("Ordered Items",
                                style: TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 16,

                                ),),
                            ),

                            /* Padding(
                              padding: const EdgeInsets.fromLTRB(95,15,0,10),
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(context: context, builder: (context){
                                    return ProductDialog(
                                      productName: _orderData.products![0].productid!.productname,
                                    productImage: _orderData.products![0].productid!.image!.primary,
                                    quantity: _orderData.products![0].quantity,);
                                  });
                                 // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProductDialog()));
                                },
                                child: Text("Edit Product Items",
                                  style: TextStyle(
                                    fontWeight:FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.green,
                                    decoration: TextDecoration.underline,
                                  ),),
                              ),
                            ),*/

                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 50),
                            physics: ScrollPhysics(),
                            itemCount: provider.orderData.products!.length,
                            itemBuilder: (context, int orderDataIndex) {
                              print("${provider.orderData.products![orderDataIndex].productid!
                                  .image}");

                              print("SHOP ASSISTANT QUANTITY:==>${provider.orderData
                                  .products![orderDataIndex].shopAssistantQuantity}");
                              provider.dataIndex = orderDataIndex;
                              print("INSIDE BUILDER ${provider.dataIndex}");
                              //dynamic selectedQuantity;
                              int count;
                              print("PRODUCT INDDEX $orderDataIndex");
                              return Builder(
                                  builder: (context) {
                                    if(provider.orderData.lastStatus == 'Order-Ready'){
                                      print("PRODUCTPERQUANTITY${int.parse(provider.orderData.products![orderDataIndex].productid!.quantity)}");
                                      return AbsorbPointer(
                                        absorbing: true,
                                        child: ProductDetailsCardWithCheckBox(
                                          //title:'Product Details',

                                          productName: provider.orderData.products![orderDataIndex]
                                              .productid!.productname,
                                          productImage: provider.orderData.products![orderDataIndex]
                                              .productid!.image!.primary,
                                          price: provider.orderData.products![orderDataIndex].productid!
                                              .price,
                                          promoPrice: provider.orderData.products![orderDataIndex]
                                              .productid!.promoprice,
                                          uom: provider.orderData.products![orderDataIndex].productid!.uom,
                                          quantity: provider.orderData.products![orderDataIndex].quantity,
                                          perQuantity: int.parse(provider.orderData.products![orderDataIndex].productid!.quantity),

                                          //quantity: selectedQuantity,
                                          //shopAssistantQuantity: selectedQuantity,
                                          onTapNotFound: () async{
                                            print("hitted");
                                            // setState((){
                                            provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                            isSelected : true;

                                            provider.calculateBillAmount();
                                            //provider.orderData.products![orderDataIndex].quantity == 0;

                                            // });

                                          },
                                          isSelected: true,
                                          onTapCheckBox: ()async{

                                            print("ON TAP CHECK BOX");
                                            provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;

                                            provider.calculateBillAmount();
                                          },


                                          onTapEditButton: () async {
                                            print("THIS IS SELECTED QTY; ${provider.selectedQuantity}");
                                            provider.selectedQuantity = await showDialog<
                                                int>(
                                                context: context,
                                                builder: (context) =>
                                                //showDialog(context: context, builder: (context){


                                                ProductDialog(
                                                  //productindex: orderDataIndex,
                                                  productName: provider.orderData.products![orderDataIndex]
                                                      .productid!.productname,
                                                  productImage: provider.orderData
                                                      .products![orderDataIndex].productid!.image!
                                                      .primary,
                                                  quantity: provider.orderData.products![orderDataIndex]
                                                      .quantity,

                                                  price: provider.orderData.products![orderDataIndex].productPrice.toString(),
                                                  // count: provider.orderData.products![orderDataIndex].quantity != null ?
                                                  // provider.orderData.products![orderDataIndex].quantity : provider.orderData.products![orderDataIndex].shopAssistantQuantity,
                                                  count: provider.orderData.products![orderDataIndex].shopAssistantQuantity == null ?
                                                  provider.orderData.products![orderDataIndex].quantity : provider.orderData.products![orderDataIndex].shopAssistantQuantity,
                                                  /*onIncrement: ()
                                              {
                                                provider.incrementCount();
                                              },
                                              onDecrement: (){
                                                provider.decrementCount();
                                              },*/

                                                  /*onConfirm: (){

                                                print("HERE COUNT===> ${provider.selectedQuantity}");
                                                Navigator.of(context).pop(provider.selectedQuantity);
                                                provider.calculateBillAmount(provider.orderData.products![orderDataIndex].productPrice.toString(),provider.selectedQuantity);
                                                //Navigator.pop(context, result);



                                              },*/


                                                )
                                            );
                                            print("SELECTED QNTY===>${provider.selectedQuantity}");

                                            if (provider.selectedQuantity != null) {

                                              // setState((){

                                              print(
                                                  "PRODUCT COUNT VALUE==>${provider.selectedQuantity} ${orderDataIndex}");

                                              provider.orderData.products![orderDataIndex]
                                                  .shopAssistantQuantity =
                                                  provider.selectedQuantity;

                                              print(
                                                  "THE SELECTED QUANTITY IS:  ${provider.orderData
                                                      .products![orderDataIndex]
                                                      .shopAssistantQuantity}");
                                              // });


                                            }

                                          },


                                          shopAssistantQuantity: provider.orderData.products![orderDataIndex].shopAssistantQuantity,


                                        ),
                                      );
                                    }
                                    else{
                                      return ProductDetailsCardWithCheckBox(
                                        //title:'Product Details',
                                        /*checkBoxSelected: Checkbox(
                                          value: provider.toggleCheckbox(orderDataIndex),
                                          onChanged: (bool? value) {
                                            provider.isSelected![orderDataIndex] = value!;
                                          },
                                        ),*/


                                        onCheckBox: ElevatedButton(

                                          onPressed: (){
                                            provider.toggleCheckbox(orderDataIndex);
                                            provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                            provider.calculateBillAmount();
                                          },
                                          child: Text(
                                              "Can't Find Item"),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                .green),
                                          ),
                                        ),
                                        productName: provider.orderData.products![orderDataIndex]
                                            .productid!.productname,
                                        productImage: provider.orderData.products![orderDataIndex]
                                            .productid!.image!.primary,
                                        price: provider.orderData.products![orderDataIndex].productid!
                                            .price,
                                        promoPrice: provider.orderData.products![orderDataIndex]
                                            .productid!.promoprice,
                                        uom: provider.orderData.products![orderDataIndex].productid!.uom,
                                        quantity: provider.orderData.products![orderDataIndex].quantity,
                                        perQuantity: int.parse(provider.orderData.products![orderDataIndex].productid!.quantity),

                                        //quantity: selectedQuantity,
                                        //shopAssistantQuantity: selectedQuantity,

                                        onTapNotFound: () async{
                                          print("ORDERINDEX:$orderDataIndex");
                                          // setState((){
                                          provider.toggleCheckbox(orderDataIndex);


                                          provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                          provider.calculateBillAmount();
                                          //provider.orderData.products![orderDataIndex].quantity == 0;

                                          // });

                                        },



                                        onTapEditButton: () async {
                                          print("THIS IS SELECTED QTY; ${provider.selectedQuantity}");
                                          /*setState((){
                if(provider.clicked)
                  {
                    print("HEY");
                    provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                  }
                provider.clicked = true;
            });*/



                                          provider.selectedQuantity =
                                          await showDialog<
                                              int>(
                                              context: context,
                                              builder: (context) =>
                                              //showDialog(context: context, builder: (context){

                                              ProductDialog(

                                                //productindex: orderDataIndex,

                                                productName: provider.orderData.products![orderDataIndex]
                                                    .productid!.productname,
                                                productImage: provider.orderData
                                                    .products![orderDataIndex].productid!.image!
                                                    .primary,
                                                quantity: provider.orderData.products![orderDataIndex]
                                                    .quantity,

                                                price: provider.orderData.products![orderDataIndex].productPrice.toString(),
                                                // count: provider.orderData.products![orderDataIndex].quantity != null ?
                                                // provider.orderData.products![orderDataIndex].quantity : provider.orderData.products![orderDataIndex].shopAssistantQuantity,

                                                ////////////////////////////////////////////////////////////////////////

                                                // count: provider.orderData.products![orderDataIndex].shopAssistantQuantity == null ?
                                                // provider.orderData.products![orderDataIndex].quantity :
                                                // provider.orderData.products![orderDataIndex].shopAssistantQuantity,
                                                //////////////////////////////////////////////////////////////////////////
                                                  count:provider.orderData.products![orderDataIndex].quantity!,



                                                //count: provider.count,

                                                /*onIncrement: ()
                                            {
                                              provider.incrementCount();
                                            },
                                            onDecrement: (){
                                              provider.decrementCount();
                                            },

            onConfirm: (){

                                              print("HERE COUNT===> ${provider.count}");
                                              Navigator.of(context).pop(provider.count);
                                              provider.calculateBillAmount(provider.orderData.products![orderDataIndex].productPrice.toString());
                                              //Navigator.pop(context, result);



                                            },*/


                                              )
                                          );
                                          print("SELECTED QNTY===>${provider.selectedQuantity}");

                                          if (provider.selectedQuantity != null) {

                                            // setState((){

                                            print("PRODUCT COUNT VALUE==>${provider.selectedQuantity} ${orderDataIndex}");

                                            provider.orderData.products![orderDataIndex]
                                                .shopAssistantQuantity =
                                                provider.selectedQuantity;
                                            provider.calculateBillAmount();
                                            print(
                                                "THE SELECTED QUANTITY IS:  ${provider.orderData
                                                    .products![orderDataIndex]
                                                    .shopAssistantQuantity}");
                                            // });


                                          }

                                        },


                                        shopAssistantQuantity: provider.orderData.products![orderDataIndex].shopAssistantQuantity,


                                      );

                                    }

                                  }
                              );




                            }

                        ),

                        //count: _orderData[0].products!.length,

                        //OrderDetailsProductItem(_orderData.products![index]);



                        Builder(
                            builder: (context) {
                              if(provider.orderData.lastStatus == 'Order-Ready') {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child:
                                  Row(
                                    children: [
                                      Text("Payment Status: ", style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),),
                                      SizedBox(width: 50,),
                                      Builder(
                                          builder: (context) {
                                            if (value.paymentStatus == 0) {
                                              return Text("Waiting for payment",
                                                style: TextStyle(fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green),);
                                            }
                                            if (value.paymentStatus == 1) {
                                              return Text(
                                                "Payment Verified By Hand",
                                                style: TextStyle(fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green),);
                                            }
                                            if (value.paymentStatus == 2) {
                                              return Text("Payment Verified",
                                                style: TextStyle(fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green),);
                                            }
                                            return Container();
                                          }
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }
                        ),

                        SizedBox(height: 20,),


                        // Builder(
                        //     builder: (context) {
                        //       if(provider.orderData.lastStatus == "Order-Ready") {
                        //
                        //         print("ESTIMATED TIME: ${provider.orderData.estimatedDeliveryTime}");
                        //         return Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 20.0, right: 20),
                        //           child: GestureDetector(
                        //             onTap: () =>
                        //                 {
                        //                   _selectTime(context),
                        //                 },
                        //
                        //             child: AbsorbPointer(
                        //               child: TextField(
                        //                 decoration: InputDecoration(
                        //                   labelText: 'Estimated Delivery Time',
                        //                   suffixIcon: Icon(Icons.timer),
                        //                 ),
                        //                 controller: TextEditingController(
                        //                     text: (provider.orderData.estimatedDeliveryTime == null ? _time.format(context) : Utilities.convertStringToTime(int.parse(provider.orderData.estimatedDeliveryTime!)))),
                        //                 //_time.format(context)),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //       return Container();
                        //     }
                        // ),



                        SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 20.0),
                          child: Builder(
                            builder: (context) {

                              if(provider.orderData.lastStatus == 'Order-Ready') {
                                return AbsorbPointer(
                                  absorbing: true,
                                  child: Row(
                                    children: [
                                      Text("Bill Amount",
                                        style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.w600),),
                                      //  SizedBox(width: 20,),
                                      Form(
                                        key: _formKey,
                                        child: Flexible(
                                          child: TextFormField(
                                            textAlign: TextAlign.right,
                                            controller: provider.amountController,
                                            validator: (val) =>
                                                Validations.validateAmount(val!),
                                            minLines: null,
                                            maxLines: null,
                                            // autofocus: true,
                                            //readOnly: value.checkPaymentDone(),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9.]'))
                                            ],

                                            style: TextStyle(fontSize: 35),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              // icon: Icon(Icons.account_circle),
                                                border: InputBorder.none,
                                                hintText: provider.orderData
                                                    .finalBillAmount.toString(),
                                                hintStyle: TextStyle(fontSize: 40,
                                                    color: Colors.black)
                                            ),
                                          ),
                                        ),


                                      ),

                                    ],
                                  ),
                                );
                              }

                              else{
                                return Row(
                                  children: [
                                    Text("Enter Bill Amount",
                                      style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.w600),),
                                    //  SizedBox(width: 20,),
                                    Form(
                                      key: _formKey,
                                      child: Flexible(
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          controller: provider.amountController,
                                         /* validator: (val) =>
                                              Validations.validateBillAmount(val!),*/
                                          minLines: null,
                                          maxLines: null,
                                          // autofocus: true,
                                          //readOnly: value.checkPaymentDone(),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.]'))
                                          ],

                                          style: TextStyle(fontSize: 35),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // icon: Icon(Icons.account_circle),
                                              border: InputBorder.none,
                                              hintText: provider.orderData
                                                  .totalPrice.toString(),
                                              hintStyle: TextStyle(fontSize: 40,
                                                  color: Colors.black)
                                          ),
                                        ),
                                      ),


                                    ),

                                  ],
                                );
                              }
                            }
                          ),
                        ),

                        Builder(
                            builder: (context) {

                              /*if(provider.orderData.lastStatus ==
                                  'Order-Ready' && provider.orderData.deliveryPartnerId == null){
                                return CommonPrimaryButton(
                                  title: 'Add to delivery',
                                  onPressed: () {
                                    provider.addToDelivery(context: context,userID: Provider.of<UserDataViewModel>(context,listen: false).userID);
                                  },
                                );
                              }*/

                              if (widget.lastStatus ==
                                  'Order-Ready'&& provider.orderData.deliveryPartnerId == null) {

                                return CommonPrimaryButton(
                                        title: 'Add to Delivery',
                                        onPressed: () {
                                          provider.addToDeliveryTruncate(context: context, userID:
                                          Provider.of<UserDataViewModel>(context,listen: false).userID,

                                          );
                                          //for(int i =0; i<= _orderData.products!.length ; i++) {
                                         // print("HIIII");
                                          // value.deliveryCompleteFromTruncatedFlow(context: context, userID:  Provider.of<UserDataViewModel>(context,listen: false).userID,);

                                          // _selectTime(context);

                                          //
                                          // GestureDetector(
                                          //   onTap: () =>
                                          //   {
                                          //     _selectTime(context),
                                          //   },
                                          //
                                          //   child: AbsorbPointer(
                                          //     child: TextField(
                                          //       decoration: InputDecoration(
                                          //         labelText: 'Estimated Delivery Time',
                                          //         suffixIcon: Icon(Icons.timer),
                                          //       ),
                                          //       controller: TextEditingController(
                                          //           text: (provider.orderData.estimatedDeliveryTime == null ? _time.format(context) : Utilities.convertStringToTime(int.parse(provider.orderData.estimatedDeliveryTime!)))),
                                          //       //_time.format(context)),
                                          //     ),
                                          //   ),
                                          // ),

                                        }
                                    );


                                // return CommonPrimaryButton(
                                //     title: 'Complete',
                                //     onPressed: () {
                                //       //for(int i =0; i<= _orderData.products!.length ; i++) {
                                //       print("HIIII");
                                //       value.deliveryCompleteFromTruncatedFlow(context: context, userID:  Provider.of<UserDataViewModel>(context,listen: false).userID,);
                                //
                                //       // },
                                //     }
                                // );
                              }
                              if (widget.lastStatus ==
                                  'Order-Ready'&& provider.orderData.estimatedDeliveryTime != null)
                                {

                                  return CommonPrimaryButton(
                                      title: "Verify Payment",
                                      onPressed: ()async
                                      {
                                        print("Enter payment");
                                        PaymentVerificationDialogTruncated(context);
                                      }
                                       //deliveryComplete(userID: userID, orderID: _orderdata.id, context: context)
                                  );
                                }

                              // if(!provider.addToDeliveryResponse.haserror)
                              //   {
                              //     return CommonPrimaryButton(
                              //             title: 'Complete',
                              //             onPressed: () {
                              //               //for(int i =0; i<= _orderData.products!.length ; i++) {
                              //               print("HIIII");
                              //               value.deliveryCompleteFromTruncatedFlow(context: context, userID:  Provider.of<UserDataViewModel>(context,listen: false).userID,);
                              //
                              //               // },
                              //             }
                              //         );
                              //   }
                               //if(widget.lastStatus == 'Shopping-In-Progress' || widget.lastStatus == 'Order-Accepted')
                              else
                              {
                                return CommonPrimaryButton(
                                    title: 'Confirm',
                                    onPressed: () {
                                      //for(int i =0; i<= _orderData.products!.length ; i++) {
                                      if (_formKey.currentState!.validate()) {

                                        if(provider.orderData.totalPrice == 0.0)
                                          {
                                            print("Reject the order");
                                            value.rejectOrderBillAmt(context, Provider.of<UserDataViewModel>(context,listen: false).userID);
                                            // value.updateOrderStatusBillAmt(userID: Provider.of<UserDataViewModel>(context,listen: false).userID, orderID: Provider
                                            //     .of<OrderDetailsViewModel>(context, listen: false)
                                            //     .orderID, context: context);
                                          }
                                       // print("HIIII");
                                        else {
                                        value.changeStatusToOrderReady(context);
                                      }

                                        // },
                                      }
                                    }
                                );
                              }

                              // else {
                              //   return CommonPrimaryButton(
                              //     title: 'Confirm',
                              //     onPressed: () {
                              //       //for(int i =0; i<= _orderData.products!.length ; i++) {
                              //
                              //       //Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ItemList()));
                              //       print("HIIII");
                              //       print(provider.orderData.totalPrice);
                              //       print(provider.orderData.totalPriceDelivery);
                              //
                              //       value.changeStatusToOrderReady(context);
                              //     },
                              //   );
                              // }
                            }

                        ),


                        SizedBox(
                          height: 20,
                        )

                      ],
                    ),
                  ),




                ],
              ),
            );
          }
      ),
    );
  }
}
