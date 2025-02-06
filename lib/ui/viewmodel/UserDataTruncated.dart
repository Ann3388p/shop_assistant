
import 'package:flutter/material.dart';

class UserDataTruncated with ChangeNotifier{
  var userID;
  var token;
  String? firstName ="First Name";
  String? lastName  ="Last Name";
  var storeID;
  String? storeName;
  bool? shopAsstTruncatedFlow;
  updatetruncatedflow({var userID, var token, String? firstName,String? lastName,var storeID,String? storeName, bool ? shopAsstTruncatedFlow}){
    userID = userID;
    token = token;
    firstName = firstName;
    lastName = lastName;
    storeID = storeID;
    storeName = storeName;
    shopAsstTruncatedFlow = shopAsstTruncatedFlow;
    notifyListeners();
  }
}