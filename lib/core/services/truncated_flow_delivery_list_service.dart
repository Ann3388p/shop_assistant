import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_shoppping_viewmodel.dart';

import '../../ui/viewmodel/order_details_viewmodel.dart';
import '../models/api_response_model.dart';
import '../models/truncated_flow_delivery_model.dart';
import '../models/truncated_flow_shopping_list_model.dart';
import '../models/user_data_viewmodel.dart';
import 'api_handler.dart';
import 'navigation_service.dart';

class TruncatedFlowDeliveryListService{
  getTruncatedFlowDeliveryList(Map<String,dynamic> body)async{
    String query = r"""query($storeid : ID!){
  truncatedFlowDeliveryList(storeid:$storeid){
   id
    orderNumber
    totalPrice
    totalPriceDelivery
    deliveryAddress
    deliveryDate
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
    storeid{
      storeName
    }
    deliveryDate
    deliveryTime
    shopAssistantId{
      id
      firstName
    }
    deliveryPartnerId{
      id
      firstName
    }
    lastStatus
    paymentStatus
  }
}""";
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if (!result.haserror){
      List<TruncatedFlowOrderDetailsModel> ordersList =[];
      if(result.data!=null){
        result.data["truncatedFlowDeliveryList"].forEach((order)=>{
          ordersList.add(TruncatedFlowOrderDetailsModel.fromJson(order))
        });
      }
      return ApiResponse(haserror: false,data: ordersList,errormsg: '');
    }else{
      return result;
    }
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


  removeOrderFromAvailableList(BuildContext context, String? orderID){
    Provider.of<TruncatedFlowShoppingViewModel>(context,listen: false)
        .removeOrderFromAvailableList(orderID);
  }


}