import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/delivery_pending_services.dart';

class DeliveryPendingViewModel with ChangeNotifier{
  late ApiResponse deliveryPendingResponse;
  bool isLoading=true;
  List<OrderListModel>? _deliveryPendingList = [];
  DeliveryPendingServices _service = DeliveryPendingServices();
  get deliveryPendingList => _deliveryPendingList;
  getDeliveryPendingOrders(var shopAssistantId)async{
    Map<String,dynamic> body ={
      "shopAssistantId" : "$shopAssistantId"
    };
    isLoading = true;
    notifyListeners();
    deliveryPendingResponse = await _service.getDeliveryPendingOrderList(body);
    if(!deliveryPendingResponse.haserror){
      _deliveryPendingList = deliveryPendingResponse.data;
      //filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }
  /// Used in delivery details services to remove completed order from list
  removeOrderFromDeliveryPendingList(String? orderID){
    List<OrderListModel> _orderList = deliveryPendingResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        deliveryPendingResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}