import 'package:flutter/material.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:gucircle/screens/ConfessionsScreen.dart';
import 'package:gucircle/screens/ImportantNumbersScreen.dart';
import 'package:gucircle/screens/LostAndFoundScreen.dart';
import 'package:gucircle/screens/OfficesScreen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase here : $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MyApp(),
    ),
  );
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
        });
  }
}
