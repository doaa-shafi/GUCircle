import 'package:flutter/material.dart';
import 'package:gucircle/screens/ConfessionsScreen.dart';
import 'package:gucircle/screens/ImportantNumbersScreen.dart';
import 'package:gucircle/screens/LostAndFoundScreen.dart';
import 'package:gucircle/screens/OfficesScreen.dart';
import 'package:gucircle/screens/SignUpScreen.dart';
import 'package:gucircle/screens/TabControllerScreen.dart';
import 'package:gucircle/screens/UploadLostAndFoundScreen.dart';
import './screens/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GUCircle',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => TabsControllerScreen(),
          '/loginRoute':(ctx)=>LoginScreen(),
          '/signupRoute':(ctx)=>SignUpScreen(),
          '/importantNumbersRoute':(ctx)=>ImportantNumbersScreen(),
          '/lostandfoundRoute':(ctx)=>LostAndFoundScreen(),
          'uploadlostandfoundRoute':(ctx)=>UploadLostAndFoundScreen(),
          'confessionsRoute':(ctx)=>ConfessionsScreen(),
          'officesRoute':(ctx)=>OfficesScreen(),
        });
  }
}
