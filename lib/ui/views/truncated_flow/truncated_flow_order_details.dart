import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/utils/utilities.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_card_with_checkboxnew.dart';

import 'package:shop_assistant/ui/views/truncated_flow/product_details.dart';
import 'package:shop_assistant/ui/views/truncated_flow/shopping_screen_new.dart';
import 'package:shop_assistant/ui/views/truncated_flow/truncatedFlowtest.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/models/order_details_model.dart';
import '../../../core/utils/validations.dart';
import '../../shared_widgets/common_primary_button.dart';
import 'Payment_Veification_Dialog_Truncated.dart';
import 'delivery_screen_new.dart';
// ignore: must_be_immutable
class TruncatedFlowOrderDetails extends StatefulWidget {
  // bool startShopping;
  int? count;
  var orderID;
  var orderNumber;
  bool isShowDialog;
  String lastStatus;
  int? length;
  TruncatedFlowOrderDetails(
     this.orderID,
      this.orderNumber,
      this.isShowDialog,
      this.lastStatus,
        this.length,
      {this.count,


      }
      );

  @override
  _TruncatedFlowOrderDetailsState createState() => _TruncatedFlowOrderDetailsState();
}

class _TruncatedFlowOrderDetailsState extends State<TruncatedFlowOrderDetails> {

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

    fetchData();
    initializeCheckBox(widget.length!);


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



  void initializeCheckBox(int length){
    Provider.of<OrderDetailsViewModel>(context,listen: false).checkboxValues = List.generate(length, (index) => true);
    Provider.of<OrderDetailsViewModel>(context,listen: false).cardColors = List.generate(length, (index) => Color.fromRGBO(226, 243, 228, 1));

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * 0.95;
    final provider = Provider.of<OrderDetailsViewModel>(context,listen: false);


    return Scaffold(
      backgroundColor: Colors.grey[100],

     /* floatingActionButton: Consumer<OrderDetailsViewModel>(
          builder: (context,provider,child) {

            return Container(
              height: 50,
              width: 300,
              child: Builder(
                builder: (context) {
                  if(widget.lastStatus == 'Order-Ready') {
                    return Builder(
                        builder: (context) {

                          *//*if(provider.orderData.lastStatus ==
                                      'Order-Ready' && provider.orderData.deliveryPartnerId == null){
                                    return CommonPrimaryButton(
                                      title: 'Add to delivery',
                                      onPressed: () {
                                        provider.addToDelivery(context: context,userID: Provider.of<UserDataViewModel>(context,listen: false).userID);
                                      },
                                    );
                                  }*//*

                          if (widget.lastStatus ==
                              'Order-Ready'&& provider.orderData.deliveryPartnerId == null) {

                            return CommonPrimaryButton(
                                title: 'Add to Delivery',
                                onPressed: () {
                                  provider.addToDeliveryTruncate(context: context, userID:
                                  Provider.of<UserDataViewModel>(context,listen: false).userID,

                                  );

                                }
                            );
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

                          else
                          {
                            return Container();
                          }

                        }

                    );
                  }
                  else{
                    return CommonPrimaryButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (provider.orderData.totalPrice == 0.0) {
                            print("Reject the order");
                            provider.rejectOrderBillAmt(context, Provider
                                .of<UserDataViewModel>(context, listen: false)
                                .userID);

                          }
                          // print("HIIII");
                          else {
                            provider.changeStatusToOrderReady(context);
                          }

                          // },
                        }

                      }, title: 'Add To Delivery',
                    );
                  }
                }
              ),
            );

          }
      ),*/

      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      extendBodyBehindAppBar: false,*/
      //appBar: AppBar(
        /*leading: Builder(
            builder: (context) {
              print("status in order details${widget.lastStatus}");

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

                );
              }
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {

                  Navigator.of(context).pop();
                },
              );


            }

        ),*/
        /*title: Text("#${widget.orderNumber}"),
        elevation: 0,
        centerTitle: true,
      ),*/

      body: Consumer<OrderDetailsViewModel>(
          builder: (context,value, child) {
            if(value.isLoading){
              return Center(child: CircularProgressIndicator());
            }
            if(value.orderDetailsResponse.haserror)
            {
              //return RetryWidget(onTap:fetchData);
            }

            return Container(
              child: GestureDetector(
                  onTap: () {
                Navigator.pop(context);
              },

                child:Container(
                height:height,
                child: Stack(
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 18.0,top: 60),
                       child: Icon(Icons.arrow_back),
                     ),

                    Padding(
                      padding: const EdgeInsets.only(top: 60.0,left: 145),
                      child: Text("#${widget.orderNumber}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Nunito')),
                    ),



                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Divider(thickness: 25,),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    //height: 150,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:10.0),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15,10,0,0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Order created Date :",
                                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16,fontFamily: 'Nunito')),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(185,12,20,10),
                                            child: Text(
                                                "${provider.orderData.stats![0].created}",
                                               style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),
                                              //'${data.deliveryAddress}'
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 25.0),
                                            child:  Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(15,10,5,15),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                        "Order created time :",
                                                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16)),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(25,10,5,15),
                                                  child: Text(
                                                    "${Utilities.convertTimeToString(provider.orderData.stats![0].createdTime!)}",
                                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),

                                                    //'${data.deliveryAddress}'
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 55.0),
                                            child: Divider(thickness: 1,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 60.0),
                                            child: Row(
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(15,10,0,0),
                                                  child: Text(
                                                      "Bill details :",
                                                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15,100,15,0),
                                            child: Row(
                                              children: [
                                                Text('Total product price'),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                      "₹ ${provider.orderData.totalPrice!.toStringAsFixed(2)}"
                                                    //"₹ ${provider.orderData.products!.map((e) => e.productPrice)}"
                                                    //  '₹ ${data.totalPrice.toStringAsFixed(2)}'
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15,123,15,0),
                                            child: Row(
                                              children: [
                                                Text('Delivery charge'),
                                                SizedBox(
                                                  width: 70,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:10.0),
                                                  child: Text(
                                                      "₹ ${provider.orderData.deliveryCharge!
                                                          .toStringAsFixed(2)}"
                                                    //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Builder(
                                              builder: (context) {
                                                if(provider.orderData.discountPrice>0)
                                                  return Padding(
                                                    padding: const EdgeInsets.fromLTRB(15,146,15,0),
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


                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15,146,15,15),
                                            child: Row(
                                              children: [
                                                Text('Total',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                                                SizedBox(
                                                  width: 125,
                                                ),
                                                Builder(
                                                    builder: (context) {
                                                      if(provider.orderData.deliveryCharge == 0){
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left:10.0),
                                                          child: Text("₹ ${provider.orderData.totalPrice
                                                              .toStringAsFixed(2) }",

                                                            //'₹ ${data.totalPriceDelivery!=n.ull?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                                            style: TextStyle(fontSize: 17,
                                                                fontWeight: FontWeight.w600,color: Colors.blue),
                                                          ),
                                                        );
                                                      }

                                                      else if(provider.orderData.totalPrice != 0) {
                                                        print("DELIVERY CHARGE HERE${provider.orderData.deliveryCharge}");

                                                        return Padding(
                                                          padding: const EdgeInsets.only(left:10.0),
                                                          child: Text("₹ ${provider.orderData
                                                              .totalPriceDelivery != null ? provider
                                                              .orderData.totalPriceDelivery!
                                                              .toStringAsFixed(2) : 0.0}",
                                                            //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                                            style: TextStyle(fontSize: 17,
                                                                fontWeight: FontWeight.w600,color: Colors.blue),),
                                                        );


                                                      }
                                                      else{
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left:12.0),
                                                          child: Text("₹ 0",
                                                            //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                                                            style: TextStyle(fontSize: 17,
                                                                fontWeight: FontWeight.w600),),
                                                        );
                                                      }
                                                    }
                                                ),


                                              ],


                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                                  child: Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Builder(
                                      builder: (context) {


                                        // List<bool> checkboxValues = List.generate(provider.orderData.products!.length, (index) => true);
                                        // List<Color> cardColors = List.generate(provider.orderData.products!.length, (index) => Color(0xFFC5E6C9));



                                        void handleCheckboxChange(int index,bool newValue) {
                                          setState(() {
                                           // provider.checkboxValues[index] = !provider.checkboxValues[index];
                                            print("CHECKBOX INDEX VALUE==>${index}");
                                            print("CHECKBOX INDEX VALUE==>${provider.checkboxValues[index]}");
                                            provider.checkboxValues[index] = newValue;

                                            provider.cardColors[index] =
                                            provider.checkboxValues[index] ? Color.fromRGBO(226, 243, 228, 1) : Colors.white;
                                            print("CHECKBOX COLOR==>${provider.checkboxValues[index]}");
                                          });
                                        }

                                        return ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            //padding: EdgeInsets.only(bottom: 50),
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
                                              print("PRODUCT INDEX $orderDataIndex");

                                              return Builder(
                                                  builder: (context) {
                                                    if(provider.orderData.lastStatus == 'Order-Ready'){
                                                      //List<bool> isSelectedList = List.generate(provider.orderData.products!.length, (_) => true);
                                                      print("PRODUCTPERQUANTITY${int.parse(provider.orderData.products![orderDataIndex].productid!.quantity)}");
                                                      return AbsorbPointer(
                                                        absorbing: true,
                                                        child: ProductCardWithCheckBox(
                                                          //title:'Product Details',

                                                          /*onChanged: (bool? value) {
                                                            print("ORDERINDEX:$orderDataIndex");
                                                            // setState((){
                                                           // provider.toggleCheckbox(orderDataIndex);
                                                            provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                                            provider.calculateBillAmount();
                                                            provider.isSelected = value!;
                                                          },*/
                                                          index: orderDataIndex,
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
                                                        //  isSelectedCheckBox: isSelectedList,

                                                          //quantity: selectedQuantity,
                                                          //shopAssistantQuantity: selectedQuantity,
                                                          onTapNotFound: () async{
                                                            print("hitted");
                                                            // setState((){
                                                            provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                                            provider.calculateBillAmount();
                                                            //provider.orderData.products![orderDataIndex].quantity == 0;

                                                            // });

                                                          },
                                                          cardColor: provider.cardColors[orderDataIndex],

                                                          isSelectedCheckBox : provider.checkboxValues,
                                                          onChanged: (newValue)
                                                          {
                                                            handleCheckboxChange(orderDataIndex,newValue!);

                                                            print("CHECKBOX VALUES ===> $provider.checkboxValues");
                                                            print("ORDERINDEX:$orderDataIndex");

                                                            provider.orderData
                                                                .products![orderDataIndex]
                                                                .shopAssistantQuantity = 0;
                                                            provider.calculateBillAmount();
                                                          },

                                                          onCheckBox: Checkbox(

                                                            key: UniqueKey(),

                                                            value: provider.checkboxValues[orderDataIndex],

                                                            onChanged: (newValue)
                                                            {
                                                              handleCheckboxChange(orderDataIndex,newValue!);
                                                              print("CHECKBOX VALUES ===> ${provider.checkboxValues}");
                                                              print("ORDERINDEX:$orderDataIndex");

                                                              provider.orderData
                                                                  .products![orderDataIndex]
                                                                  .shopAssistantQuantity = 0;
                                                              provider.calculateBillAmount();
                                                            },
                                                            activeColor: Color.fromRGBO(106, 169, 42, 1),
                                                          ),

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

                                                      return ProductCardWithCheckBox(

                                                        index: orderDataIndex,
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
                                                        cardColor: provider.cardColors[orderDataIndex],
                                                          isSelectedCheckBox : provider.checkboxValues,
                                                        onChanged: (newValue)
                                                        {
                                                          handleCheckboxChange(orderDataIndex,newValue!);

                                                          print("CHECKBOX VALUES ===> $provider.checkboxValues");
                                                          print("ORDERINDEX:$orderDataIndex");

                                                          provider.orderData
                                                              .products![orderDataIndex]
                                                              .shopAssistantQuantity = 0;
                                                          provider.calculateBillAmount();
                                                        },




                                                      /* onCheckBox: Checkbox(

                                                         key: UniqueKey(),
                                                         value: provider.checkboxValues[orderDataIndex],
                                                         onChanged: (newValue)
                                                        {
                                                            handleCheckboxChange(orderDataIndex,newValue!);

                                                            print("CHECKBOX VALUES ===> $provider.checkboxValues");
                                                            print("ORDERINDEX:$orderDataIndex");

                                                            provider.orderData
                                                                .products![orderDataIndex]
                                                                .shopAssistantQuantity = 0;
                                                            provider.calculateBillAmount();
                                                        },
                                                        activeColor: Color.fromRGBO(106, 169, 42, 1),
                                                       ),*/

                                                        //isSelected: orderDataIndex,
                                                        onTapNotFound: () async{
                                                          print("ORDERINDEX:$orderDataIndex");
                                                          // setState((){
                                                          //provider.toggleCheckbox(orderDataIndex);
                                                          provider.orderData.products![orderDataIndex].shopAssistantQuantity = 0;
                                                          provider.calculateBillAmount();

                                                          //provider.orderData.products![orderDataIndex].quantity == 0;

                                                          // });


                                                        },

                                                        onTapEditButton: () async {
                                                          print("THIS IS SELECTED QTY; ${provider.selectedQuantity}");


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

                                                                count:provider.orderData.products![orderDataIndex].quantity!,


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

                                        );
                                      }
                                    ),
                                  ),
                                ),

                                Builder(
                                    builder: (context) {
                                      if(provider.orderData.lastStatus == 'Order-Ready') {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20,top: 50),
                                          child:
                                          Container(

                                            child: Row(
                                              children: [

                                                Builder(
                                                    builder: (context) {
                                                      if (value.paymentStatus == 0) {
                                                        return Row(
                                                          children: [
                                                            Icon(Icons.timer,
                                                              color: Colors.blue, // Replace 'Colors.blue' with your desired color
                                                              size: 12,), // Replace 'Icons.star' with your desired icon
                                                            SizedBox(width: 8),
                                                            Text("Waiting for payment",
                                                              style: TextStyle(fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Colors.blue),),
                                                          ],
                                                        );
                                                      }
                                                      if (value.paymentStatus == 1) {
                                                        return Row(
                                                          children: [
                                                            Icon(Icons.timer,
                                                              color: Colors.blue, // Replace 'Colors.blue' with your desired color
                                                              size: 12,), // Replace 'Icons.star' with your desired icon
                                                            SizedBox(width: 8),
                                                            Text(
                                                              "Payment Verified By Hand",
                                                              style: TextStyle(fontSize: 15,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.green),),
                                                          ],
                                                        );
                                                      }
                                                      if (value.paymentStatus == 2) {
                                                        return Row(
                                                          children: [
                                                            Icon(Icons.timer,
                                                              color: Colors.blue, // Replace 'Colors.blue' with your desired color
                                                              size: 12,), // Replace 'Icons.star' with your desired icon
                                                            SizedBox(width: 8),
                                                            Text("Payment Verified",
                                                              style: TextStyle(fontSize: 15,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.green),),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }
                                ),



                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0,left: 20.0,bottom: 40),
                                  child: Builder(
                                      builder: (context) {

                                        if(provider.orderData.lastStatus == 'Order-Ready') {
                                          return AbsorbPointer(
                                            absorbing: true,
                                            child: Row(
                                              children: [
                                                Icon(Icons.money,
                                                  color: Colors.green, // Replace 'Colors.blue' with your desired color
                                                  size: 12,), // Replace 'Icons.star' with your desired icon
                                                SizedBox(width: 8),
                                                Text("Bill Amount",
                                                  style: TextStyle(fontSize: 15,
                                                      fontWeight: FontWeight.w400),),
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
                                                          hintText: '₹${provider.orderData.finalBillAmount.toString()}',
                                                          hintStyle: TextStyle(fontSize: 40,
                                                              color: Colors.green)
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
                                              Icon(Icons.money,
                                                color: Colors.green, // Replace 'Colors.blue' with your desired color
                                                size: 12,), // Replace 'Icons.star' with your desired icon
                                              SizedBox(width: 8,),
                                              Text("Enter Bill Amount",
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.w400),),
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
                                                        hintText: "₹${provider.orderData
                                                            .totalPrice.toString()}",
                                                        hintStyle: TextStyle(fontSize: 40,
                                                            color: Colors.green)
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
                                        return Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: CommonPrimaryButton(
                                              title: 'Add to Delivery',
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
                                          ),
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


                               /* SizedBox(
                                  height: 20,
                                )*/

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),




                  ],
                ),
              )),
            );
          }
      ),
    );
  }
}
