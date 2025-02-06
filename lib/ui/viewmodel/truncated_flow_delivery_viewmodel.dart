import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/models/truncated_flow_shopping_list_model.dart';


import '../../core/models/truncated_flow_delivery_model.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/truncated_flow_delivery_list_service.dart';
import '../../core/services/truncated_flow_shopping_list_service.dart';
import '../shared_widgets/custom_loader.dart';
import '../shared_widgets/dialogs.dart';
import '../shared_widgets/show_toast.dart';
import '../shared_widgets/utils.dart';

class TruncatedFlowDeliveryViewModel with ChangeNotifier {
  /* late ApiResponse assignedOrdersResponse;
  bool isLoading = true;
  List<TruncatedFlowShopAssistantModel> _assignedOrderList = [];
  TruncatedFlowShoppingListService _service = TruncatedFlowShoppingListService();

  get assignedOrderList => _assignedOrderList;

  getAssignedOrders(var userID) async {
    _assignedOrderList = [];
    Map<String, dynamic> body = {
     // "shopAssistantId": "$userID"
    };
    isLoading = true;
    notifyListeners();
    assignedOrdersResponse = await _service.getTruncatedFlowShoppingList(body);
    if (!assignedOrdersResponse.haserror) {
      //filterAssignedOrders();
    }
    isLoading = false;
    notifyListeners();
  }*/
  bool isLoading = true;
  late ApiResponse viewOrderResponse;
  bool buttonIsLoading = false;
  //late ApiResponse acceptOrderResponse;
  var _orderID;


  get orderID => _orderID;

  set orderID(var value){
    _orderID=value;
  }

  //late TruncatedFlowShopAssistantModel _shoppingOrderData;
  List<TruncatedFlowOrderDetailsModel> _deliveryOrderData = [];


  late ApiResponse deliveryOrdersResponse;

  //bool isLoading = true;

  TruncatedFlowDeliveryListService _service = TruncatedFlowDeliveryListService();

  List<TruncatedFlowOrderDetailsModel> get deliveryOrderData => _deliveryOrderData;


  getDeliveryOrders(var storeID) async
  {

    Map<String,dynamic> body ={
      "storeid" : "$storeID"
      //"storeid" : "60d6deff0add183acea17640"
    };
    isLoading = true;
    notifyListeners();
    deliveryOrdersResponse = await _service.getTruncatedFlowDeliveryList(body);
    isLoading = false;
    notifyListeners();

    if(!deliveryOrdersResponse.haserror)
    {

      _deliveryOrderData = deliveryOrdersResponse.data;
      // if(checkOrderHasStartedShopping()){
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShoppingScreen(orderDetailsResponse.data)));
      // }
    }


   // isLoading = false;
    notifyListeners();
  }




  /*rejectOrder(BuildContext context, var shopAssistantID, var orderID)async{
    // CustomLoader(context: context);
    Dialogs.showRejectionReasonDialog(
        NavigationService.navigatorKey.currentContext!,
        onConfirm: (reason) async {
          CustomLoader(context: context);
          Map<String, dynamic> body = {
            "orderid": orderID,
            "shopAssistantId":shopAssistantID,
            "commentsSeller" : reason,
            "stats":{
              "status":"Order-Rejected"
            }
          };
          rejectOrderResponse = await _service.updateOrderStatusWithComment(body);
          CustomLoader.close(context);
          if(!rejectOrderResponse.haserror){
            _service.removeOrderFromAvailableList(NavigationService.navigatorKey.currentContext!, orderID);
            ShowToast(NavigationService.navigatorKey.currentContext!,"Order status changed to rejected");
            Navigator.of(NavigationService.navigatorKey.currentContext!)..pop()..pop();
          }else{
            Utils.errorDialog(NavigationService.navigatorKey.currentContext!, rejectOrderResponse.errormsg);
          }
        });
  }*/

  removeOrderFromAvailableList(String? orderID){
    List<TruncatedFlowShopAssistantModel> _orderList = deliveryOrdersResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        deliveryOrdersResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}