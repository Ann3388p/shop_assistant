import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/models/truncated_flow_shopping_list_model.dart';


import '../../core/models/bill_amount_model.dart';
import '../../core/models/truncated_flow_delivery_model.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/truncated_flow_shopping_list_service.dart';
import '../shared_widgets/common_primary_button.dart';
import '../shared_widgets/custom_loader.dart';
import '../shared_widgets/dialogs.dart';
import '../shared_widgets/show_toast.dart';
import '../shared_widgets/utils.dart';

class TruncatedFlowShoppingViewModel with ChangeNotifier {

  late ApiResponse rejectOrderResponse;
  bool buttonIsLoading = false;
  late ApiResponse acceptOrderResponse;

  late ApiResponse billAmountResponse;

  late ApiResponse shoppingOrderResponse;

  var _orderID;

  bool buttonLoadingShopping = false;


  var _billAmount ='';
  get billAmount => _billAmount;

  set billAmount(var value){
    _billAmount = value;
    notifyListeners();
  }

 /* late TruncatedFlowOrderDetailsModel _orderData;


  TruncatedFlowOrderDetailsModel get orderData => _orderData;*/

  get orderID => _orderID;

  set orderID(var value){

    _orderID = value;

  }

  //late TruncatedFlowShopAssistantModel _shoppingOrderData;
  List<TruncatedFlowOrderDetailsModel> _shoppingOrderData = [];


  late ApiResponse availableOrdersResponse;
  late BillAmountModel _billData;

  bool isLoading = true;

  TruncatedFlowShoppingListService _service = TruncatedFlowShoppingListService();

  List<TruncatedFlowOrderDetailsModel> get shoppingOrderData => _shoppingOrderData;

  TruncatedFlowOrderDetailsModel truncatedOrderData = TruncatedFlowOrderDetailsModel();




  getBillAmountFromServer(var orderId)async{
    isLoading = true;
    notifyListeners();
    Map<String,dynamic> body = {
      "orderid":orderId
    };

    billAmountResponse = await _service.getBillAmountFromServer(body);
    if(!billAmountResponse.haserror){
      _billData = billAmountResponse.data;
      if(_billData.finalBillAmount > 0){
        _billAmount = "${_billData.finalBillAmount}";
      }else{
        _billAmount = billAmountResponse.data.billAmount.toString();
      }
    }
    isLoading = false;
    notifyListeners();
  }

  confirmBillAmount({required var amount}){
    billAmount = amount;

  }

  getAvailableOrders(var storeID)async{
    Map<String,dynamic> body ={
      "storeid" : "$storeID"
    //"storeid" : "60d6deff0add183acea17640"
    };
    isLoading = true;
    notifyListeners();
    availableOrdersResponse = await _service.getTruncatedFlowShoppingList(body);
    if(!availableOrdersResponse.haserror){
     // _orderData = availableOrdersResponse.data;
      /*truncatedOrderData = availableOrdersResponse.data;
      print(truncatedOrderData.products);*/
      _shoppingOrderData = availableOrdersResponse.data;
      // if(checkOrderHasStartedShopping()){
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShoppingScreen(orderDetailsResponse.data)));
      // }
    }
    isLoading = false;
    notifyListeners();
  }

  acceptOrder({required var userID,required var orderID,required BuildContext context})async{
    buttonIsLoading = true;
    notifyListeners();
    Map<String,dynamic> body ={
      "shopAssistantId": "$userID",
      "orderid": "$orderID",
      "stats":{
        "status":"Order-Accepted"
      }
    };
    acceptOrderResponse = await _service.acceptOrder(body,context);
    buttonIsLoading = false;
    notifyListeners();
    if(!acceptOrderResponse.haserror){
      _service.removeOrderFromAvailableList(context, orderID);

      ShowToast(context, "Order added to assigned order list");

    }
    else
    {
      Utils.errorDialog(context, acceptOrderResponse.errormsg,heading:"Error");


    }
  }

  rejectOrder(BuildContext context, var shopAssistantID, var orderID)async{
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
  }

  changeToShopping({required var orderId, required BuildContext context})async{
    buttonLoadingShopping = true;
    notifyListeners();
    Map<String,dynamic> body = {
      "orderid": orderId
    };
    shoppingOrderResponse = await _service.changeOrderStatusToShopping(body,context);
    if(!shoppingOrderResponse.haserror){
      //await deliveryComplete(userID: userID, context: context,isShowDialog: false);
    }else{
      Utils.errorDialog(context,"${shoppingOrderResponse.errormsg}",heading: "Error");
    }
    buttonLoadingShopping = false;
    notifyListeners();
  }

  removeOrderFromAvailableList(String? orderID){
    List<TruncatedFlowOrderDetailsModel> _orderList = availableOrdersResponse.data;
    for(int i=0;i<_orderList.length;i++){
      if(_orderList[i].id==orderID){
        availableOrdersResponse.data.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
}