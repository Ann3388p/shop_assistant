import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/assigned_order_services.dart';

class AssignedOrderViewModel with ChangeNotifier{
  late ApiResponse assignedOrdersResponse;
  bool isLoading=true;
  List<OrderListModel> _assignedOrderList = [];
  AssignedOrderServices _service = AssignedOrderServices();
  get assignedOrderList => _assignedOrderList;
  getAssignedOrders(var userID)async{
    _assignedOrderList =[];
    Map<String,dynamic> body ={
      "shopAssistantId" : "$userID"
    };
    isLoading = true;
    notifyListeners();
    assignedOrdersResponse = await _service.getAssignedOrderList(body);
    if(!assignedOrdersResponse.haserror){
      filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }
  /// TO REMOVE COMPLETED ORDERS AND READY ORDERS
 filterAssignedOrders(){
  List<OrderListModel> _orderList = assignedOrdersResponse.data;
  _orderList.forEach((order) {
    if(order.lastStatus == "Order-Accepted" || order.lastStatus =="Shopping-In-Progress"){
      _assignedOrderList.add(order);
    }
  });
 }
  removeOrderFromAssignedList(String orderID){
    List<OrderListModel> _orderList = assignedOrdersResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        assignedOrdersResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
  clearData(){
    _assignedOrderList = [];
  }
}