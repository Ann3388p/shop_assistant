import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/my_account_services.dart';
import 'package:shop_assistant/ui/shared_widgets/show_toast.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';

class MyAccountViewModel with ChangeNotifier{

  String? _firstName;
  String? _lastName;
  String? _updatedFirstName;
  String? _updatedLastName;
  late ApiResponse updateNameResponse;
  MyAccountServices _services = MyAccountServices();
  final formKey = GlobalKey<FormState>();
  setFirstName(String? value){
    _firstName = value;
    _updatedFirstName = value;
  }
  setLastName(String? value){
    _lastName = value;
    _updatedLastName = value;
  }

  set firstName(String value){
    _firstName = value;
  }
  set lastName(String value){
    _lastName = value;
  }
  setUpdatedFirstName(String value){
   _updatedFirstName = value;
   notifyListeners();
  }
  setUpdatedLastName(String value){
    _updatedLastName = value;
    notifyListeners();
  }
   bool nameChanged(){
    if(_firstName != _updatedFirstName || _lastName !=_updatedLastName){
      return true;
    }
    return false;
   }
    updateName({required BuildContext context, required var userID})async{
      if(formKey.currentState!.validate()){
        Map<String,dynamic> body ={
          "shopAssistantId": userID,
          "firstName": _updatedFirstName,
          "lastName": _updatedLastName
        };
        final storage = FlutterSecureStorage();
        final userDataFlow =  await storage.read(key: "userData");
        print("before account update ${jsonEncode(userDataFlow)}");

        updateNameResponse = await _services.updateName(body);
        if(!updateNameResponse.haserror){
          _firstName = _updatedFirstName;
          _lastName = _updatedLastName;
          await _services.updateUserDetails(context: context, data: updateNameResponse.data);
          ShowToast(context, 'Shop Assistant Details Updated');
        }else{
          Utils.errorDialog(context, updateNameResponse.errormsg,heading: "Error");
        }
      }
    }


  }
