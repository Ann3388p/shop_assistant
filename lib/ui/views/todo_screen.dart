import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/product_block.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

import '../../core/models/user_data_viewmodel.dart';

class TodoScreen extends StatefulWidget {
  bool isShowDialog;
  TodoScreen(this.isShowDialog);
  @override
  _TodoScreenState createState() => _TodoScreenState();
}
class _TodoScreenState extends State<TodoScreen> {
  final _SECTIONPADDING = EdgeInsets.symmetric(horizontal: 15);
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
          /// CHECK WHETHER TODOS LIST IS EMPTY AND SHOW APPROPRIATE MESSAGE
          body: value.todo==0? value.showTextOnComplete(context):
          ListView.builder(
              itemCount: value.productData!.length,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder:(context, index){
                if(value.productData![index].status == 0){
                  return ProductBlock(value.productData![index]);
                }
                return Container();
              } ),
        );
      }
    );
  }
}
