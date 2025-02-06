import 'package:flutter/foundation.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/available_order_services.dart';

class AvailableOrdersViewModel with ChangeNotifier{
 late ApiResponse availableOrdersResponse;
 bool isLoading=true;
 AvailableOrderServices _service = AvailableOrderServices();
  getAvailableOrders(var storeID)async{
    Map<String,dynamic> body ={
      "storeid" : "$storeID"
    };
    isLoading = true;
    notifyListeners();
   availableOrdersResponse = await _service.getAvaialbleOrderList(body);
   isLoading = false;
   notifyListeners();
 }

 removeOrderFromAvailableList(String? orderID){
    List<OrderListModel> _orderList = availableOrdersResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        availableOrdersResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
 }
}