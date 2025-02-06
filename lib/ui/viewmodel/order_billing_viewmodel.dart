import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/bill_amount_model.dart';
import 'package:shop_assistant/core/services/order_billing_services.dart';
import 'package:shop_assistant/ui/home_screen.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/custom_loader.dart';
import 'package:shop_assistant/ui/shared_widgets/dialog_box_options.dart';
import 'package:shop_assistant/ui/shared_widgets/show_toast.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shop_assistant/ui/views/order_billing_screen/order_billing.dart';
class OrderBillingViewModel with ChangeNotifier{

  int _stepperIndex=0;
  var _billAmount ='';
  File? _imageFile;
  get imageFile => _imageFile;
  get billAmount => _billAmount;
  bool isLoading = false;
  late ApiResponse getImageUrlResponse;
  late ApiResponse captureImageResponse;
  late ApiResponse uploadImageResponse;
  late ApiResponse shoppingCompleteResponse;
  late ApiResponse billAmountResponse;
  late BillAmountModel _billData;
  BillAmountModel get billData => _billData;
  OrderBillingServices _services = OrderBillingServices();
  set billAmount(var value){
    _billAmount = value;
    notifyListeners();
  }

 bool checkPaymentDone(){
    return _billData.paymentStatus==1;
  }
  bool checkFinalBillAmountIsSet(){
    return _billData.finalBillAmount>0;
  }
  getBillAmountFromServer(var orderId)async{
    isLoading = true;
    notifyListeners();
   Map<String,dynamic> body = {
     "orderid":orderId
   };
   billAmountResponse = await _services.getBillAmountFromServer(body);
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
  int get stepperIndex => _stepperIndex;
  set stepperIndex(int value){
    _stepperIndex = value;
    notifyListeners();
  }
  void nextStep(){
    if(_stepperIndex<2){
      stepperIndex+=1;
    }
  }
  void previousStep(){
    if(_stepperIndex!=0){
      stepperIndex-=1;
    }
  }
  confirmBillAmount({required var amount}){
    billAmount = amount;
    nextStep();
  }

  clearData(){
    _billAmount = '';
    _imageFile = null;
    _stepperIndex = 0;
  }
  uploadImage({required var orderID, required var imageUrl, required BuildContext context, required userID})async{
    print("update image called");
    Map<String,dynamic> body = {
        "orderid": "$orderID",
        "finalBill": "$imageUrl",
        "finalBillAmount": double.parse(_billAmount)
    };
    uploadImageResponse = await _services.uploadImage(body);
    if(!uploadImageResponse.haserror){
      shoppingComplete(userID: userID, orderID: orderID, context: context);
    }else{
      /// STOP THE LOADER
      Navigator.of(context).pop();
      Utils.errorDialog(context, uploadImageResponse.errormsg,heading: "Error");
    }
  }

  getImageUrl(BuildContext context, var orderID, var userID)async{
    var byteData = _imageFile!.readAsBytesSync();
    var multipartFile = MultipartFile.fromBytes(
        'photo',
        byteData,
      filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      contentType: MediaType("image","jpg"),
    );
    Map<String,dynamic> body = {
      "file": multipartFile,
      "type": 3,
      "orderid": orderID
    };
    /// LOADER STARTED AT THIS POINT
    /// STOP ONLY AT ERROR -- LET IT RUN UNTIL THE LAST API IS EXECUTED
    CustomLoader(context: context);
    getImageUrlResponse = await _services.getImageUrl(body);
    if(!getImageUrlResponse.haserror){
    uploadImage(orderID: orderID, imageUrl: getImageUrlResponse.data["addBillImageToS3"]["Location"], context: context, userID: userID);
    }else{
      /// STOP THE LOADER
      Navigator.of(context).pop();
      Utils.errorDialog(context, getImageUrlResponse.errormsg,heading: "Error");
    }
  }

  captureImage()async{
    captureImageResponse = await _services.captureImageFromCamera();
    if(!captureImageResponse.haserror){
      _imageFile = captureImageResponse.data;
    }
    notifyListeners();
  }

  showButtons({required BuildContext context,required var orderID,required var userID}){
    if(_imageFile!=null){
      return CommonPrimaryButton(
        title:"Upload Bill Image" ,
        onPressed: ()async=>getImageUrl(context, orderID, userID)
      );
    }
    return CommonPrimaryButton(
      title: "Capture Image",
      onPressed: ()=>captureImage(),
    );
  }

  shoppingComplete({required var userID,required var orderID,required BuildContext context})async{
    Map<String,dynamic> body = {
      "shopAssistantId": "$userID",
      "orderid": "$orderID",
      "stats":{
        "status":"Order-Ready"
      }
    };
    shoppingCompleteResponse = await _services.shoppingComplete(body,context);
    /// STOP THE LOADER -- THIS IS THE LAST API IN STACK
    Navigator.of(context).pop();
    if(!shoppingCompleteResponse.haserror){
      /// UPDATE SHOPPING AND DELIVERY COUNT IN HOME SCREEN
      //_services.removeShoppingAddDeliveryCount(context);
      DialogBoxOptions(context: context, heading: '',
          message: "Do you want to accept the delivery of this order?",
      onPositive: ()async{
        Map<String,dynamic> body ={
          "deliveryPartnerId": userID,
          "orderId": orderID
        };
        ApiResponse response = await _services.addOrderToDelivery(context,body);
        if(!response.haserror){
          ShowToast(context, "Order added to delivery order list");
          clearData();
          // Navigator.of(context)..pop()..pop();
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>HomeScreen()), (route) => false);
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true)));
        }else{
          Utils.errorDialog(context, response.errormsg,heading: "Error",onPressed: (){
            ShowToast(context, "Order marked as ready for delivery ");
            clearData();
            // Navigator.of(context)..pop()..pop();
            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>HomeScreen(showDialog: true)), (route) => false);
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true)));

          });
        }
      },
        onNegative: (){
          ShowToast(context, "Order marked as ready for delivery ");
          clearData();
          // Navigator.of(context)..pop()..pop();
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>HomeScreen(showDialog: true)), (route) => false);
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true)));
      }
      );

     // _services.removeOrderFromAssignedList(context, orderID);
      ShowToast(context, "Order marked as ready for delivery ");
      clearData();
      // Navigator.of(context)..pop()..pop();
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>HomeScreen(showDialog: true)), (route) => false);
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true)));
    }else{
      Utils.errorDialog(context, shoppingCompleteResponse.errormsg,heading:"Error");
    }
  }

  navigateTOBillingScreen(BuildContext context, var orderId)async{
    await getBillAmountFromServer(orderId);
    if(!billAmountResponse.haserror){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderBillingScreen()));
    }else{
      Utils.errorDialog(context, billAmountResponse.errormsg,heading:"Error");
    }
  }
  removeBillImage(BuildContext context){
    DialogBoxOptions(context: context,
      heading: "Confirm",
      message: "Are you sure you want to remove the bill image?",
      onPositive: (){
      _imageFile = null;
      Navigator.pop(context);
      notifyListeners();
      }
    );
  }
}