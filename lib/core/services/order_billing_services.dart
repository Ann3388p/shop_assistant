import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/bill_amount_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/api_handler.dart';
import 'package:shop_assistant/core/services/order_details_services.dart';
import 'package:shop_assistant/ui/shared_widgets/dialog_box_options.dart';
import 'package:shop_assistant/ui/viewmodel/assigned_order_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';

class OrderBillingServices {

  getBillAmountFromServer(Map<String,dynamic> body)async{
    String query =r'''query($orderid:ID!){
                      viewOrder(orderid:$orderid){
                       id
                       totalPrice
                       paymentStatus
                       finalBillAmount
                      }                    
                    }  ''';
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if(!result.haserror){
      final data = BillAmountModel.fromJson(result.data);
      return ApiResponse(haserror: false,data: data,errormsg: '');
    }
    return result;
  }

  getImageUrl(Map<String,dynamic> body) async {
    String query = r'''mutation($file: Upload,$type: Int, $orderid:String) {
                  addBillImageToS3(file: $file,type:$type,orderid:$orderid) {
                  ETag
                  Location
                  Key
                  Bucket
                          }
                      } ''';
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    return result;
  }

  uploadImage(Map<String,dynamic> body) async {
    String query = r''' 
mutation($orderid:ID!,$finalBill:String!,$finalBillAmount:Float!){
  addBillAndAmount(
    orderid:$orderid,
    finalBill:$finalBill,
    finalBillAmount:$finalBillAmount){
    id
    orderNumber
    finalBill
    finalBillAmount
  }
}
''';
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    return result;
  }

  addOrderToDelivery(BuildContext context,Map<String,dynamic> body)async{
   OrderDetailsService _service = OrderDetailsService();
    ApiResponse result = await _service.acceptDeliveryOrder(context,body);
    return result;
  }
  captureImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? file = await _picker.pickImage(
          maxWidth: 640,
          maxHeight: 480,
          source: ImageSource.camera);
      File _imageFile = File(file!.path);
      return ApiResponse(haserror: false,data: _imageFile,errormsg: '');
    }catch(err){
      print(err.toString());
      return ApiResponse(haserror: true,errormsg: err.toString());
    }
  }

  shoppingComplete( Map<String,dynamic> body, BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats){
    id
  }
} """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      OrderDetailsService().scheduleAlert(context, status: body["stats"]["status"]);
    }
    return result;
  }

  removeOrderFromAssignedList(BuildContext context, String orderID){
    Provider.of<AssignedOrderViewModel>(context,listen: false)
        .removeOrderFromAssignedList(orderID);
  }

  removeShoppingAddDeliveryCount(BuildContext context){
    Provider.of<UserDataViewModel>(context,listen: false).decrememtShoppingCount();
    Provider.of<UserDataViewModel>(context,listen: false).incrementDeliveryCount();
  }
}