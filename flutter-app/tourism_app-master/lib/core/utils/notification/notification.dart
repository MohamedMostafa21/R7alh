// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:user_workers/core/utils/constants.dart';
// import 'package:user_workers/firebase_options.dart';
//
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart';
//
// // ignore: avoid_classes_with_only_static_members
// class NotificationUtility {
//   static String generalNotificationType = 'general';
//
//   static String assignmentNotificationType = 'assignment';
//   static RemoteMessage? remoteMessageGlobal;
//   static AwesomeNotifications awesomeNotification = AwesomeNotifications();
//
//   static Future<void> setUpNotificationService(
//     BuildContext buildContext,
//   ) async {
//     NotificationSettings notificationSettings = await Constants.messaging.getNotificationSettings();
//     //ask for permission
//     if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined ||
//         notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
//       notificationSettings = await Constants.messaging.requestPermission(
//         provisional: true,
//         announcement: true,
//       );
//
//       //if permission is provisionnal or authorised
//       if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
//           notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
//         if (buildContext.mounted) {
//           debugPrint('===== 1 ======');
//           initNotificationListener(buildContext);
//         }
//       }
//
//       //if permission denied
//     } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
//       return;
//     }
//     if (buildContext.mounted) {
//       debugPrint('===== 2 ======');
//       initNotificationListener(buildContext);
//     }
//   }
//
//   static int count = 0;
//
//   static void initNotificationListener(BuildContext buildContext) {
//     Constants.messaging.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((remoteMessage) async {
//
//      // if (Platform.isAndroid) {
//         createLocalNotification(dismissible: true, message: remoteMessage);
//      // }
//
//       debugPrint('remoteMessage===>${remoteMessage.toMap()}');
//       debugPrint('Status ===> ${remoteMessage.data['status']}');
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
//       log('onMessageOpenedAppListener');
//
//       if (count == 0) {
//         onMessageOpenedAppListener(remoteMessage);
//         // onTapNotificationScreenNavigateCallback(remoteMessage.data['type'] ?? '', remoteMessage.data);
//
//         count++;
//         Future.delayed(
//           const Duration(seconds: 4),
//           () {
//             log('count cdelayed');
//
//             count = 0;
//           },
//         );
//       }
//
//       log('count count $count');
//     });
//   }
//
//   static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     ).then((value) {
//       FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
//     });
//
//     //onMessageOpenedAppListener(remoteMessage);
//     /* if (Platform.isAndroid) {
//       createLocalNotification(dimissable: true, message: remoteMessage);
//     }*/
//
//     //perform any background task if needed here
//     /*remoteMessageGlobal = remoteMessage;
//     debugPrint('_onTapNotificationScreenNavigateCallback BackGround $remoteMessageGlobal');
//
//     onTapNotificationScreenNavigateCallback(
//       remoteMessage.data['type'] ?? '',
//       remoteMessage.data,
//     );*/
//   }
//
// /*  static Future<void> foregroundMessageListener(
//     RemoteMessage remoteMessage,
//   ) async {
//     await AppConst.messaging.getToken();
//     createLocalNotification(dimissable: true, message: remoteMessage);
//   }*/
//
//   static void onMessageOpenedAppListener(
//     RemoteMessage remoteMessage,
//   ) {
//     debugPrint('onMessageOpenedAppListener $remoteMessage');
//
//     onTapNotificationScreenNavigateCallback(
//       remoteMessage.data['type'] ?? '',
//       remoteMessage.data,
//     );
//   }
//
//   static void onTapNotificationScreenNavigateCallback(
//     String notificationType,
//     Map<String, dynamic> data,
//   ) async {
//     debugPrint('onTapNotificationScreenNavigateCallback $data');
//     if (notificationType == 'messages') {
//       log('======== messages =======');
//       /*navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (context) => ChatView(chatId: data['chatId'], anotherUser: data['anotherUser']),
//         ),
//       );*/
//     }
//   }
//
//   /*static Future<bool> isLocalNotificationAllowed() async {
//     const notificationPermission = Permission.notification;
//     final status = await notificationPermission.status;
//     return status.isGranted;
//   }*/
//
//   /// Use this method to detect when a new notification or a schedule is created
//   static Future<void> onNotificationCreatedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   static Future<void> onNotificationDisplayedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   static Future<void> onDismissActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect when the user taps on a notification or action button
//   static Future<void> onActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     debugPrint('===ACTION RECEIVED===');
//
//     debugPrint(receivedAction.payload.toString());
//
//     final typeMessage = jsonDecode(receivedAction.payload!['data']!)['type'];
//     final titleMessage = jsonDecode(receivedAction.payload!['data']!)['title'];
//     final data = jsonDecode(receivedAction.payload!['data']!);
//
//     if (typeMessage == 'messages') {
//       /*navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (context) => ChatView(
//             chatId: jsonDecode(receivedAction.payload!['data']!)['chatId'],
//             anotherUser: jsonDecode(receivedAction.payload!['data']!)['anotherUser'],
//           ),
//         ),
//       );*/
//     } else {}
//
//     /*_onTapNotificationScreenNavigateCallback(
//       (receivedAction.payload ?? {})['type'] ?? '',
//       Map.from(
//         receivedAction.payload ?? {},
//       ),
//     );*/
//   }
//
//
//   static Future<void> initializeAwesomeNotification() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: Constants.notificationChannelKey,
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           //vibrationPattern: highVibrationPattern,
//          // soundSource: 'resource://raw/notification',
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           playSound: true,
//         ),
//       ],
//     );
//   }
//
//   static Future<void> createLocalNotification({
//     required bool dismissible,
//     required RemoteMessage message,
//   }) async {
//     final String title = message.data['title'] ?? 'notification title';
//     final String body = message.data['body'] ?? 'notification body';
//     //  final String? image = message.toMap()['notification']['android']['imageUrl'];
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         autoDismissible: dismissible,
//         title: title,
//         body: body,
//         id: 1,
//         locked: !dismissible,
//         actionType: ActionType.Default,
//         payload: {'title': message.notification?.title , 'body':  message.notification?.body},
//         channelKey: Constants.notificationChannelKey,
//         // customSound: 'resource://raw/notification',
//         displayOnForeground: true,
//         wakeUpScreen: true,
//         //  largeIcon: image,
//         roundedLargeIcon: true,
//         hideLargeIconOnExpand: true,
//         //bigPicture: image,
//         //notificationLayout: NotificationLayout.Default,
//       ),
//     );
//     }
//
//
// }
//
// Future<Map> loadJsonFile() async {
//   final String response = await rootBundle.loadString('assets/services/gazar-21127-firebase-adminsdk-j5y44-5ac7ce9b3e.json');
//   final data = json.decode(response);
//   return data;
// }
//
// Future<void> sendFCMMessage(
//     {required String token, required String title, required String body, required String type, Map<String, dynamic>? data}) async {
// //  final serviceAccountFile = File('assets/services/codgoo-12e2d-firebase-adminsdk-gxigy-d3e7342fc4.json');
//   // final serviceAccountJson = json.decode(await serviceAccountFile.readAsString());
//
//   final accountCredentials = ServiceAccountCredentials.fromJson(Constants.jsonServerKey);
//
//   final authClient = await clientViaServiceAccount(accountCredentials, ['https://www.googleapis.com/auth/firebase.messaging']);
//   final serverKey = authClient.credentials.accessToken.data; // FCM message payload
//   data ??
//       {}.addAll({
//         'title': title,
//         'body': body,
//         'type': type,
//       });
//   final message = jsonEncode({
//     'message': {
//       'token':
// 'enkZrlbVQiGqCV2Nh9XXYX:APA91bGkNsoUQowuQxpfJB-PgnB3kyjMQRqNHgx87-btED62bx2tKDWq-RukHmPLDfq01h2ZKgQ_n7_tMX62WzIjW9NeD1I8t7JRUf-Ytomjm0T6hkbnM39L59WvuwKvwOfsWUZ1DNTY',      'notification': {
//         'body': 'to_client',
//         'title': 'notification',
//         // "image": "https://dummyimage.com/96x96.png"
//         // "sound":"notification.aac"
//       },
//       'apns': {
//         'payload': {
//           'aps': {'mutable-content': 1, 'sound': 'notification.wav'},
//         },
//       },
//       // "mutable_content": true,
//     },
//   });
//
//   // Send the FCM request
//   final response = await authClient.post(
//     Uri.parse('https://fcm.googleapis.com/v1/projects/gazar-21127/messages:send'),
//     headers: {
//       'Authorization': 'Bearer $serverKey',
//       'Content-Type': 'application/json',
//     },
//     body: message,
//   );
//
//   if (response.statusCode == 200) {
//     log('FCM message sent successfully ${response.body}');
//   } else {
//     log('FCM message failed: ${response.statusCode} ${response.body}');
//   }
// }
//
// Future<void> selectTokens() async {
//   Constants.messaging.requestPermission(
//     provisional: true,
//     announcement: true,
//   );
//   if (Platform.isIOS) {
//     await Constants.messaging.requestPermission(
//       provisional: true,
//       announcement: true,
//     );
//     await Constants.messaging.getAPNSToken();
//   }
//   if (Constants.fcmToken == '') {
//     log('Need Get Token');
//     Constants.fcmToken = await Constants.messaging.getToken() ?? '';
//   }
//
//   debugPrint('FCM ===> ${Constants.fcmToken}');
// }
