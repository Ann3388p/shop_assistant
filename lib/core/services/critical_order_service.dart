import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../ui/viewmodel/available_orders_viewmodel.dart';
import '../../ui/viewmodel/order_details_viewmodel.dart';
import '../models/api_response_model.dart';
import '../models/critical_order.dart';
import '../models/user_data_viewmodel.dart';
import 'api_handler.dart';
import 'navigation_service.dart';

class CriticalOrderService {
  getCriticalOrder(Map<String, dynamic> body) async {
    String query = r'''query($storeid:ID)
{  
criticalOrders(storeid:$storeid)
 {  
  id  
  orderid
  {    
    id  
    orderNumber
    stats{
    status
       
       }
   products{
       id
       productPrice
       quantity
       shopAssistantQuantity
       price
       status
       
       
       productid{
           productname
           id
           desc
           
       }
   }
    shopAssistantId  
    {   
     id    
     firstName 
      }
    totalPrice
    productCount
    totalPriceUser
    totalPriceDelivery
    deliveryType
    deliveryAddress
    deliveryDate
    deliveryTime
    deliveryLat
    deliveryLng
    mobileNumber
    customerName
    specialInstructions
    commentsSeller
    lastStatus
      
}
orderNumber
counter
scheduledDateAndTime
scheduledMinutes
lastStatus 
notification
updatedAt
}
}
      ''';
    ApiResponse result =
        await ApiHandler().queryRequest(query,body: body);
    if (!result.haserror) {
      if (result.data['criticalOrders'] != null) {
        List<CriticalOrder> data = <CriticalOrder>[];
        result.data['criticalOrders'].forEach((v) {
          data.add(new CriticalOrder.fromJson(v));

        });

        // print(data.map((e) => e.shopAssistantId!.id));
        // print("Shop Assistant id===>${data.map((e) => e.shopAssistantId!.id)}");
        return ApiResponse(haserror: false, data: data, errormsg: '');
      }
    } else {
      return result;
    }
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
  removeOrderFromAvailableList(BuildContext context, String? orderID){
    Provider.of<AvailableOrdersViewModel>(context,listen: false)
        .removeOrderFromAvailableList(orderID);
  }
  scheduleAlert(BuildContext context, {required String status})async{
    final userProvider = Provider.of<UserDataViewModel>(context,listen: false);
    final orderProvider = Provider.of<OrderDetailsViewModel>(context,listen: false);
    Map<String, dynamic> body = {
      "storeid":userProvider.storeID,
      "shopassistantId":userProvider.userID,
      "orderid":orderProvider.orderID,
      "status":status,
      "deliveryDate":orderProvider.orderData.deliveryDate,
      "deliveryTime":orderProvider.orderData.deliveryTime,
      "orderNumber":orderProvider.orderData.orderNumber
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
  updateOrderStatus(Map<String, dynamic> body)async{
    String query = r'''mutation($shopAssistantId:ID!, $orderid: ID!, $stats: StatusInput!) {
        updateOrderStatus(
            shopAssistantId:$shopAssistantId,
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

}
