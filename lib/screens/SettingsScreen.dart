import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool vegeterianSwitch = false;
  bool veganSwitch = false;
  late Timer _timer;
  int _elapsedSeconds = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // start timer
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SwitchListTile(
            title: Text('Notifications'),
            value: vegeterianSwitch,
            onChanged: (val) {
              setState(() {
                vegeterianSwitch = val;
              });
            }),
      ],
    ));
  }
}
