import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/api_handler.dart';

import '../services/navigation_service.dart';

class MyAccountServices{
  updateName(Map<String,dynamic>body)async{
    String query = r"""mutation($shopAssistantId:ID,$firstName:String,$lastName:String){
                  updateShopAssistant(shopAssistantId:$shopAssistantId,
                    firstName:$firstName,
                    lastName:$lastName){
                    id
                    firstName
                    lastName
                    phoneNumber
                    storeid
                    storeName
                  }
                } """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);

    if(!result.haserror){
      print("Token in update name service ---->${Provider.of<UserDataViewModel>(NavigationService.navigatorKey.currentContext!,listen: false).token}");
      final data = UserDataViewModel.fromJsonUpdate(result.data["updateShopAssistant"],
          Provider.of<UserDataViewModel>(NavigationService.navigatorKey.currentContext!,listen: false).token);
      return ApiResponse(haserror: false,data: data,errormsg: '');
    }
  }

  updateUserDetails({required BuildContext context, required UserDataViewModel data})async{
   await Provider.of<UserDataViewModel>(context,listen: false).updateUserDetails(data);
  }
}