import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/delivery_new_services.dart';

class DeliveryNewOrdersViewModel with ChangeNotifier{
  late ApiResponse deliveryNewOrderResponse;
  bool isLoading=true;
  List<OrderListModel>? _deliveryNewOrderList = [];
  DeliveryNewServices _service = DeliveryNewServices();
  get deliveryNewOrderList => _deliveryNewOrderList;
  getDeliveryNewOrders(var storeID)async{
    Map<String,dynamic> body ={
      "storeid" : "$storeID"
    };
    isLoading = true;
    notifyListeners();
    deliveryNewOrderResponse = await _service.getDeliveryNewOrderList(body);
    if(!deliveryNewOrderResponse.haserror){
      _deliveryNewOrderList = deliveryNewOrderResponse.data;
      //filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }
  /// Used in delivery details services to remove completed order from list
  removeOrderFromDeliveryNewList(String? orderID){
    List<OrderListModel> _orderList = deliveryNewOrderResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        deliveryNewOrderResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}