import 'package:flutter/material.dart';

class NavigationService{

 static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


 navigateTo(Widget widget){
   navigatorKey.currentState!.push(MaterialPageRoute(builder: (context)=>widget));
 }
}