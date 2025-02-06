import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/services/api_handler.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class ProductPickingServices {

  updateProductStatus(BuildContext context,Map<String,dynamic> body)async{
    String query = r'''mutation($orderid:ID!,$products:ProductsInput,$productname:String){
  updateProductStatusInOrder(
    orderid:$orderid,
    products:$products,
    productname:$productname
    ){
    id
  }
}
 ''';
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if(!result.haserror){
      Provider.of<ShoppingScreenViewModel>(context,listen:false).changeProductStatus(body);
    }
    return result;
  }

}