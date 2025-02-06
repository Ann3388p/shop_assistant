import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/views/mobile_login.dart';

class LogOutConfirm extends StatefulWidget {
  @override
  _LogOutConfirmState createState() => _LogOutConfirmState();
}

class _LogOutConfirmState extends State<LogOutConfirm> {
  @override
  Widget build(BuildContext context) {
    print("log out tap");
    return AlertDialog(
      content: Text('Are you sure you want to log out ?'),
      title: Text('Confirm Logout'),
      actions: <Widget>[
        TextButton(
          onPressed: ()async{
            final storage = FlutterSecureStorage();
            await storage.deleteAll();
            // FirebaseMessaging.instance.unsubscribeFromTopic(Provider.of<UserDataViewmodel>(context,listen: false).userid).then((value) =>
            //     print("unsubscribe from topic"));
            // GraphQLConfiguration.removeToken();
            Provider.of<UserDataViewModel>(context,listen: false).clearUserData();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                MobileLogin()), (Route<dynamic> route) => false);
          },
          child: Text('Yes'),
        ),TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),

      ],
    );
  }
}