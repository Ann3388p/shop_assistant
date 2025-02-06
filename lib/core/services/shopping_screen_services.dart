import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/services/api_handler.dart';
import 'package:shop_assistant/ui/viewmodel/assigned_order_viewmodel.dart';

import 'order_details_services.dart';

class ShoppingScreenServices{
/// LETS TRY TO GET THE LIST FROM THE PREVIOUS SCREEN
  updateProductStatus(Map<String,dynamic> body)async{
    String query = r'''mutation($orderid:ID,$products:ProductsInput,$productname:String){
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
  }

  orderCancelledDueToOutOfStock( Map<String,dynamic> body, BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!,$commentsSeller:String){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats,
    commentsSeller:$commentsSeller){
    id
  }
} """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      OrderDetailsService().scheduleAlert(context, status: body["stats"]["status"]);
    }
    return result;
  }

//   shoppingComplete( Map<String,dynamic> body)async{
//     String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
//   updateOrderStatus(
//     shopAssistantId:$shopAssistantId,
//     orderid:$orderid,
//     stats:$stats){
//     id
//   }
// } """;
//     ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
//     return result;
//   }
//
//   removeOrderFromAssignedList(BuildContext context, String orderID){
//     Provider.of<AssignedOrderViewModel>(context,listen: false)
//         .removeOrderFromAssignedList(orderID);
//   }
}