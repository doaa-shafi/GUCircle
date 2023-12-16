import 'package:flutter/material.dart';
import 'package:gucircle/classes/FCMService.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:gucircle/screens/AdminHome.dart';
import 'package:gucircle/screens/ConfessionsScreen.dart';
import 'package:gucircle/screens/ImportantNumbersScreen.dart';
import 'package:gucircle/screens/LostAndFoundScreen.dart';
import 'package:gucircle/screens/NotificationsScreen.dart';
import 'package:gucircle/screens/OfficesScreen.dart';
import 'package:gucircle/screens/RatingsScreen.dart';
import 'package:gucircle/screens/SettingsScreen.dart';
import 'package:gucircle/screens/SignUpScreen.dart';
import 'package:gucircle/screens/TabControllerScreen.dart';
import 'package:gucircle/screens/UploadLostAndFoundScreen.dart';
import 'package:gucircle/screens/profileScreen.dart';
import 'package:gucircle/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import './screens/EventsScreen.dart';
import './screens/LoginScreen.dart';
import './screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully.');
    FCMService fcmService = FCMService();
    await fcmService.setupFCM();
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle the error gracefully, for example, show an error dialog or exit the app.
    return;
  }

  // Request location permissions
  var status = await Permission.location.request();
  if (status.isGranted) {
    print("Location permission granted");

    runApp(
      ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: MyApp(),
      ),
    );
  } else {
    // Permission denied.
    print('Location permission denied');
    // Handle the denial, for example, show a message to the user or exit the app.
    return;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor primaryBlack = MaterialColor(0xFF000000, <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    });
    return MaterialApp(
        title: 'GUCircle',
        theme: ThemeData(
          primarySwatch: primaryBlack,
        ),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (ctx) => SplashScreen(),
          '/loginRoute': (ctx) => LoginScreen(),
          '/signupRoute': (ctx) => SignUpScreen(),
          '/importantNumbersRoute': (ctx) => ImportantNumbersScreen(),
          '/lostandfoundRoute': (ctx) => LostAndFoundScreen(),
          '/uploadlostandfoundRoute': (ctx) => UploadLostAndFoundScreen(),
          '/confessionsRoute': (ctx) => ConfessionsScreen(),
          '/officesRoute': (ctx) => OfficesScreen(),
          '/eventsRoute': (ctx) => EventsScreen(),
          '/profileRoute': (ctx) => ProfileScreen(),
          '/mainPage': (ctx) => TabsControllerScreen(),
          '/adminHome': (ctx) => AdminHome(),
          '/notificationsRoute': (ctx) => NotificationsScreen(),
          '/ratingsRoute': (ctx) => RatingsScreen(),
          '/settingsRoute': (ctx) => SettingsScreen()
        });
  }
}
