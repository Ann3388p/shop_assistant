import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/navigation_service.dart';

class PushNotificationService{

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings);
  }
  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "easyapproach",
            "easyapproach channel",
            importance: Importance.max,
            priority: Priority.max,
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  // static Future<void> createNotification({required String title,required String body}) async {
  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
  //       channelKey:'high_importance_channel2',
  //       title:'${Emojis.time_alarm_clock + Emojis.activites_reminder_ribbon} $title',
  //       //'${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
  //       //body: 'Florist at 123 Main St. has 2 in stock',
  //       //locked: true,
  //       body:"$body",
  //       //bigPicture: 'asset://assets/notification_map.png',
  //       notificationLayout: NotificationLayout.Default,
  //     ),
  //   );
  // }

  static handleOrderNotification(Map payload)async{
    print('handle order notofocation is called');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey:'high_importance_channel2',
        title:'${Emojis.time_alarm_clock + Emojis.activites_reminder_ribbon} ${payload["title"]}',
        //'${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
        //body: 'Florist at 123 Main St. has 2 in stock',
        //locked: true,
        body:"${payload["body"]}",
        //bigPicture: 'asset://assets/notification_map.png',
        notificationLayout: NotificationLayout.Default,
      ),
    );
    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if(payload["lastStatus"] == "Order-Placed")
      Provider.of<UserDataViewModel>(context!,listen: false).incrementShoppingcount();
    // if(payload["orderType"]!=null)
    //   Provider.of<UserDataViewModel>(context!,listen: false).updateShoppingCount(int.parse(payload["orderType"]));
    //print("${Provider.of<UserDataViewModel>(context!,listen: false).userID}");
  }

  static handlebasicNotification(Map payload)async{
    print('handle basic notifocation is called');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey:'high_importance_channel2',
        title:'${Emojis.time_alarm_clock + Emojis.activites_reminder_ribbon} ${payload["title"]}',
        //'${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!',
        //body: 'Florist at 123 Main St. has 2 in stock',
        //locked: true,
        body:"${payload["body"]}",
        //bigPicture: 'asset://assets/notification_map.png',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }



  static handleNotification(RemoteMessage message){
    print('handle notification is called');
    print(message.data);
    if(message.data["type"]=="order")
      handleOrderNotification(message.data);
    else
      handlebasicNotification(message.data);
  }
}