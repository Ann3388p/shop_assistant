import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/custom_package/custom_stepper_widget.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/views/order_billing_screen/bill_amount.dart';
import 'package:shop_assistant/ui/views/order_billing_screen/bill_upload.dart';

class OrderBillingScreen extends StatefulWidget {
  @override
  _OrderBillingScreenState createState() => _OrderBillingScreenState();
}

class _OrderBillingScreenState extends State<OrderBillingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Order Billing'),
      ),
      body: Consumer<OrderBillingViewModel>(
          builder: (context,value, child) {
            return CustomStepper(
              currentStep: value.stepperIndex,
              onStepContinue:()=>value.nextStep(),
              onStepCancel:()=>value.previousStep() ,
              controlsBuilder:(BuildContext context,_) =>
                  Container(),
              steps: [
                CustomStep(
                    title: Icon(Icons.calculate),
                    content: BillAmount(),
                    isActive: value.stepperIndex == 0
                ),
                CustomStep(
                    title: Icon(Icons.calculate),
                    content: BillUpload(),
                    isActive: value.stepperIndex == 1

                ),
                // CustomStep(
                //     title: Icon(Icons.calculate),
                //     content:Text('content3'),
                //     isActive: value.stepperIndex == 2
                //
                // ),
                // CustomStep(
                //     title: Icon(Icons.calculate),
                //     content:Text('content4'),
                //     isActive: value.stepperIndex == 3
                // ),
                // CustomStep(
                //     title: Icon(Icons.calculate),
                //     content:Text('content5'),
                //     isActive: value.stepperIndex == 4
                //
                // ),
              ],




            );
          }
      ),
    );
  }
}
