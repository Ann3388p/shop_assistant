import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_assistant/core/models/UserDataTruncatedFlow.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/shopping_count_model.dart';
import 'package:shop_assistant/core/services/graphql_configuration.dart';
import 'package:shop_assistant/core/services/userdata_services.dart';
import 'package:shop_assistant/ui/home_screen.dart';

import '../../ui/shared_widgets/custom_loader.dart';
import '../../ui/shared_widgets/show_toast.dart';
import '../../ui/shared_widgets/utils.dart';
import '../../ui/shared_widgets/dialogs.dart';
import '../../ui/views/order_details_screen/order_details_screen.dart';
import '../services/critical_order_service.dart';
import '../services/navigation_service.dart';
import 'critical_order.dart';

class UserDataViewModel with ChangeNotifier{
  var userID;
  var token;
  String? firstName ="First Name";
  String? lastName  ="Last Name";
  var storeID;
  String? storeName;

  bool? shopAsstTruncatedFlow;

  late ApiResponse shoppingCountResponse;
  late ShoppingCountModel _shoppingCount;
  ShoppingCountModel get shoppingCount => _shoppingCount;
  late ApiResponse criticalOrderResponse;
  late ApiResponse acceptOrderResponse;
  late ApiResponse rejectOrderResponse;
  UserDataViewModel({this.token,this.userID});
  UserDataServices _services = UserDataServices();
  CriticalOrderService criticalOrderService = CriticalOrderService();
  late SharedPreferences _prefs;
  CriticalOrder ? criticalOrderData;
  LiveCriticalOrder ? livecriticalOrderData;
  // UserDataTruncatedFlow ? userDataTruncatedFlow;
  List<CriticalOrder> criticalOrderList = [];
  List<LiveCriticalOrder> liveCriticalList = [];

  // List<UserDataTruncatedFlow> userdatatruncateflow =[];
  bool isLoading = true;
  bool buttonIsLoading = false;
  bool isShowDialog = true;
  bool criticalLoading = true;
  bool Loading = true;
  final PageController pageController = PageController();
  UserTruncatedModel  ? userTruncatedModel;
  updatetruncatevalue() async {
    final storage = FlutterSecureStorage();
    final userTruncate=  await storage.read(key: "userTruncatedFlow");
    if(userTruncate != null)
      {
        final userTruncatedFlow = userTruncate == 'true' ? true : false;
         userTruncatedModel = UserTruncatedModel(
          shopAsstTruncatedFlow: userTruncatedFlow,
          // add any other fields as necessary
        );
        // final userDataTruncated = UserDataTruncatedFlow.fromJson(json.decode(userTruncate!));
        // userdatatruncateflow.add(userDataTruncated);
      }

    notifyListeners();

  }
  setUserData({required Map<String, dynamic> data})async{
    userID = data["userID"];
    token = data["token"];
    firstName = data["firstName"];
    lastName = data["lastName"];
    storeID = data["storeID"];
    storeName = data["storeName"];

    // shopAsstTruncatedFlow= data["shopAsstTruncatedFlow"];
    // print(token);
    GraphQLConfiguration.setToken(token);
    await getShoppingCount();
  }
  clearUserData(){
    userID ="" ;
    token ="";
    firstName ="First Name";
    lastName = "Last Name";
    storeID ="" ;
    storeName="";

    shopAsstTruncatedFlow = false;

  }

  updateUserDetails(UserDataViewModel data) async {
    final storage = new FlutterSecureStorage();
    Map<String, dynamic> map = data.toJson();
    String userDataJson = jsonEncode(map);
    print("Map value ${map}");
    await storage.write(key: "userData", value:userDataJson);
    setUserData(data: map);
    notifyListeners();
  }

  UserDataViewModel.fromJson(Map<String,dynamic> data){
    userID = data["shopAssistantId"];
    token = data["token"];
    firstName = data["firstName"];
    lastName = data["lastName"];
    storeID = data["storeid"];
    storeName = data["storeName"];

    // shopAsstTruncatedFlow= data["shopAsstTruncatedFlow"];

  }
  UserDataViewModel.fromJsonUpdate(Map<String,dynamic> data, var tken){
    print("Token json update--> ${tken}");
    userID = data["id"];
    token = tken;
    firstName = data["firstName"];
    lastName = data["lastName"];
    storeID = data["storeid"];
    storeName = data["storeName"];
     print("Token json update--> ${this.token}");
    // shopAsstTruncatedFlow= data["shopAsstTruncatedFlow"];

  }

  Map<String, dynamic> toJson(){
    Map<String,dynamic> map = Map<String,dynamic>();
    map = {
      "userID" : this.userID,
      "token" : this.token,
      "firstName" : this.firstName,
      "lastName" : this.lastName,
      "storeID" : this.storeID,
      "storeName" : this.storeName,

      // "shopAsstTruncatedFlow" : this.shopAsstTruncatedFlow
    };
    return map;
  }

  getShoppingCount()async{
    Map<String,dynamic> body = {
      "storeid": storeID,
      "shopAssistantId": userID
    };
    shoppingCountResponse = await _services.getShoppingCount(body);
    if(!shoppingCountResponse.haserror){
      _shoppingCount = shoppingCountResponse.data;
    }
    notifyListeners();
  }

  resetShoppingCount(){
    _shoppingCount.totalCountShopping = 0;
    notifyListeners();
  }

  resetDeliveryCount(){
    _shoppingCount.totalCountDelivery = 0;
    notifyListeners();
  }
  incrementShoppingcount(){
    _shoppingCount.totalCountShopping = _shoppingCount.totalCountShopping!+1;
    notifyListeners();
  }
  decrememtShoppingCount(){
    _shoppingCount.totalCountShopping = _shoppingCount.totalCountShopping!-1;
    notifyListeners();
  }
  incrementDeliveryCount(){
    _shoppingCount.totalCountDelivery = _shoppingCount.totalCountDelivery!+1;
    notifyListeners();
  }
  decrementDeliveryCount(){
    _shoppingCount.totalCountDelivery = _shoppingCount.totalCountDelivery!+1;
    notifyListeners();
  }


  updateShoppingCount(int orderType){
    switch(orderType){
      case 1 : incrementShoppingcount();
      break;
      case 2 : incrementDeliveryCount();
      break;
      case 5 : decrementDeliveryCount();
      break;
    }
  }

  Future<ApiResponse> _getAppVersionsFromServer()async{
    final ApiResponse appVersionResponse = await _services.getAppVersions();
    return appVersionResponse;
  }
  checkForAppUpdate()async{
    final ApiResponse appVersionResponse = await _getAppVersionsFromServer();
    if(!appVersionResponse.haserror){
      Map data = appVersionResponse.data.value;
      print("app version data =====>$data");
      PackageInfo? packageInfo = await PackageInfo.fromPlatform();
      print(packageInfo.version);
      var currentVersion = packageInfo.version;
      _prefs = await SharedPreferences.getInstance();
      _showUpdateDialog(currentVersion, data);
    }

  }

  bool _checkRejectedVersionIsNotLatest(var latestVersion)  {
    final storage = new FlutterSecureStorage();
    bool _check = true;
    if(_prefs.getString('rejectedVersion')!=null){
      if(_prefs.getString('rejectedVersion')==latestVersion){
        _check = false;
      }
    }
    return _check;
  }

  _showUpdateDialog(var currentVersion, Map data){
    if(Platform.isIOS){
      if(Utils.compareVersions(currentVersion,data["minVersionIOS"])==-1 ){
        Dialogs.showForceUpdateDialog(data);
      }else
      if(Utils.compareVersions(currentVersion,data["latestVersionIOS"]) == -1 && _checkRejectedVersionIsNotLatest(data['latestVersionIOS'])){
        Dialogs.showUpdateDialog(data);
      }
    }else {
      print("minversionAndroid compare ===>${Utils.compareVersions(currentVersion,data["minVersionAndroid"])}");
      if ( Utils.compareVersions(currentVersion,data["minVersionAndroid"])==-1) {
        Dialogs.showForceUpdateDialog(data);
        // Dialogs.showForceUpdateDialog(data);
      } else if (Utils.compareVersions(currentVersion, data["latestVersionAndroid"]) == -1 && _checkRejectedVersionIsNotLatest(data['latestVersionAndroid'])) {
        Dialogs.showUpdateDialog(data);
      }
    }
  }
  updateCriticalOrderFromLiveData(Map<String, dynamic> json,BuildContext context) {
    livecriticalOrderData = LiveCriticalOrder.fromJson(json);
    liveCriticalList.add(LiveCriticalOrder.fromJson(json));

    // orderList.forEach((element) {
    //    orderList.add(element)
    // });
    // _orderDatanew = data;
    // orderList.add(OrderDetails.fromJson(json));
    // orderList = data as List<OrderDetails>;

    print("Critical Order details Live Data==>${livecriticalOrderData!.lastStatus}");
    if(livecriticalOrderData!.counter! >=2)
    {
      isShowDialog=true;
      getCriticalOrders(context,storeID);

    }
    if(livecriticalOrderData!.counter==0)
    {
      isShowDialog=true;
      getCriticalOrders(context,storeID);
    }
    if(livecriticalOrderData!.lastStatus=="Order-Accepted"
        ||livecriticalOrderData!.lastStatus=="Order-Ready"||
        livecriticalOrderData!.lastStatus=="Completed"||livecriticalOrderData!.lastStatus=="Shopping-in-Progress"
        || livecriticalOrderData!.lastStatus=="Order-Cancelled"||
        livecriticalOrderData!.lastStatus=="Order-Rejected"
    )
    {
      // if()
      //   {
      //     if(livecriticalOrderData!.lastStatus=="Shopping-in-Progress")
      //       {
      //         criticalOrderList.removeWhere((element) => element.shopAssistantId!.id != userID);
      //       }
      print("Enter");
      print("Live order number${livecriticalOrderData!.orderNumber}");
      print("Critical order list removed ===>${criticalOrderList.where((element) => element.orderNumber==livecriticalOrderData!.orderNumber).map((e) => e.orderNumber)}");
      criticalOrderList.removeWhere((element) => element.orderNumber==livecriticalOrderData!.orderNumber);
      print("first loop");
      isShowDialog=true;
      getCriticalOrders(context,storeID);

      // }

    }

    notifyListeners();
  }
  removeCriticalOrderFromList(BuildContext context, orderId){

    if(criticalOrderList.map((e) => e.orderid!.id).length>0)
    {
      criticalOrderList.removeWhere((element) => element.orderid!.id==orderId);
      print(criticalOrderList.map((e) => e.orderNumber));

    }
  }
  getCriticalOrders(BuildContext context,var storeID) async
  {
    Map<String,dynamic> body = {
      "storeid": storeID,
    };
    // isLoading = true;
    // notifyListeners();
    // criticalLoading = true;
    // notifyListeners();
    // CustomLoader(context: context);
    criticalOrderResponse = await criticalOrderService.getCriticalOrder(body);
    // CustomLoader.close(context);

    if(!criticalOrderResponse.haserror){
      criticalOrderList = criticalOrderResponse.data;

      // criticalOrderData = criticalOrderResponse.data;
      // if(criticalOrderList.map((e) => e.shopAssistantId) !=null && criticalOrderList.map((e) => e.shopAssistantId!.id) != userID)
      //   {
      //
      //   }
      // isLoading = false;
      // notifyListeners();
      // print("show dialog===>${isShowDialog}");


      // isShowDialog = true;
      // if(criticalOrderList.isNotEmpty)
      //   {
      //     if(isShowDialog==true) {
      // if(criticalOrderList.isNotEmpty)
      //   {

      // print("Completed ==>${criticalOrderList.map((e) => e.orderid!.stats!.map((e) => e.status).contains("Completed"))}");
      criticalOrderList.removeWhere((element) =>
          element.orderid!.stats!.map((e) => e.status).contains(
              "Completed"));
      criticalOrderList.removeWhere((element) =>
          element.orderid!.stats!.map((e) => e.status).contains(
              "Order-Rejected"));

      for (int i = criticalOrderList.length - 1; i >= 0; i--) {
        var element = criticalOrderList[i];
        if (element.orderid!.stats!.map((e) => e.status).contains("Order-Accepted")) {
          if (element.orderid!.shopAssistantId!.id == userID) {
            print("Assigned shop ass==>${element.orderNumber}");
          } else {
            print("UnAssigned shop ass==>${element.orderNumber}");
            criticalOrderList.removeAt(i);
          }
        }
        if (element.orderid!.stats!.map((e) => e.status).contains("Shopping-In-Progress")) {
          if (element.orderid!.shopAssistantId!.id == userID) {
            print("Assigned shop ass==>${element.orderNumber}");
          } else {
            print("UnAssigned shop ass==>${element.orderNumber}");
            criticalOrderList.removeAt(i);
          }
        }
        if (element.orderid!.stats!.map((e) => e.status).contains("Order-Ready")) {
          if (element.orderid!.shopAssistantId!.id == userID) {
            print("Assigned shop ass==>${element.orderNumber}");
          } else {
            print("UnAssigned shop ass==>${element.orderNumber}");
            criticalOrderList.removeAt(i);
          }
        }

      }

      // bool hasShoppingInProgress = criticalOrderList.any((e) =>
      //     e.orderid!.stats!.any((s) => s.status!.contains("Shopping-In-Progress")));
      // if(hasShoppingInProgress) {
      //   print("First shopinprogress");
      //   print(criticalOrderList.map((e) => e.orderNumber));
      //   if (criticalOrderList
      //       .map((e) => e.orderid!.shopAssistantId!.id)
      //       .isNotEmpty) {
      //     print("remove shopinprogress");

      // print("${criticalOrderList.where((element) => element.orderid!.shopAssistantId!.id != userID).map((e) => e.orderNumber)}");
      // criticalOrderList.removeWhere((element) {
      //   if(element.orderid!.stats!.map((e) => e.status).contains("Shopping-In-Progress")) {
      //     print(element.orderNumber);
      //     if(element.orderid!.shopAssistantId != userID && element.orderid!.shopAssistantId == null) {
      //       print(element.orderNumber);
      //       return true; // remove element if it meets the nested conditions
      //     }
      //   }
      //   return false; // keep element if it doesn't meet the nested conditions
      // });



      // criticalOrderList.forEach((element) {
      //   if(element.orderid!.stats!.map((e) => e.status).contains("Shopping-In-Progress"))
      //     {
      //       // print(element.orderNumber);
      //       if(element.orderid!.shopAssistantId!.id == userID)
      //         {
      //          print("Assigned shop ass==>${element.orderNumber}");
      //         }
      //        else
      //          {
      //            print("UnAssigned shop ass==>${element.orderNumber}");
      //            criticalOrderList.removeWhere((e) => e.orderNumber == element.orderNumber);
      //
      //          }
      //     }
      // });
      // criticalOrderList.removeWhere((element) => element.orderid!.stats!.map((e) => e.status).contains("") != userID);
      // criticalOrderList.removeWhere((element) =>
      //   // element.orderid!.shopAssistantId!.id != userID);
      // }
      // }
      // ;
      // Loading = true;
      // notifyListeners();
      if (criticalOrderList
          .map((e) => e.orderid)
          .length > 0) {
        isShowDialog= true;
        if(isShowDialog)
        {
          Dialogs.showCriticalOrderDialog(context: context,
              criticalOrder: criticalOrderList,
              currentPage: 0,
              liveOrder: livecriticalOrderData,
              isDialogOpen: true,
              onSelected: (criticalOrder) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        OrderDetailsScreen(
                            criticalOrder.orderid!.id, false)));

              }
          );
        }



        // CustomLoader(context: context);

        // CustomLoader.close(context);

      }
      // }
      // else
      //   {
      //     Navigator.pop(context);
      //     // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen(isShowDialog: true,)));
      //   }
      // isShowDialog = false;

      // Navigator.pop(context);

      // else
      //   {
      //     Navigator.pop(context);
      //   }


      // }




      // }



      // Loading = true;
      // notifyListeners();
      // else{
      //   // isShowDialog = false;
      //   Navigator.of(context).pop();

      // if(criticalOrderData!.orderid!.stats!.map((e) => e.status).contains("Shopping-In-Progress"))
      //   {
      //     if(criticalOrderData!.orderid!.shopAssistantId != null && criticalOrderData!.orderid!.shopAssistantId!.id != userID)
      //       {
      //         print(criticalOrderData!.orderNumber);
      //       }
      //
      //   }

      ////////////////////////////////////
      // bool hasShoppingInProgress = criticalOrderList.any((e) =>
      //     e.orderid!.stats!.any((s) => s.status!.contains("Shopping-In-Progress")));
      // if(hasShoppingInProgress)
      // {
      //   print(criticalOrderList.map((e) => e.orderNumber));
      //   if(criticalOrderList.map((e) => e.orderid!.shopAssistantId!.id).isNotEmpty)
      //     {
      //       criticalOrderList.removeWhere((element) => element.orderid!.shopAssistantId!.id != userID);
      //     }
      ////////////////////////////////////////////////////////


      // if(criticalOrderList.map((e) => e.shopAssistantId).isNotEmpty)
      //   {
      //
      //     // print("Shopping ID ==> ${criticalOrderList.map((element) => element.shopAssistantId!.firstName).toList()}");
      //     // criticalOrderList.removeWhere((element) => element.shopAssistantId!.id != userID);
      //   }

    }

    print("Critical order ==>${criticalOrderList.map((e) => e.orderNumber).toList()}");
    // if(criticalOrderList.any((element) => element.orderid!.stats!.map((e) => e.status).contains("Shopping-In-Progress")))
    // {
    //   print("removed shopping in progress");
    //   criticalOrderList.removeWhere((element) => element.shopAssistantId!.id != userID);
    // }
    if(criticalOrderList.isEmpty)
    {
      print("pop");
      isShowDialog = false;
      Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);

    }
  }


  notifyListeners();
}


// }