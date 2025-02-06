import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/extensions/extensions.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/models/travel_time_and_distance_model.dart';
import 'package:shop_assistant/core/services/api_handler.dart';
import 'package:shop_assistant/core/services/navigation_service.dart';
import 'package:shop_assistant/core/services/order_details_services.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/custom_loader.dart';
import 'package:shop_assistant/ui/shared_widgets/dialog_box_options.dart';
import 'package:shop_assistant/ui/shared_widgets/dialogs.dart';
import 'package:shop_assistant/ui/shared_widgets/error_dialog_box.dart';
import 'package:shop_assistant/ui/shared_widgets/payment_verification_dialog.dart';
import 'package:shop_assistant/ui/shared_widgets/show_toast.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/views/shopping_screen.dart';

import '../../core/models/order_list_model.dart';
import '../../core/models/order_ready_model.dart';

import '../../core/models/user_data_viewmodel.dart';
import '../home_screen.dart';
import '../views/truncated_flow/order_details.dart';
import 'criticalOrder.dart';

class OrderDetailsViewModel with ChangeNotifier{
  bool isLoading = true;
  bool buttonIsLoading = false;
  bool IsLoadingTruncate = false;
  var _orderID;
  bool deliveryButtonLoading = false;
  late OrderDetailsModel _orderData = OrderDetailsModel();

  bool buttonLoadingShopping = false;

  int? qty;

  bool clicked = false;

  bool isShowDailog = true;

  // Products? _productData;

  int count = 0;
  List<bool> checkboxStates = [];
  bool isSelected = true;

   List<bool> isSelectedd = [];


  bool isShopping = true;
  bool isShoppingbillAmt = true;
  int productsCount = 0;

  //  int get productsCount => _productsCount;

  TextEditingController amountController = TextEditingController();

  var selectedQuantity;

  late ApiResponse orderDetailsResponse;
  late ApiResponse acceptOrderResponse;
  late ApiResponse startShoppingResponse;
  late ApiResponse completeOrderResponse;

  late ApiResponse shoppingOrderResponse;

  late ApiResponse completeOrderTruncatedResponse;
  late ApiResponse paymentStatusResponse;
  late ApiResponse paymentToCashResponse;

  late ApiResponse paymentToCashTruncatedResponse;

  late ApiResponse addToDeliveryResponse;
  late ApiResponse rejectOrderResponse;
  late ApiResponse travelTimeAndDistanceResponse;
  late ApiResponse updateEstimatedDeliveryTimeResponse;

  late ApiResponse orderReadyResponse;
  late ApiResponse orderCompleteResponse;

  late ApiResponse shopppingOrderResponse;
  late ApiResponse shopppingOrderBillAmtResponse;
  bool paymentVerificationLoading = false;
  int? _paymentStatus =0;
  get paymentStatus => _paymentStatus;
  OrderDetailsService _service = OrderDetailsService();
  CriticalOrderRemove criticalOrderRemove = CriticalOrderRemove();

  int? orderDataLength;

  List<bool> checkboxValues = [];
  List<Color> cardColors = [];



  List<bool>? isSelectedCheckBox = [];
  int? dataIndex;

  int? productCount;

  List?  productCounts;
  //int totalBillAmount = 0;

  //List<bool>? isSelected;
  int? billAmount = 0;

  List<int> totalBillAmount = [];

  var finalTotalAmount;
  //Products? get productData => _productData;

  OrderDetailsModel get orderData => _orderData;
  get orderID => _orderID;
  set orderID(var value){
    _orderID=value;
  }

  /*setProductData(Products data){
    _productData = data;
  }*/


  void cleardata(){
    amountController.clear();
    count = 0;
  }



  getOrderDetails(BuildContext context, var orderID)async{

    Map<String, dynamic> body ={
      "orderid" : "$orderID"
    };
    isLoading = true;
    notifyListeners();
    orderDetailsResponse = await _service.getOrderDetails(body);
    if(!orderDetailsResponse.haserror){

      _orderData = orderDetailsResponse.data;

      print(_orderData);


      // if(checkOrderHasStartedShopping()){
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShoppingScreen(orderDetailsResponse.data)));
      // }
    }
    isLoading = false;
    notifyListeners();
    orderDataLength = orderData.products!.length;
  }


  checkOrderHasStartedShopping(){
    OrderDetailsModel _data = orderDetailsResponse.data;
    print("last status is ${_data.lastStatus}");
    if(_data.lastStatus == "Shopping-In-Progress"){
      return true;
    }else{
      return false;
    }
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
      Navigator.of(context).pop();
    }else{
      Utils.errorDialog(context, acceptOrderResponse.errormsg,heading:"Error");
    }
  }

  startShopping({required var userID,required var orderID,required BuildContext context})async{
    buttonIsLoading = true;
    notifyListeners();
    Map<String,dynamic> body ={
      "shopAssistantId": "$userID",
      "orderid": "$orderID",
      "stats":{
        "status":"Shopping-In-Progress"
      }
    };
    startShoppingResponse = await _service.startShopping(body,context);
    buttonIsLoading = false;
    notifyListeners();
    if(!startShoppingResponse.haserror){
      //ShowToast(context, "Order added to assigned order list");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>ShoppingScreen(orderDetailsResponse.data,false)));
    }else{
      Utils.errorDialog(context, startShoppingResponse.errormsg,heading:"Error");
    }
  }



  deliveryComplete({required var userID,required BuildContext context, required bool isShowDialog})async{
    buttonIsLoading = true;
    notifyListeners();
    Map<String,dynamic> body ={
      "shopAssistantId": "$userID",
      "orderid": _orderID,
      "stats":{
        "status":"Completed"
      }
    };
    completeOrderResponse = await _service.updateStatus(body,context);
    buttonIsLoading = false;
    isShowDialog = false;
    notifyListeners();
    if(!completeOrderResponse.haserror){
      // _service.removeOrderFromDeliveryPendingList(context, orderID);
      ShowToast(context, "Order added to order historyyyyy");
      Navigator.of(context)..pop()..pop();
    }else{
      Utils.errorDialog(context, completeOrderResponse.errormsg,heading:"Error");
    }
  }


  deliveryCompleteFromTruncatedFlow({required var userID,required BuildContext context})async{
    print("truncated flow 1");
    buttonIsLoading = true;
    notifyListeners();
    Map<String,dynamic> body ={
      "shopAssistantId": "$userID",
      "orderid": _orderID,
      "stats":{
        "status":"Completed"
      }
    };
    print("truncated flow 2");
    completeOrderTruncatedResponse = await _service.updateStatus(body,context);
    buttonIsLoading = false;
    notifyListeners();
    if(!completeOrderTruncatedResponse.haserror){
      //removeOrderFromDeliveryList(orderID);
      // _service.removeOrderFromShoppingList(context, orderID);
      print("truncated flow 3");
      ShowToast(context, "Order added to order history");
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(isShowDialog: false,)));
      // Navigator.of(context)..pop()..pop();
      // Navigator.of(context).pop();
    }else{
      Utils.errorDialog(context, completeOrderTruncatedResponse.errormsg,heading:"Error");
    }
  }



  rejectOrder(BuildContext context, var shopAssistantID)async{
    // CustomLoader(context: context);
    Dialogs.showRejectionReasonDialog(
        NavigationService.navigatorKey.currentContext!,
        onConfirm: (reason) async {
          CustomLoader(context: context);
          Map<String, dynamic> body = {
            "orderid": "${_orderData.id}",
            "shopAssistantId":shopAssistantID,
            "commentsSeller" : reason,
            "stats":{
              "status":"Order-Rejected"
            }
          };
          rejectOrderResponse = await _service.updateOrderStatusWithComment(body);
          CustomLoader.close(context);
          if(!rejectOrderResponse.haserror){
            // _service.removeOrderFromAvailableList(NavigationService.navigatorKey.currentContext!, _orderData.id);
            ShowToast(NavigationService.navigatorKey.currentContext!,"Order status changed to rejected");
            Navigator.of(NavigationService.navigatorKey.currentContext!)..pop()..pop();
          }else{
            Utils.errorDialog(NavigationService.navigatorKey.currentContext!, rejectOrderResponse.errormsg);
          }
        });
  }
  rejectOrderBillAmt(BuildContext context, var shopAssistantID)async{
    // CustomLoader(context: context);
    Dialogs.showRejectionReasonDialog(
        NavigationService.navigatorKey.currentContext!,
        onConfirm: (reason) async {
          CustomLoader(context: context);
          Map<String, dynamic> body = {
            "orderid": "${_orderData.id}",
            "shopAssistantId":shopAssistantID,
            "commentsSeller" : reason,
            "stats":{
              "status":"Order-Rejected"
            }
          };
          rejectOrderResponse = await _service.updateOrderStatusWithComment(body);
          CustomLoader.close(context);
          if(!rejectOrderResponse.haserror){
            // _service.removeOrderFromAvailableList(NavigationService.navigatorKey.currentContext!, _orderData.id);
            ShowToast(NavigationService.navigatorKey.currentContext!,"Order status changed to rejected");
            Navigator.of(NavigationService.navigatorKey.currentContext!)..pop()..pop();
            Navigator.of(NavigationService.navigatorKey.currentContext!)..pop();
          }else{
            Utils.errorDialog(NavigationService.navigatorKey.currentContext!, rejectOrderResponse.errormsg);
          }
        });
  }

  showProductQuantity(){
    OrderDetailsModel? _orderdata = orderDetailsResponse.data;

  }

  getPaymentStatus(BuildContext context)async{
    paymentVerificationLoading = true;
    notifyListeners();
    Map<String,dynamic> body = {
      "orderid": _orderID
    };
    paymentStatusResponse = await _service.getPaymentStatus(body);
    if(!paymentStatusResponse.haserror){
      _paymentStatus = paymentStatusResponse.data.paymentStatus;
    }else{
      Utils.errorDialog(context, "${paymentStatusResponse.errormsg}", heading: "Error");
    }
    paymentVerificationLoading = false;
    notifyListeners();
  }

  changePaymentToCash({required var userID, required BuildContext context})async{
    deliveryButtonLoading = true;
    notifyListeners();
    Map<String,dynamic> body = {
      "orderid": _orderID
    };
    paymentToCashResponse = await _service.changePaymentToCash(body);
    if(!paymentToCashResponse.haserror){
      await deliveryComplete(userID: userID, context: context,isShowDialog: false);
    }else{
      Utils.errorDialog(context,"${paymentToCashResponse.errormsg}",heading: "Error");
    }
    deliveryButtonLoading = false;
    notifyListeners();
  }

  changePaymentToCashTruncatedFlow({required var userID, required BuildContext context})async{
   /* deliveryButtonLoading = true;
    notifyListeners();*/
    Map<String,dynamic> body = {
      "orderid": _orderID
    };
    paymentToCashTruncatedResponse = await _service.changePaymentToCash(body);
    if(!paymentToCashTruncatedResponse.haserror){
      await deliveryCompleteFromTruncatedFlow(userID: userID, context: context);
    }else{
      Utils.errorDialog(context,"${paymentToCashResponse.errormsg}",heading: "Error");
    }
    deliveryButtonLoading = false;
    notifyListeners();
  }




  _getTravelTimeAndDistance() async {
    Map<String, dynamic> body = {
      "orderid":_orderID
    };
    CustomLoader(context: NavigationService.navigatorKey.currentContext);
    travelTimeAndDistanceResponse = await _service.getTravelTimeAndDistance(body);
    CustomLoader.close(NavigationService.navigatorKey.currentContext);
  }


  _setDeliveryTime() async {
    // showDatePicker(
    //     context: NavigationService.navigatorKey.currentContext!,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime.now(),
    //     lastDate: DateTime(2101),
    //     );
    int _travelTime = 30;
    await _getTravelTimeAndDistance();
    if(!travelTimeAndDistanceResponse.haserror){
      TravelTimeAndDistanceModel _travelDetails = travelTimeAndDistanceResponse.data;
      _travelTime = (_travelDetails.travelTime!.value/60).ceil();
    }
    print("${_orderData.travelTime!.value}");
    TimeOfDay _initialTime = TimeOfDay.now().addMinutes(_travelTime);
    //TimeOfDay _initialTime = TimeOfDay.now();
    TimeOfDay? _time = await showTimePicker(
        context:NavigationService.navigatorKey.currentContext!,
        initialTime: _initialTime,
        helpText: "Confirm estimated time of delivery"
    );
    // if(_time!=null){
    //   return true;
    // }
    // return false;
    return _time;
  }

  // updateEstimatedDeliveryTime(TimeOfDay time) async {
  //    final dateTime = DateTime.now().setTimeOfDay(time);
  //    Map<String, dynamic> body = {
  //      "orderid": _orderID,
  //      "estimatedDeliveryTime":dateTime.toUtc()
  //    };
  //    updateEstimatedDeliveryTimeResponse = await _service.updateEstimatedDeliveryTime(body);
  // }

  addToDelivery({required BuildContext context, required var userID})async
  {
    TimeOfDay? _estimatedTime = await _setDeliveryTime();
    if(_estimatedTime !=null){
      final _time = DateTime.now().setTimeOfDay(_estimatedTime);
      buttonIsLoading = true;
      notifyListeners();
      OrderDetailsModel _orderdata = orderDetailsResponse.data;
      Map<String,dynamic> body ={
        "deliveryPartnerId": userID,
        "orderId": _orderID,
        "estimatedDeliveryTime":"${_time.toUtc()}"
      };
      addToDeliveryResponse = await _service.acceptDeliveryOrder(context,body);
      buttonIsLoading = false;
      isShowDailog = false;
      notifyListeners();
      if(!addToDeliveryResponse.haserror){

          //await updateEstimatedDeliveryTime(_estimatedTime);
          ShowToast(context, "Order added to delivery list");
          _service.removeOrderFromDeliveryNewList(context, orderID);
          Navigator.of(context).pop();


      }
      else{
        Utils.errorDialog(context, addToDeliveryResponse.errormsg);
      }
    }

  }
  addToDeliveryTruncate({required BuildContext context, required var userID})async
  {
    TimeOfDay? _estimatedTime = await _setDeliveryTime();
    if(_estimatedTime !=null){
      final _time = DateTime.now().setTimeOfDay(_estimatedTime);
      buttonIsLoading = true;
      notifyListeners();
      OrderDetailsModel _orderdata = orderDetailsResponse.data;
      Map<String,dynamic> body ={
        "deliveryPartnerId": userID,
        "orderId": _orderID,
        "estimatedDeliveryTime":"${_time.toUtc()}"
      };
      addToDeliveryResponse = await _service.acceptDeliveryOrder(context,body);
      buttonIsLoading = false;
      isShowDailog = false;
      notifyListeners();
      if(!addToDeliveryResponse.haserror){
        // if(isVisibleTruncate== true && isVisibleTruncate != null)
        // {
        //   ShowToast(context, "Order added to delivery list test");
        //   Navigator.of(context)..pop()..pop();
        //   // Navigator.of(context).pop(_orderdata.estimatedDeliveryTime);
        //
        //
        //
        // }
        // else{
          //await updateEstimatedDeliveryTime(_estimatedTime);
          ShowToast(context, "Order added to delivery list");
          // _service.removeOrderFromDeliveryNewList(context, orderID);
          Navigator.of(context).pop();
        // }

      }
      else{
        Utils.errorDialog(context, addToDeliveryResponse.errormsg);
      }
    }

  }

  continueShopping({required var userID, required BuildContext context, required bool isShowDialog}){
    //lsd
    //print("${_orderData.shopAssistantId} id ==>${_orderData.shopAssistantId!.id} userid==>${userID}");
    if(_orderData.shopAssistantId !=null && _orderData.shopAssistantId!.id == userID ){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShoppingScreen(orderDetailsResponse.data,false)));
    }else{
      Utils.errorDialog(context,"Another shop assistant assigned for this order",heading: "Warning!");
    }
  }

  showButtonAccordingToView({required BuildContext context, required var userID}){
    OrderDetailsModel _orderdata = orderDetailsResponse.data;
    if(_orderdata.lastStatus == "Order-Placed"){
      return Container(
        child: Row(
          children: [
            Flexible(
              child: CommonPrimaryButton(
                  title: "Reject Order",
                  buttonColor: Colors.red,
                  onPressed: ()async => rejectOrder(context,userID)
              ),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: CommonPrimaryButton(
                  title: "Accept Order",
                  onPressed: ()async => acceptOrder(userID: userID, orderID: _orderdata.id, context: context)
              ),
            ),
          ],
        ),
      );
    }
    if(_orderdata.lastStatus == "Order-Accepted"){
      return CommonPrimaryButton(
          title: "Start Shopping",
          onPressed: ()async => startShopping(userID: userID, orderID: _orderdata.id, context: context)
      );
    }

    if(_orderData.lastStatus == "Shopping-In-Progress"){
      return CommonPrimaryButton(
          title: "Continue Shopping",
          onPressed: ()async => continueShopping(userID: userID, context: context,isShowDialog: false)
      );
    }
    if(_orderdata.lastStatus == "Order-Ready" && _orderdata.deliveryPartnerId == null){
      return CommonPrimaryButton(
        title: "Add to Delivery",
        onPressed: ()async => addToDelivery(context: context,userID: userID),
      );
    }
    if(_orderdata.lastStatus == "Order-Ready"){
      return CommonPrimaryButton(
          title: "Verify Payment",
          onPressed: ()async => PaymentVerificationDialog(context) //deliveryComplete(userID: userID, orderID: _orderdata.id, context: context)
      );
    }
    return Container();
  }

  changeStatusToOrderReady(BuildContext context) async{
    orderReadyResponse =  await _service.changeOrderStatusToReady(context,orderData.id,orderData.totalPrice);


    if(!orderReadyResponse.haserror){
      _service.removeOrderFromShoppingList(context, orderID);


      ShowToast(NavigationService.navigatorKey.currentContext!, "Order added to assigned Delivery list");
      //_service.scheduleAlert(context, status: )
      Navigator.of(NavigationService.navigatorKey.currentContext!)..pop()..pop();
      //Navigator.of(context).pop();
    }
    else
    {
      print(orderReadyResponse.data);
      /*Utils.errorDialog(
            context, orderReadyResponse.errormsg, heading: "Error");*/


    }

  }

  removeOrderFromAvailableList(String? orderID){
    TruncatedOrderStatusToReadyModel _orderList = orderReadyResponse.data;
    for(int i=0;i<_orderList.products!.length;i++){
      if(_orderList.products![i].id==orderID){
        orderReadyResponse.data.removeAt(i);
        break;
      }

    }
    notifyListeners();
  }

  removeOrderFromDeliveryList(String? orderID){
    TruncatedOrderStatusToReadyModel _orderList = orderCompleteResponse.data;
    for(int i=0;i<_orderList.products!.length;i++){
      if(_orderList.products![i].id==orderID){
        orderCompleteResponse.data.removeAt(i);
        break;
      }

    }
    notifyListeners();
  }


  /* assignOrderToReady(
      {required String orderID,
        required String productId,
        var productPrice,
        required int quantity,
        required int shopAssistantQuantity,
        required String price,
        required int status,
        required BuildContext context})
  async{
    await _service.changeOrderStatusToOrderReady(
        orderid: orderID,
        productid: productId,
        productPrice: productPrice,
        quantity: quantity,
        status: status,
        shopAssistantQuantity: shopAssistantQuantity,
        price: price);
  }*/



  updateOrderStatus({required var userID,required var orderID,required BuildContext context}) async{
    isShopping = true;
    notifyListeners();
    Map<String,dynamic> body ={
      "shopAssistantId": "$userID",
      "orderid": "$orderID",
      "stats":{
        "status":"Shopping-In-Progress"
      }
    };

    shopppingOrderResponse = await _service.acceptOrder(body, context);
    isShopping = false;
    notifyListeners();
    if(!shopppingOrderResponse.haserror){
      ShowToast(context, "Order added to assigned order list");

    }
    else{
      Utils.errorDialog(context, shopppingOrderResponse.errormsg,heading:"Error");
    }

  }





  calculateProductPrice( var productPrice, int shopAsstntQty)
  {



    //for(int i = 0 ; i < _orderData.products!.length; i++) {
    billAmount = int.parse(productPrice) * shopAsstntQty;

    //print("PRODUCT TOTAL PRICE ${element.totalProductPrice}");

    print("IM SHOP ASSISTANT $shopAsstntQty");
    print("modelhop asstnt quantity ${selectedQuantity}");


    print("PRODUCT PRICE==>${productPrice}");

    /* productPrice = billAmount;

     print("FINALBILLAMOUNT$productPrice");*/

    //print("PRODUCT PRICE==>${(_orderData.products![i].productPrice * shopAssistantQuantity)}");


    return billAmount;

    //}


  }



  /*calculateBillAmount(var productPrice){



    print("THIS IS INSIDE CALCULATE BILL AMNT");

    if(count != null)
    {

      print("PRODUCTLENGTH${_orderData.products!.length}");

      print("BILLAMOUNT HERE ==>$billAmount");



      finalTotalAmount =  billAmount! + calculateProductPrice(productPrice);

      print("FINAL TOTAL AMOUNT IS THIS:$finalTotalAmount");


      _orderData.totalPrice =  finalTotalAmount;

      print("BILL AMOUNT FINAL ${_orderData.totalPrice}");

      _orderData.totalPriceDelivery =  _orderData.totalPrice! + _orderData.deliveryCharge;

      print("TOTAL PRICE DELIVERY:${_orderData.totalPriceDelivery}");

      //billAmount = 0;

    }
    // shopAssistantQuantity = 0;

    notifyListeners();

  }*/



  /*calculateBillAmount(var productPrice){



    print("THIS IS INSIDE CALCULATE BILL AMNT");

    if(count != null)
    {

      print("PRODUCTLENGTH${_orderData.products!.length}");

      //billAmount = 0;





      finalTotalAmount = billAmount! + calculateProductPrice(productPrice);

      _orderData.totalPrice = finalTotalAmount;

      print("BILL AMOUNT FINAL ${_orderData.totalPrice}");

      _orderData.totalPriceDelivery =  _orderData.totalPrice! + _orderData.deliveryCharge;

      print("TOTAL PRICE DELIVERY:${_orderData.totalPriceDelivery}");

      //billAmount = 0;

    }
   // shopAssistantQuantity = 0;

    notifyListeners();

  }*/

  updateShopAsstQty(int shopAssistantQty){
    if(shopAssistantQty == selectedQuantity){
      shopAssistantQty = 0;
      notifyListeners();
    }
    else{
      shopAssistantQty = selectedQuantity;
    }

  }

  // calculateTotalBillAmount(int productPrice,int shopAssistantQty){
  //
  //
  //   print("SELECTED QUANTITY IS THIS==> $selectedQuantity");
  //   print("shopAssistantQty QUANTITY IS THIS==> $shopAssistantQty");
  //
  //
  //   // orderData.products!.forEach((element) {
  //   //   element.productPrice = })
  //
  //
  //     int total;
  //   print("INDEX length ${orderData.products!.length}");
  //   for( int i = 0; i < orderData.products!.length;i++) {
  //
  //      print("INDEX${orderData.products![i].productid!.productname}");
  //
  //      orderData.products![i].totalProductPrice = productPrice.toString() * shopAssistantQty;
  //      print("PRODUCT PRICE BASED ON INDEX===> ${orderData.products![i].totalProductPrice}");
  //
  //
  //   }
  //
  // }


  calculateBillAmount()
  {
    var total = 0.0;
    for(int i =0; i< orderData.products!.length; i++){
      print("price of product $i ==> ${orderData.products![i].productPrice}");
      var quantity = orderData.products![i].shopAssistantQuantity ?? orderData.products![i].quantity;
      total = total + double.parse(orderData.products![i].productPrice!.toString())*(quantity);
    }
    //update total price, total price delivery,
    orderData.totalPrice = total;

    print("ORDERDATA PRODUCT PRICE HERE${orderData.totalPrice}");
    print("DELIVERY CHARGE${orderData.deliveryCharge}");
    orderData.totalPriceDelivery = total + orderData.deliveryCharge - orderData.discountPrice;
    notifyListeners();
  }



  void _toggleCheckbox(int index) {

      isSelected = !isSelected;

  }



  void toggleCheckbox(int index) {

     isSelectedCheckBox = List<bool>.generate(orderData.products!.length, (index) => true);


     isSelectedCheckBox![index] = !isSelectedCheckBox![index];

    notifyListeners();
  }

  /*calculateBillAmount(var productPrice, int shopAssistantQty){
    print("FUNCTION CALLED   $shopAssistantQty");

    //  print("FUNCTION CALLED index   $index");

    int totalBillAmount = billAmount!;

    //  finalTotalAmount = totalBillAmount + billAmount!;


    print("PRODUCT bill PRICE==> $totalBillAmount");

    print("THIS IS INSIDE CALCULATE BILL AMNT $shopAssistantQty");

    if(shopAssistantQty != null)

    {

      print("PRODUCTLENGTH${_orderData.products!.length}");


      if(_orderData.products!.length == 1)
      {
        _orderData.totalPrice = calculateProductPrice(productPrice,shopAssistantQty);
      }



      else
      {


        print("SHOP ASS QTY:$shopAssistantQty");

        print("ORDERDATATOTALAMOUNT${orderData.totalAmount}");


          orderData.totalAmount = orderData.totalAmount + calculateProductPrice(productPrice, shopAssistantQty);


          orderData.totalPrice = orderData.totalAmount;


        //}


        // _orderData.totalPrice = totalAmount;

        //print("BILL AMOUNT FINAL here ${totalAmount}");

        print("BILL AMOUNT FINAL ${ _orderData.totalPrice}");




      }

      _orderData.totalPriceDelivery = _orderData.totalPrice! + _orderData.deliveryCharge;

      print("TOTAL PRICE DELIVERY:${_orderData.totalPriceDelivery}");


      //}

    }

    notifyListeners();



  }*/





  /*calculateBillAmount(var productPrice, int shopAssistantQty){
    print("FUNCTION CALLED   $shopAssistantQty");

  //  print("FUNCTION CALLED index   $index");

    int totalBillAmount = billAmount!;

    //  finalTotalAmount = totalBillAmount + billAmount!;


    print("PRODUCT bill PRICE==>$totalBillAmount");

    print("THIS IS INSIDE CALCULATE BILL AMNT $productsCount");

    if(productsCount != null)

    {

      print("PRODUCTLENGTH${_orderData.products!.length}");


      if(_orderData.products!.length == 1)
      {
        _orderData.totalPrice = calculateProductPrice(productPrice,shopAssistantQty);
      }



      else
      {


        print("SHOP ASS QTY:$shopAssistantQty");

        print("ORDERDATATOTALAMOUNT${orderData.totalAmount}");


     orderData.totalAmount = orderData.totalAmount + calculateProductPrice(productPrice, shopAssistantQty);
     orderData.totalPrice = orderData.totalAmount;




        //  orderData.totalAmount = totalAmount;

        // totalPriceOfAllProducts = orderData.totalAmount;


       // orderData.totalPrice = orderData.totalAmount;









        //}


        // _orderData.totalPrice = totalAmount;

        //print("BILL AMOUNT FINAL here ${totalAmount}");

        print("BILL AMOUNT FINAL ${ _orderData.totalPrice}");




      }



      _orderData.totalPriceDelivery =
          _orderData.totalPrice! + _orderData.deliveryCharge;

      print("TOTAL PRICE DELIVERY:${_orderData.totalPriceDelivery}");


      //}

    }




    notifyListeners();



  }*/


  /*calculateBillAmount(var productPrice, int shopAssistantQty){

    int totalBillAmount = billAmount!;

    //  finalTotalAmount = totalBillAmount + billAmount!;





    print("PRODUCT bill PRICE==>$totalBillAmount");

  print("THIS IS INSIDE CALCULATE BILL AMNT $count");

    if(productsCount != null)
    {

      print("PRODUCTLENGTH${_orderData.products!.length}");


      if(_orderData.products!.length == 1){
        _orderData.totalPrice = calculateProductPrice(productPrice,shopAssistantQty);
      }



      else
      {
        // for(int i = 0; i<= _orderData.products!.length; i++)
        *//* _orderData.totalPrice =
            billAmount! + calculateProductPrice(productPrice,shopAssistantQty);*//*

        *//*_orderData.totalPrice =
            billAmount! + calculateProductPrice(productPrice);*//*

        //int totalAmnt =  calculateProductPrice(productPrice,shopAssistantQty);
        // for (int i = 1; i <= _orderData.products!.length; i++) {
           _orderData.totalPrice = totalBillAmount + calculateProductPrice(productPrice, shopAssistantQty);

           print("BILL AMOUNT FINAL ${_orderData.totalPrice}");

      }


          _orderData.totalPriceDelivery =
              _orderData.totalPrice! + _orderData.deliveryCharge;

          print("TOTAL PRICE DELIVERY:${_orderData.totalPriceDelivery}");
        //}

    }

    notifyListeners();

  }*/



  void incrementCount() {

    count++;
    notifyListeners();

  }

  void decrementCount() {

    if (count > 0) {
      count--;
    }
    notifyListeners();

  }




  updateOrderDetailsListFromLiveData(Map<String, dynamic> json) {
    // OrderDetailsModel _data = OrderDetailsModel.fromLiveDataJson(json);
    // _orderData.lastStatus = _data.lastStatus;
    // //_orderData.paymentActive = _data.paymentActive;
    // _paymentStatus = _data.paymentStatus;
    // _orderData.stats = _data.stats;
    // _orderData.finalBillAmount = _data.finalBillAmount;
    // _orderData.totalPriceDelivery = _data.totalPriceDelivery;
    // _orderData.estimatedDeliveryTime = Utils.convertIso1806TimestampToMilliSecondsEpoch(_data.estimatedDeliveryTime);
    // //print("Order details Live Data==>${data!.lastStatus}");
    // // print("Order details Live Data Model ==>${orderList[0].lastStatus}");
    // notifyListeners();
  }
}
