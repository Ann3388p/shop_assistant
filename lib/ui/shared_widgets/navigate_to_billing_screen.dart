import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/dialog_box_options.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class NavigateToBillingScreen extends StatelessWidget {
  final String title;
  NavigateToBillingScreen({required this.title,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderBillingViewModel>(
        builder: (context, viewModel, child) {
          if(viewModel.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          return CommonPrimaryButton(
            title: title,
            onPressed: (){
              ///CHECK AT LEAST A SINGLE PRODUCT IS AVAILABLE
              ///IF NOT MARK THE ORDER AS ORDER REJECTED AND GIVE APPROPRIATE MESSAGE
              if(Provider.of<ShoppingScreenViewModel>(context,listen: false).checkAtLeastSingleProductIsAvailable()){
                viewModel.navigateTOBillingScreen(context,
                    Provider.of<ShoppingScreenViewModel>(context,listen: false).orderDetails!.id);
                // value.shoppingComplete(
                //     userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                //     orderID: value.orderDetails.id,
                //     context: context);
              }else{
                DialogBoxOptions(
                  context: context,
                    message: "Are you sure none of the products in the order is available ?",
                onPositive: (){
                  Provider.of<ShoppingScreenViewModel>(context,listen: false).markOrderAsOutOfStock(
                      userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
                      context: context);
                },onNegative: ()=>Navigator.pop(context)
                );

              }
            },
          );
        }
    );
  }
}
