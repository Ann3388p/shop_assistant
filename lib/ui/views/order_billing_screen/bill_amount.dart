import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/utils/validations.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class BillAmount extends StatefulWidget {
  @override
  _BillAmountState createState() => _BillAmountState();
}

class _BillAmountState extends State<BillAmount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) =>
    // Provider.of<OrderBillingViewModel>(context,listen: false)
    //     .getBillAmountFromServer(Provider.of<ShoppingScreenViewModel>(context,listen: false)
    //     .orderDetails.id));
    // // TODO: implement initState
    // super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderBillingViewModel>(
      builder: (context, value, child) {
        if(value.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        _amountController.text = value.billAmount;
        return WillPopScope(
          onWillPop: ()async{
           value.clearData();
            return Future.value(true);
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
            children: [
              Text("Enter Bill Amount",style: TextStyle(fontSize: 24),),
              Container(
                //color: Colors.red,
                child: Row(
                  children: [
                    // Expanded(
                    //     child: Text('₹',textAlign: TextAlign.end,style: TextStyle(fontSize: 40),),
                    //
                    // ),
                    Form(
                      key: _formKey,
                      child: Flexible(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _amountController,
                          validator: (val)=>Validations.validateAmount(val!),
                          minLines: null,
                          maxLines: null,
                          autofocus: true,
                          readOnly: value.checkPaymentDone(),
                          inputFormatters: [
                           FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                          ],
                          style: TextStyle(fontSize: 40),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                           // icon: Icon(Icons.account_circle),
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(fontSize: 40,color: Colors.grey)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (value.checkPaymentDone()) {
                    return Text("*Amount already paid by the customer");
                  }
                  return Container();
                }
              ),
              SizedBox(height: 50,),
              CommonPrimaryButton(
                title: 'Confirm',
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    value.confirmBillAmount(amount: _amountController.text);
                  }
                },
              )
            ],
          ),
        );
      }
    );
  }
}
