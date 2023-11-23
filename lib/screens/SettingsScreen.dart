import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool vegeterianSwitch = false;
  bool veganSwitch = false;
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
