import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/navigate_to_billing_screen.dart';
import 'package:shop_assistant/ui/shared_widgets/product_block.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

import '../../core/models/user_data_viewmodel.dart';

class ReviewScreen extends StatefulWidget {
  bool isShowDialog;
  ReviewScreen(this.isShowDialog);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
                        if(value.productData![index].status == 1 || value.productData![index].status == 3){
                          return ProductBlock(value.productData![index]);
                        }
                        return Container();
                      } ),
                ),
                Builder(
                    builder: (context) {
                      if(value.todo ==0 && value.review !=0){
                        return NavigateToBillingScreen(title: "Confirm Changes");
                      }
                      if(value.todo ==0 && value.review ==0){
                        return value.showTextOnComplete(context);
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
