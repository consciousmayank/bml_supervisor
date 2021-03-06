import 'package:bml_supervisor/app_level/setup_snackbars.dart';
import 'package:bml_supervisor/main/app_configs.dart';
import 'package:bml_supervisor/routes/routes.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app_level/locator.dart';
import '../app_level/setup_bottomsheet_ui.dart';
import '../app_level/shared_prefs.dart';
import '../app_level/themes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      'PushNotifications :: Handling a background message ${message.messageId}');
  print('PushNotifications :: ${message.data}');
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'bml_manager_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications for BML Manager.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void runBMLAPP({
  @required String baseUrl,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyPreferences().init();
  declareDependencies(
      configurations: AppConfigs(
    baseUrl: baseUrl,
  ));
  setupBottomSheetUi();
  setupSnackbarUi();
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(
      desktop: 800,
      tablet: 550,
      watch: 200,
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouter _router = AppRouter();
  String token;

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
    print('PushNotifications :: payload = $payload');
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();

    InitializationSettings initializationSettings =
        initializeLocalNotificationsPlugIn();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    //will be called when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ));

      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       message.data['title'],
      //       message.data['body'],
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           channel.description,
      //           icon: android?.smallIcon,
      //         ),
      //       ));
      // }
    });
    getToken();
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print('PushNotifications :: Token = $token');
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeConfiguration().getAppThemeComplete(),
        debugShowCheckedModeBanner: true,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: _router.generateRoute,
        initialRoute: mainViewRoute,
      ),
    );
  }

  InitializationSettings initializeLocalNotificationsPlugIn() {
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    return InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  }
}
