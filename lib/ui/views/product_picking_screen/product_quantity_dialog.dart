import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/utils/validations.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/viewmodel/product_picking_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class ProductQuantityDialog{
  BuildContext context;
  ProductQuantityDialog(this.context,var quantity) {
    //assert(context != null);
    double height = MediaQuery.of(context).size.height;
    TextEditingController _quantityController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text("Enter Quantity",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500
                            ),),
                          SizedBox(height: 20,),
                          Form(
                            key: _formKey,
                            child: Container(
                              //height: 50,
                              child: TextFormField(
                                validator:(val)=> Validations
                                    .validateQuantity(
                                    shopAssistantQuantity: int.parse(_quantityController.text),
                                    originalQuantity: quantity),
                                controller: _quantityController,
                                textDirection: TextDirection.rtl,
                                //textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    suffixIcon: IconButton(
                                      onPressed: null, icon: FittedBox(child: Text(' / $quantity ',style: TextStyle(fontSize: 24),)),padding: EdgeInsets.zero,),
                                   //  Container(
                                   //    padding: EdgeInsets.only(top: 0),
                                   //    //color: Colors.red,
                                   //    child:
                                   // //   Column(
                                   // //      mainAxisAlignment: MainAxisAlignment.center,
                                   // //      children: [
                                   //        Text(' / $quantity ',style: TextStyle(fontSize: 20),),
                                   //      // ],
                                   //    // ),
                                   //  ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    )
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            child: Consumer<ProductPickingViewModel>(
                              builder: (context,value, child) {
                                if(value.isLoading){
                                  return Center(child: CircularProgressIndicator());
                                }
                                return CommonPrimaryButton(
                                  title: "Done",
                                  onPressed: ()async{
                                    if(_formKey.currentState!.validate()){
                                      value.updateProductStatus(
                                          context,
                                          Provider.of<ShoppingScreenViewModel>(context,listen: false).orderDetails!.id,
                                          int.parse(_quantityController.text));
                                    }
                                   // Navigator.of(context)..pop()..pop();
                                  },
                                );
                              }
                            ),
                          )
                        ],
                      ),
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

