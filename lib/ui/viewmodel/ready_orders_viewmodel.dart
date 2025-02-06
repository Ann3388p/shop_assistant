import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/ready_order_services.dart';
import 'package:shop_assistant/core/services/ready_order_services.dart';

class ReadyOrdersViewModel with ChangeNotifier{
  late ApiResponse readyOrderResponse;
  bool isLoading=false;
  List<OrderListModel>? _readyOrderList = [];
  ReadyOrderServices _service = ReadyOrderServices();
  get readyOrderList => _readyOrderList;
  getReadyOrders(var userID)async{
    Map<String,dynamic> body ={
      "shopAssistantId" : "$userID"
    };
    isLoading = true;
    notifyListeners();
    readyOrderResponse = await _service.getreadydOrderList(body);
    if(!readyOrderResponse.haserror){
      _readyOrderList = readyOrderResponse.data;
      //filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }
/// Used in delivery details services to remove completed order from list
  removeOrderFromReadyList(String? orderID){
    List<OrderListModel> _orderList = readyOrderResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        readyOrderResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}