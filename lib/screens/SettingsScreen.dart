import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/classes/FCMService.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationSwitch = true;
  late SharedPreferences prefs;

  Future<void> getSwitchStates() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationSwitch = prefs.getBool('notifications') ?? true;
    });
  }

  late Timer _timer;
  int _elapsedSeconds = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  Future<void> initializeSettings() async {
    await getSwitchStates();

    // Now that prefs is initialized, you can proceed with other operations
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _elapsedSeconds++;
    });
  }

  @override
  void dispose() {
    saveElapsedTimeToDatabase();
    _timer.cancel();
    super.dispose();
  }

  Future<void> saveElapsedTimeToDatabase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await firestore.collection('PagesScrolls').doc().set({
          'page': 'Settings',
          'time': _elapsedSeconds,
          'user': user.uid,
        });
      }
    } catch (e) {
      print("Error saving scroll time");
    }
  }

  Future<void> updateNotificationinPref(bool val) async {
    await prefs.setBool('notifications', val);
  }

  Future<void> updateTokens(bool val) async {
    FCMService fcmService = FCMService();

    if (val == false) // don't want notifications
    {
      final CollectionReference tokensRef =
          FirebaseFirestore.instance.collection('NotificationTokens');
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      // get token
      final token = await _firebaseMessaging.getToken();
      // Delete Firestore document
      await tokensRef.doc(token.toString()).delete();
      await fcmService.setupFCM();
    } else {
      // want notification
      await fcmService.setupFCM();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(appBar: AppBar(), title: "Settings", goBack: true),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Color.fromARGB(47, 201, 220, 230),
              child: SwitchListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 24),
                  ),
                  value: notificationSwitch,
                  onChanged: (val) {
                    setState(() {
                      notificationSwitch = val;
                      updateNotificationinPref(val);
                    });
                    //updateTokens(val);
                  }),
            ),
          ],
        ));
  }
}
