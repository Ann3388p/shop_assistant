import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/mobile_login_services.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';

import '../../core/models/UserDataTruncatedFlow.dart';

class OtpValidationViewModel with ChangeNotifier{
late ApiResponse loginResponse;
ApiResponse? resendOtpResponse;
late ApiResponse subscribeToTopicResponse;
late ApiResponse shoppingCountResponse;
bool isLoading = false;
Map<String,dynamic> userData = Map<String,dynamic>();
MobileLoginServices _service = MobileLoginServices();

  doLogin({String? mobileNumber, required String otp, required BuildContext context})async{
    isLoading = true;
    notifyListeners();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String,dynamic> body = {
      "mobileNumber":"$mobileNumber",
      "otp" : int.parse(otp),
      "fcmToken" : fcmToken
    };

    loginResponse = await _service.doLogin(body: body);
    // SAVE USER CREDENTIALS TO LOCAL DATABASE
    if(!loginResponse.haserror){
      final storage = new FlutterSecureStorage();
      UserDataViewModel userDATA = loginResponse.data;
      userData = userDATA.toJson();
      //   // Encoding as json to store the data in local db as string
        final userDataJson = jsonEncode(userData);
      print(" after login ${json.encode(userDataJson)}");
        try{
          await storage.write(key: "isLoggedIn",value:"true");
          await storage.write(key: "userData", value:userDataJson);
        }catch(err){
          print('error saving user credentials');
        }
        /// CALL SHOPPING COUNT INSIDE GETUSERDATA
       // shoppingCountResponse = await _service.getShoppingCount(context);

    }else{
      Utils.errorDialog(context, loginResponse.errormsg);
    }
    isLoading = false;
    notifyListeners();
  }

MobileLoginServices _mobileLoginServices = MobileLoginServices();
resendOtp(String mobileNumber) async {
  // isLoading = true;
  // notifyListeners();
  Map<String, dynamic> body = {
    "mobileNumber": "$mobileNumber"
  };
  resendOtpResponse = await _mobileLoginServices.sendOtp(body: body);
  // isLoading = false;
  // notifyListeners();
}
}