
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_data_viewmodel.dart';

class CriticalOrderRemove{
  removeOrderFromCriticalOrderList(BuildContext context, String? orderID){
    print("enter");
    Provider.of<UserDataViewModel>(context,listen: false).removeCriticalOrderFromList(context, orderID);
  }
}