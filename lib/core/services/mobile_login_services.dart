import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/api_handler.dart';

import '../../ui/viewmodel/UserDataTruncated.dart';
import '../../ui/viewmodel/UserDataTruncated.dart';
import '../models/UserDataTruncatedFlow.dart';
import 'navigation_service.dart';
import 'dart:convert';
class MobileLoginServices {

  doLogin({required Map<String, dynamic> body}) async {
    String query = r'''query($mobileNumber:String!,$otp:Int!,$fcmToken:String){
    loginShopAssistant(phoneNumber:$mobileNumber,otp:$otp,fcmToken:$fcmToken){
        storeid
        shopAssistantId 
        firstName
        lastName
        storeName
        token
        shopAsstTruncatedFlow
    }
  } ''';
    ApiResponse result = await ApiHandler().queryRequest(query, body: body);
    if (!result.haserror) {
      final userData = UserDataViewModel.fromJson(
          result.data["loginShopAssistant"]);
      final userTruncated = UserTruncatedModel(
          shopAsstTruncatedFlow: result
              .data["loginShopAssistant"]["shopAsstTruncatedFlow"]
      );
      print("User Truncated Flow --->${userTruncated.shopAsstTruncatedFlow}");
      Provider.of<UserDataViewModel>(NavigationService.navigatorKey.currentContext!, listen: false).userTruncatedModel =  UserTruncatedModel(
        shopAsstTruncatedFlow: userTruncated.shopAsstTruncatedFlow,
        // add any other fields as necessary
      );
      final storage = new FlutterSecureStorage();
      await storage.write(
          key: "userTruncatedFlow", value: userTruncated.shopAsstTruncatedFlow.toString());
      // final userTruncated = UserDataViewModel.fromJson(result.data["loginShopAssistant"]["shopAsstTruncatedFlow"]);
      // print("Truncated flow service---> ${ userDataTruncated}");
      // final userDataTruncate =  UserDataTruncatedFlow.fromJson(result.data["loginShopAssistant"]);
      // print("Truncated flow service---> ${ userDataTruncate.shopAsstTruncatedFlow}");
      // UserDataViewModel userDataViewModel = Provider.of<UserDataViewModel>(NavigationService.navigatorKey.currentContext!, listen: false);
      // userDataViewModel.userdatatruncateflow.add(userDataTruncate);
      // print("After adding to the list--->${userDataViewModel.userdatatruncateflow.map((e) => e.shopAsstTruncatedFlow)} ");
      return ApiResponse(haserror: false, data: userData, errormsg: '');
    } else {
      return result;
    }
  }

  // updatetruncated(BuildContext context,ApiResponse responsedet)async{
  // print("truncated");
  //   await Provider.of<UserDataViewModel>(context,listen: false).updatetruncatedflow(
  //     responsedet.data
  //   );
  // await Provider.of<UserDataViewModel>(context,listen: false).UserDataTruncated(
  //
  //
  // );
  // }
  // subscribeToTopic({required String topic})async{
  //   ApiResponse result = ApiResponse(haserror: false,errormsg: '');
  //   try{
  //   await FirebaseMessaging.instance.subscribeToTopic(topic);
  //   }catch(e){
  //     result = ApiResponse(haserror: true,errormsg: e.toString());
  //   }
  //   if(!result.haserror){print("subscribed to topic");}
  //   return result;
  // }

  sendOtp({required Map<String, dynamic> body}) async {
    String query = r"""mutation($mobileNumber:String!){
            sendOTP(phoneNumber:$mobileNumber)
          }
          """;
    ApiResponse result = await ApiHandler().mutationRequest(query, body: body);
    return result;
  }


  getShoppingCount(BuildContext context) async {
    await Provider.of<UserDataViewModel>(context, listen: false)
        .getShoppingCount();
    return Provider
        .of<UserDataViewModel>(context, listen: false)
        .shoppingCountResponse;
  }

}