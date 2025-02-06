import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/home_screen.dart';
import 'package:shop_assistant/ui/views/mobile_login.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
final storage = FlutterSecureStorage();
bool _isLoading = true;
  void navigate()async{
    setState(() {
      _isLoading = true;
    });
  var loggedIn = await storage.read(key:"isLoggedIn");
  if (loggedIn!=null){
    var userDataFromLocal = await storage.read(key: "userData");
    final userDataJson = json.decode(userDataFromLocal!);
    print(json.encode(userDataJson));
    await Provider.of<UserDataViewModel>(context,listen: false)
    .setUserData(data: jsonDecode(userDataFromLocal!));
    /// get shopping count inside setUserData
    // await Provider.of<UserDataViewModel>(context,listen: false)
    // .getShoppingCount();
    setState(() {
      _isLoading = false;
    });
    if(!Provider.of<UserDataViewModel>(context,listen: false).shoppingCountResponse.haserror)
    Future.delayed(Duration(seconds: 2)).then((value) =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen(isShowDialog: true,))));
  }else
    Future.delayed(Duration(seconds: 2)).then((value) =>
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MobileLogin())));
   }
  @override
  void initState() {
   navigate();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            if(_isLoading){
              return Container(
                  width: MediaQuery.of(context).size.height*7,
                  child: Image(
                      image:AssetImage("assets/loader.gif")
                  )
              );
            }
            if(Provider.of<UserDataViewModel>(context,listen: false).shoppingCountResponse.haserror){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Something went wrong !"),
                  IconButton(icon: ClipOval(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        color: Theme.of(context).primaryColor,
                        child: Icon(Icons.refresh_rounded)
                    ),
                  ),
                      color: Colors.white,
                      onPressed:()async=>navigate())
                ],
              );
            }
            return Container(
                width: MediaQuery.of(context).size.height*7,
                child: Image(
                    image:AssetImage("assets/loader.gif")
                )
            );


          }
        )
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        // children: [
        //   Text("Shop Assistant",style: TextStyle(
        //     color: Theme.of(context).primaryColor,
        //     fontSize: 30,
        //   ),),
        //   SizedBox(height: 10,),
        //   SizedBox(
        //     height: 35,
        //       width: 35,
        //       child: CircularProgressIndicator()
        //   )
        //
        // ],
        // ),
      ),
    );
  }
}
