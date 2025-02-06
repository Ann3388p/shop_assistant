import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';

import '../../../core/models/order_details_model.dart';



class PaymentVerificationDialogTruncated{
  BuildContext context;
  PaymentVerificationDialogTruncated(this.context){
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 200),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              //width: width*.6,
              // height: 240,
              // width: 300,
              height:  MediaQuery.of(context).size.height*0.8,
              width:   MediaQuery.of(context).size.width*1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: CheckPaymentStatus()
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0,1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        }
    );
  }
}

class CheckPaymentStatus extends StatefulWidget {
  const CheckPaymentStatus({Key? key}) : super(key: key);

  @override
  _CheckPaymentStatusState createState() => _CheckPaymentStatusState();
}

class _CheckPaymentStatusState extends State<CheckPaymentStatus> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<OrderDetailsViewModel>(context,listen: false)
            .getPaymentStatus(context));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsViewModel>(
        builder: (context, value, child) {
          if(value.paymentVerificationLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(value.paymentStatus == 0){
            return PaymentNotVerified();
          }
          if(value.paymentStatus == 1){
            return PaymentVerifiedByHand();
          }
          if(value.paymentStatus == 2){
            return PaymentVerified();
          }
          return Container();
        }
    );
  }
}



class PaymentVerified extends StatefulWidget {
  const PaymentVerified({Key? key}) : super(key: key);

  @override
  _PaymentVerifiedState createState() => _PaymentVerifiedState();
}

class _PaymentVerifiedState extends State<PaymentVerified> {

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsViewModel>(
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline_outlined,color: Theme.of(context).primaryColor,size: 70,),
              Text("Payment Verified",style: TextStyle(fontWeight: FontWeight.bold),),
              CommonPrimaryButton(
                  title: "Delivery Complete",
                  onPressed: ()=>value.deliveryCompleteFromTruncatedFlow(
                      userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                      context: context))
            ],

          );
        }
    );
  }
}

class PaymentNotVerified extends StatefulWidget {
  const PaymentNotVerified({Key? key}) : super(key: key);

  @override
  _PaymentNotVerifiedState createState() => _PaymentNotVerifiedState();
}

class _PaymentNotVerifiedState extends State<PaymentNotVerified> {
  bool _checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsViewModel>(
        builder: (context, value, child) {
          OrderDetailsModel _orderData = value.orderDetailsResponse.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Waiting for payment ...',style: TextStyle(color: Colors.black54),),
              BillSummary(),
              CheckboxListTile(value: _checkBox, onChanged: (val){
                setState(() {
                  _checkBox =! _checkBox;
                });
              },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("I confirm, the payable amount ₹${_orderData.totalPriceDelivery} is collected by ${_orderData.storeid!.storeName}"),),
              Builder(
                  builder: (context) {
                    if(value.deliveryButtonLoading){
                      Center(child: CircularProgressIndicator());
                    }
                    return CommonPrimaryButton(title: "Delivery Complete",
                        key: UniqueKey(),
                        onPressed: _checkBox?()=>value.changePaymentToCashTruncatedFlow(
                            userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                            context: context):null);
                  }
              )
            ],

          );
        }
    );
  }
}

class PaymentVerifiedByHand extends StatefulWidget {
  const PaymentVerifiedByHand({Key? key}) : super(key: key);

  @override
  _PaymentVerifiedByHandState createState() => _PaymentVerifiedByHandState();
}

class _PaymentVerifiedByHandState extends State<PaymentVerified> {

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsViewModel>(
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline_outlined,color: Theme.of(context).primaryColor,size: 70,),
              Text("Payment Verified By Hand",style: TextStyle(fontWeight: FontWeight.bold),),
              CommonPrimaryButton(
                  title: "Delivery Complete",
                  onPressed: (){
                    print("Truncated Flow");
                    value.deliveryCompleteFromTruncatedFlow(
                        userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                        context: context);
                        }


              )
            ],

          );
        }
    );
  }
}

class BillSummary extends StatefulWidget {
  const BillSummary({Key? key}) : super(key: key);

  @override
  State<BillSummary> createState() => _BillSummaryState();
}

class _BillSummaryState extends State<BillSummary> {
  @override
  Widget build(BuildContext context) {

    return Consumer<OrderDetailsViewModel>(
        builder: (context,value, child) {
          OrderDetailsModel _orderData = value.orderDetailsResponse.data;
          return Column(

            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Bill details :",
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
              //   child: Row(
              //     children: [
              //       Text('Total product price'),
              //       Spacer(),
              //       Text(
              //           "₹ ${_orderData.totalPrice.toStringAsFixed(2)}"
              //         //  '₹ ${data.totalPrice.toStringAsFixed(2)}'
              //       ),
              //     ],
              //   ),
              // ),
              Builder(
                  builder: (context) {
                    print("${_orderData.finalBillAmount}");
                    if (_orderData.finalBillAmount > 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: Row(
                          children: [
                            Text('Billed Amount'),
                            Spacer(),
                            Text(
                              "₹ ${_orderData.finalBillAmount != 0 ? _orderData
                                  .finalBillAmount.toStringAsFixed(2) : 0.0}",
                              //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                              // style: TextStyle(fontSize: 17,
                              //     fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      );
                    }

                    return Container();
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: Row(
                  children: [
                    Text('Delivery charge'),
                    Spacer(),
                    Text(
                        _orderData.deliveryCharge != null ? "₹ ${_orderData
                            .deliveryCharge.toStringAsFixed(2)}" : ""
                      //  '₹ ${data.deliveryCharge!=null?data.deliveryCharge.toStringAsFixed(2):0.0}'
                    ),
                  ],
                ),
              ),
              Builder(
                  builder: (context) {
                    if (_orderData.discountPrice > 0)
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
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
              ),
              // Builder(
              //     builder: (context) {
              //       print("${_orderData.finalBillAmount}");
              //       if (_orderData.finalBillAmount > 0) {
              //         return Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
              //           child: Row(
              //             children: [
              //               Text('Billed Amount', style: TextStyle(fontSize: 17,
              //                   fontWeight: FontWeight.w600),),
              //               Spacer(),
              //               Text(
              //                 "₹ ${_orderData.finalBillAmount != 0 ? _orderData
              //                     .finalBillAmount.toStringAsFixed(2) : 0.0}",
              //                 //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
              //                 style: TextStyle(fontSize: 17,
              //                     fontWeight: FontWeight.w600),)
              //             ],
              //           ),
              //         );
              //       }
              //
              //       return Container();
              //     }
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: Row(
                  children: [
                    Text('Total', style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),),
                    Spacer(),
                    Text(
                      "₹ ${_orderData.totalPriceDelivery != null ? _orderData
                          .totalPriceDelivery.toStringAsFixed(2) : 0.0}",
                      //'₹ ${data.totalPriceDelivery!=null?data.totalPriceDelivery.toStringAsFixed(2):0.0}',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            ],

          );

        }
    );
  }
}


