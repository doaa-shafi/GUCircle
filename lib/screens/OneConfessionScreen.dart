import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/ConfessionCard.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';

class OneConfessionScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String username;
  final DocumentReference docRef;
  const OneConfessionScreen(
      {required this.post, required this.username, required this.docRef});

  @override
  State<OneConfessionScreen> createState() => _OneConfessionScreenState();
}

class _OneConfessionScreenState extends State<OneConfessionScreen> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Confessions');

  //List<Event> eventsList = [];
  Future<QuerySnapshot> fetchConfessions() async {
    return collectionRef.orderBy('timestamp').get();
  }

  Future<String> getUsername(String userId) async {
    if (userId == "Anonymous") {
      return "Anonymous";
    }
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }
  void _update(bool update) {
    setState(() {});
  }
  Future<void> refreshData() async {
    setState(() {});
  }

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
          'page': 'Confessions',
          'time': _elapsedSeconds,
          'user': user.uid,
        });
      }
    } catch (e) {
      print("Error saving scroll time");
    }
  }

  gotoUpload(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadConfessionScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          appBar: AppBar(),
          title: 'Confession',
          goBack: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ConfessionCard(
              username: widget.username,
              text: widget.post['text'],
              likes: widget.post['likes'],
              comments: widget.post['comments'],
              id: widget.docRef,
              update: _update,),
        )));
  }
}
