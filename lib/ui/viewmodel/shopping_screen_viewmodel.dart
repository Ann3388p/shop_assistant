import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/services/shopping_screen_services.dart';
import 'package:shop_assistant/ui/views/order_billing_screen/order_billing.dart';

import '../../core/services/api_handler.dart';
import '../../core/services/order_details_services.dart';
import '../home_screen.dart';
import '../shared_widgets/show_toast.dart';
import '../shared_widgets/utils.dart';

class ShoppingScreenViewModel with ChangeNotifier{

  int _todo = 0;
  int _review = 0;
  int _done = 0;
  bool isLoading = true;
  get todo => _todo;
  get done => _done;
  get review => _review;
   OrderDetailsModel? orderDetails;
  List<Products>? _productData;
  List<Products>?get productData => _productData;
 // ApiResponse? shoppingCompleteResponse;
  //ApiResponse? orderDetailsResponse;
  ApiResponse? outOfStockResponse;
  ShoppingScreenServices _services = ShoppingScreenServices();
//   getProducts()async{
//   productsResponse = await _services.getProducts();
// }
  setOrderDetails(OrderDetailsModel? data){
    orderDetails = data;
  }
  setProductData(List<Products>? data){
    _productData = data;
    calculateItemsInEachStatus();
  }

  calculateItemsInEachStatus(){
    int todo = 0;
    int review = 0;
    int done = 0;
    _productData!.forEach((value) {
      if(value.status == 0) {todo+=1;}else
      if(value.status ==1 || value.status== 3){review+=1;}else
      if(value.status == 2){done+=1;}
    });
   _todo = todo;
   _review = review;
   _done = done;
   notifyListeners();
  }
  showTextOnComplete(BuildContext context){
    if( _review == 0){
      return Center(
          child: Text("Click shopping complete option on done to complete the process",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,color: Colors.black54),),
      );
    }
    return Center(
      child: Text("Confirm changes on review to complete the process",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20)
      ),
    );
  }

  changeProductStatus(Map<String,dynamic> body){
    print("shopping viewmodel");
    for(int i=0;i<_productData!.length;i++){
      if(_productData![i].id == body['products']['id']){
        print('match found');
        _productData![i].status = body['products']['status'];
        _productData![i].price = body['products']['price'];
        _productData![i].shopAssistantQuantity = body['products']['shopAssistantQuantity'];
        calculateItemsInEachStatus();
        break;
      }
    }
  }

  checkAtLeastSingleProductIsAvailable(){
    int _count =0;
    for(int i = 0; i<_productData!.length; i++){
      print("Quantity ====> ${_productData![i].shopAssistantQuantity}");
      if(_productData![i].shopAssistantQuantity == 0){
        _count++;
      }
    }
    if(_count != _productData!.length)
      return true;
    return false;
  }

  markOrderAsOutOfStock({required var userID, required BuildContext context}) async {
    Map<String,dynamic> body = {
      "shopAssistantId": "$userID",
      "orderid": "${orderDetails!.id}",
      "stats":{
        "status":"Order-Rejected"
      },
      "commentsSeller":"Order cancelled due to unavailability of product"
    };
    outOfStockResponse = await _services.orderCancelledDueToOutOfStock(body, context);
    if(!outOfStockResponse!.haserror){
      ShowToast(context, "Order marked as out of stock");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true,)), (route) => false);
    }else{
      Utils.errorDialog(context, outOfStockResponse!.errormsg,heading:"Error");
    }
  }



  // shoppingComplete({@required var userID,@required var orderID,@required BuildContext context})async{
  //   CustomLoader(context: context);
  //   Map<String,dynamic> body ={
  //     "shopAssistantId": "$userID",
  //     "orderid": "$orderID",
  //     "stats":{
  //       "status":"Order-Ready"
  //     }
  //   };
  //   shoppingCompleteResponse = await _services.shoppingComplete(body);
  //   Navigator.of(context).pop();
  //   if(!shoppingCompleteResponse.haserror){
  //     _services.removeOrderFromAssignedList(context, orderID);
  //     ShowToast(context, "Order added to orders to be billed list");
  //     Navigator.of(context).pop();
  //   }else{
  //     Utils.errorDialog(context, shoppingCompleteResponse.errormsg,heading:"Error");
  //   }
  // }


}