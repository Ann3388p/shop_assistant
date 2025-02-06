import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/navigate_to_billing_screen.dart';
import 'package:shop_assistant/ui/shared_widgets/product_block.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class DoneScreen extends StatefulWidget {
  bool isShowDialog;
  DoneScreen(this.isShowDialog);
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  void initState() {
    widget.isShowDialog = false;
    Provider.of<UserDataViewModel>(context,listen: false).isShowDialog = false;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Consumer<ShoppingScreenViewModel>(
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: value.productData!.length,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemBuilder:(context, index){
                        if(value.productData![index].status == 2){
                          return ProductBlock(value.productData![index]);
                        }
                        return Container();
                      } ),
                ),
                Builder(
                    builder: (context) {
                      if(value.todo ==0 && value.review ==0){
                        return NavigateToBillingScreen(title: "Shopping Complete",);
                      }
                      return Container();

                    }
                )
              ],
            ),
          );
        }
    );
  }
}
