// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_paygateglobal/paygate/paygate.dart';
import 'package:immobilier_apk/firebase_options.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/theme/app_theme.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:immobilier_apk/scr/ui/pages/precache/precache.dart';
import 'package:immobilier_apk/scr/ui/pages/update/update_page.dart';
import 'package:my_widgets/real_state/models/message.dart' as message;

String version = "1.0.0+11";

Update update = Update(version: "1.0.0+11", optionel: false);

double phoneScallerFactor = 1;

DateTime? currentDate;

Map<int, Map<String, String>> id_datas = {};

int? currentId;

var messaging = FirebaseMessaging.instance;

var firestoreDb = FirebaseFirestore.instance;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

var initializationSettingsAndroid =
    const AndroidInitializationSettings('launch_icon');

final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
  requestSoundPermission: true,
  requestBadgePermission: true,
  requestAlertPermission: true,
  // onDidReceiveLocalNotification: (id, title, body, payload) {
  //   var notificationData = id_datas[id];
  //   if (notificationData == null) {
  //     Get.to(const ErrorPage());
  //   } else {
  //     goToDetailPage(notificationData: notificationData);
  //   }
  // },
);

var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  int notifID = Random().nextInt(999);
  while (id_datas.containsKey(notifID)) {
    notifID = Random().nextInt(999);
  }
  id_datas.putIfAbsent(
      notifID,
      () => {
            'categorie': message.data['categorie'],
            'message': message.data['message'],
            'date': message.data['date']
          });
}

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  currentId = notificationResponse.id;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await messaging.getInitialMessage().then((message) {
    if (message != null) {
      int notifID = Random().nextInt(999);
      while (id_datas.containsKey(notifID)) {
        notifID = Random().nextInt(999);
      }
      id_datas.putIfAbsent(
          notifID,
          () => {
                'categorie': message.data['categorie'],
                'message': message.data['message'],
                'date': message.data['date']
              });
      currentId = notifID;
    }
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 if(!kIsWeb){
    flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
   await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
    print(details.id);
    print(id_datas);
    var notificationData = id_datas[details.id];

    if (notificationData == null) {
      Get.to(const ErrorPage());
    } else {
      goToDetailPage(notificationData: notificationData);
    }
  }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("receiveeeeeeeeeeeeeeeeeee");
    print(message.data['id']);
    int notifID = Random().nextInt(999);
    while (id_datas.containsKey(notifID)) {
      notifID = Random().nextInt(999);
    }

    flutterLocalNotificationsPlugin.show(
      notifID,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'moger',
          'MOGER',
          color: Color(0x00000000),
        ),
      ),
    );

    id_datas.putIfAbsent(
        notifID,
        () => {
            'categorie': message.data['categorie'],
            'message': message.data['message'],
            'date': message.data['date']
          });
    print(id_datas);

    if (message.notification != null) {}
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    goToDetailPage(notificationData: event.data);
  });
 }



  Paygate.init(
  apiKey: '13c195ab-00aa-41a5-a8a5-5668cd77a623',
  apiVersion: PaygateVersion.v1, // default PaygateVersion.v2
  identifierLength: 20, // optional, default 20
);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: LoadingPage(),
    defaultTransition: Transition.fadeIn,
    transitionDuration: 444.milliseconds,
  ));

}

void goToDetailPage({required Map<String, dynamic> notificationData}) async {
  var update = await getUpdateVersion();
  if (update.version != version) {
    Get.off(
      const UpdatePage(),
      transition: Transition.rightToLeftWithFade,
      duration: 333.milliseconds,
    );
  } else {
    
      var msg = message.Message.fromMap(notificationData);

      Get.dialog(MessageDetails(message: msg, entrepriseID: msg.entrepriseID??"",));

  
    
  }
}



Future<String?> getPaygateApiKey() async {
  DocumentSnapshot<Map<String, dynamic>> q;
  try {
    q = await DB.firestore(Collections.keys).doc('apiKey').get();
    return q != null ? q.data()!['apiKey'] : null;
  } on Exception {
    // TODO
  }
  return null;
}

Future<Update> getUpdateVersion() async {
  var q = await DB.firestore(Collections.keys).doc('update').get();
  return Update.fromMap(q.data() ?? update.toMap());
}
