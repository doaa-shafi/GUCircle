import 'package:flutter/material.dart';
import 'package:gucircle/components/EventCard.dart';
import 'package:gucircle/components/MainAppBar.dart';

class OneEventScreen extends StatelessWidget {
  final String username;
  final String text;
  final String title;
  String? imgURL;
  OneEventScreen(
      {required this.username,
      required this.text,
      required this.title,
      this.imgURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: 'Event',
        goBack: true,
      ),
      body: SingleChildScrollView(
          child: EventCard(
        username: username,
        text: text,
        title: title,
        attachedImg: imgURL != "" ? Image.network(imgURL!) : null,
      )),
    );
  }
}
