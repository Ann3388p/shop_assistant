import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_shoppping_viewmodel.dart';

import '../../ui/viewmodel/order_details_viewmodel.dart';
import '../models/api_response_model.dart';
import '../models/bill_amount_model.dart';
import '../models/truncated_flow_delivery_model.dart';
import '../models/truncated_flow_shopping_list_model.dart';
import '../models/user_data_viewmodel.dart';
import 'api_handler.dart';
import 'navigation_service.dart';

class TruncatedFlowShoppingListService{
  getTruncatedFlowShoppingList(Map<String,dynamic> body)async{
    String query = r"""query($storeid : ID!){
  truncatedFlowShoppingList(storeid:$storeid){
    id
    orderNumber
   
   stats{
   created
        createdTime
    }
    
    products{
      id
      status
      shopAssistantQuantity
      quantity
      productid{
        id
        price
        promoprice
        productname 
        quantity
        uom
        image{
          primary
          
        }
      }
    }
    deliveryAddress
    deliveryDate
    deliveryTime
    totalPrice
    totalPriceDelivery
    deliveryCharge
    lastStatus
  }
}""";




    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if (!result.haserror){

      List<TruncatedFlowOrderDetailsModel> ordersList = <TruncatedFlowOrderDetailsModel>[];
      if(result.data["truncatedFlowShoppingList"] !=null){

        result.data["truncatedFlowShoppingList"].forEach((order)=>{
          ordersList.add(TruncatedFlowOrderDetailsModel.fromJson(order))
        });
      }
      return ApiResponse(haserror: false,data: ordersList,errormsg: '');
    }
      return result;

  }



  acceptOrder(Map<String,dynamic> body, BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats){
    id
  }
} """;

    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      scheduleAlert(context, status: body["stats"]["status"]);
    }
    return result;
  }

  updateOrderStatusWithComment(Map<String, dynamic> body)async{
    String query = r'''mutation($shopAssistantId:ID!,$commentsSeller: String, $orderid: ID!, $stats: StatusInput!) {
        updateOrderStatus(
            shopAssistantId:$shopAssistantId,
            commentsSeller: $commentsSeller
            orderid: $orderid
            stats: $stats
        ) {
            id
            orderNumber
            lastStatus
       }
    } ''';
    ApiResponse response = await ApiHandler().mutationRequest(query, body: body);
    if(!response.haserror){
      scheduleAlert( NavigationService.navigatorKey.currentContext!,status: body['stats']['status']);
    }
    return response;
  }



  scheduleAlert(BuildContext context, {required String status})async{
    final userProvider = Provider.of<UserDataViewModel>(context,listen: false);
    final orderProvider = Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false);
    Map<String, dynamic> body = {
      "storeid":userProvider.storeID,
      "shopassistantId":userProvider.userID,
      "orderid":orderProvider.orderID,
      "status":status,
      "deliveryDate":orderProvider.truncatedOrderData.deliveryDate,
      "deliveryTime":orderProvider.truncatedOrderData.deliveryTime,
      "orderNumber":orderProvider.truncatedOrderData.orderNumber
    };
    String query = r"""mutation(
  $storeid:ID,
  $shopassistantId:ID,
  $orderid:ID,
  $status:String,
  $deliveryDate:String,
  $deliveryTime:String,
  $orderNumber:Int
){
  scheduleAlertOnStatus(
    storeid:$storeid,
    shopassistantId:$shopassistantId,
    orderid:$orderid,
    status:$status,
    deliveryDate:$deliveryDate,
    deliveryTime:$deliveryTime,
    orderNumber:$orderNumber)
} """;

    ApiResponse result = await ApiHandler().mutationRequest(query, body: body, scheduleAlert: true);
  }

  getBillAmountFromServer(Map<String,dynamic> body)async{
    String query =r'''query($orderid:ID!){
                      viewOrder(orderid:$orderid){
                       id
                       totalPrice
                       paymentStatus
                       finalBillAmount
                      }                    
                    }  ''';
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if(!result.haserror){
      final data = BillAmountModel.fromJson(result.data);
      return ApiResponse(haserror: false,data: data,errormsg: '');
    }
    return result;
  }

  changeOrderStatusToShopping(Map<String,dynamic> body,BuildContext context) async{

    String query = r'''
    mutation($orderid:ID!){
truncatedOrderStatusToShopping(orderid:$orderid){
id
orderNumber
totalPriceUser
shopAssistantId{
id
firstName
}
deliveryPartnerId{
id
firstName
}
stats{
status
situation
created
timestamp
createdTime
}
notifications{
id
message
created
}
}
}
    ''';

    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    // print("status --->>>${body["shopAssistantId"]["id"]}");
    if(!result.haserror){
     // removeOrderFromAvailableList(context, body["orderid"]);
       scheduleAlert(context, status: 'Shopping-In-Progress');
      //removeOrderFromCriticalOrderList(context, body["orderid"]);
    }
    return result;

  }

  removeOrderFromAvailableList(BuildContext context, String? orderID){
    Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false)
        .removeOrderFromAvailableList(orderID);
  }


}