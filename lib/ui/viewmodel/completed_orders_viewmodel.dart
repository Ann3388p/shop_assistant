import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/completed_order_list_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/completed_order_services.dart';

class CompletedOrdersViewModel with ChangeNotifier{
  late ApiResponse completedOrderResponse;
  late ApiResponse moreCompletedOrderResponse;
  bool isLoading=false;
  int _count = 10;
  int _offset = 10;
  int get offset => _offset;
  bool _showLoader = false;
  bool get showLoader => _showLoader;
  List<OrderListModel>? _completedOrderList = [];
  CompletedOrderServices _service = CompletedOrderServices();
  List<OrderListModel>? get completedOrderList => _completedOrderList;
  _resetCount(){
    _count = 10;
    _offset = 10;
  }
  getCompletedOrders(var userID)async{
    _resetCount();
    _completedOrderList =[];
    Map<String,dynamic> body ={
      "pagination": {
        "offset": 0,
        "first": 10
      },
      "shopAssistantId" : "$userID"
    };
    isLoading = true;
    notifyListeners();
    completedOrderResponse = await _service.getCompletedOrderList(body);
    if(!completedOrderResponse.haserror){
      _completedOrderList = completedOrderResponse.data.items;
      //filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }
  updateCompleteOrderList(CompletedOrderListModel data){
    _completedOrderList!.addAll(data.items!);
    //notifyListeners();
  }
  getMoreCompletedOrder(var userID)async{
    _showLoader=true;
    notifyListeners();
    Map<String,dynamic> body ={
      "pagination": {
        "offset": _offset,
        "first": _count
      },
      "shopAssistantId" : "$userID"
    };
    moreCompletedOrderResponse = await _service.getCompletedOrderList(body);
    if(!moreCompletedOrderResponse.haserror){
      _offset+=10;
      updateCompleteOrderList(moreCompletedOrderResponse.data);
    }
    _showLoader = false;
    notifyListeners();
  }

}