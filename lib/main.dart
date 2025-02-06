import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/graphql_configuration.dart';
import 'package:shop_assistant/core/services/local_notification_service.dart';
import 'package:shop_assistant/core/services/navigation_service.dart';
import 'package:shop_assistant/ui/viewmodel/assigned_order_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/available_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/completed_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_new_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_pending_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/mobile_login_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/otp_validation_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/product_picking_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/product_picking_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/ready_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/ready_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_delivery_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/truncated_flow_shoppping_viewmodel.dart';
import 'package:shop_assistant/ui/views/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
///COMMENTED
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  if(message!=null){
    PushNotificationService.handleNotification(message);
  }
  if(message.data.isNotEmpty){
    // LocalNotificationService.createNotification();
  }
  print(message.data.toString());
}
////
/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async{
  //  initHiveForFlutter().then((value) => runApp(MyApp()));

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  // await SentryFlutter.init(
  //         (options) {
  //       options.dsn = 'https://dcd9f8a8c9f54d7fbbb10c7b48428dae@o4505362086035456.ingest.sentry.io/4505362120704000';
  //       // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //       // We recommend adjusting this value in production.
  //       options.tracesSampleRate = 0.01;
  //     },
      // appRunner: () => runApp(MyApp()));


  runApp(MyApp());
  // initHiveForFlutter().then((value) => runApp(MyApp()));
  // try {
  //   int ? test;
  //   test! + 3;
  //
  // } catch (exception, stackTrace) {
  //   debugPrint("CATCH ERROR");
  //   await Sentry.captureException(
  //     exception,
  //     stackTrace: stackTrace,
  //   );
  // }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  IO.Socket? socket;
  void initState(){
    FirebaseMessaging.instance.getToken().then((token) => print("Firebase messaging token ==> $token"));
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("initial message received");
    });
    PushNotificationService.initialize();
    AwesomeNotifications().initialize(
        'resource://drawable/res_notification_app_icon',
        [
          NotificationChannel(
              channelKey: 'high_importance_channel2',
              channelName: 'Basic Notifications',
              channelDescription: "This channel is used for important notifications.",
              defaultColor: Colors.teal,
              playSound: true,
              soundSource: 'resource://raw/res_custom_notification',
              importance: NotificationImportance.High,
              channelShowBadge: true,
              enableVibration: true
          )
        ]);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('on message received message');
      if(message.data!=null) {
        PushNotificationService.handleNotification(message);
      }else{
        // LocalNotificationService.display(message);
      }

      // showDialog(context: context,
      //     builder:(context){
      //   return AlertDialog(
      //     title: Text("Received Notification"),
      //   );
      //     } );
    });
    // FirebaseCrashlytics.instance.crash();

    super.initState();
  }


  // );
  // socket!.onReconnect((data){
  //   print('reconnected to socket.io');
  // });


  // }
  //       }


  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQLConfiguration.client,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataViewModel>(create:(context)=>UserDataViewModel()),
          ChangeNotifierProvider<MobileLoginViewModel>(create:(context)=>MobileLoginViewModel()),
          ChangeNotifierProvider<OtpValidationViewModel>(create:(context)=>OtpValidationViewModel()),
          ChangeNotifierProvider<AvailableOrdersViewModel>(create:(context)=>AvailableOrdersViewModel()),
          ChangeNotifierProvider<OrderDetailsViewModel>(create:(context)=>OrderDetailsViewModel()),
          ChangeNotifierProvider<AssignedOrderViewModel>(create:(context)=>AssignedOrderViewModel()),
          ChangeNotifierProvider<ShoppingScreenViewModel>(create:(context)=>ShoppingScreenViewModel()),
          ChangeNotifierProvider<ProductPickingViewModel>(create:(context)=>ProductPickingViewModel()),
          ChangeNotifierProvider<OrderBillingViewModel>(create:(context)=>OrderBillingViewModel()),
          ChangeNotifierProvider<CompletedOrdersViewModel>(create:(context)=>CompletedOrdersViewModel()),
          ChangeNotifierProvider<ReadyOrdersViewModel>(create:(context)=>ReadyOrdersViewModel()),
          ChangeNotifierProvider<DeliveryNewOrdersViewModel>(create:(context)=>DeliveryNewOrdersViewModel()),
          ChangeNotifierProvider<DeliveryPendingViewModel>(create:(context)=>DeliveryPendingViewModel()),
          ChangeNotifierProvider<TruncatedFlowShoppingViewModel>(create:(context)=>TruncatedFlowShoppingViewModel()),
          ChangeNotifierProvider<TruncatedFlowDeliveryViewModel>(create:(context)=>TruncatedFlowDeliveryViewModel()),
        ],
        child: MaterialApp(
          title: 'Shop Assistant',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          theme: ThemeData(
            primaryColor:
            //Color(0xFF85BE49),
            Color.fromRGBO(32, 230, 14,1),
            // Color.fromRGBO(137, 199, 74, 1),
            // accentColor: Color.fromRGBO(137, 199, 74, 1),
            appBarTheme: AppBarTheme(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoadingScreen(),
        ),
      ),
    );
  }
}

// class PushNotificationWidget extends StatefulWidget {
//   const PushNotificationWidget({Key? key}) : super(key: key);
//
//   @override
//   _PushNotificationWidgetState createState() => _PushNotificationWidgetState();
// }
//
// class _PushNotificationWidgetState extends State<PushNotificationWidget> {
//   @override
//   void initState() {
//
//     Future.delayed(Duration.zero).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen())));
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(),
//     );
//   }
// }


