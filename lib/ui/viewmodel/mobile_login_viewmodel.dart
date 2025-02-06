import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/services/mobile_login_services.dart';

class MobileLoginViewModel with ChangeNotifier{

  late ApiResponse sendOtpResponse;
  bool isLoading = false;
  MobileLoginServices _services = MobileLoginServices();
  sendOtp(String mobileNumber) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> body = {
      "mobileNumber": "$mobileNumber"
    };
    sendOtpResponse = await _services.sendOtp(body: body);
    isLoading = false;
    notifyListeners();
  }


}