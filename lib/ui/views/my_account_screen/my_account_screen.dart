import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/my_account_viewmodel.dart';
import 'package:shop_assistant/ui/views/my_account_screen/account_screen_update_name.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataViewModel>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
          title: Text("My Account"),
          centerTitle: true
      ),
      body: ChangeNotifierProvider(
        create: (context)=>MyAccountViewModel(),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width*.9,
              child: UpdateName(
                firstName: userData.firstName,
                lastName: userData.lastName,
              ),
            ),
          )),
    );
  }
}
