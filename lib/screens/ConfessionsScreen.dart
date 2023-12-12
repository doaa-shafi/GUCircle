import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';

class ConfessionsScreen extends StatefulWidget {
  @override
  State<ConfessionsScreen> createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends State<ConfessionsScreen> {
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

  List posts = [
    Post(
        id: "0",
        name: "Hany",
        body: "I have a confession",
        likes: 15,
        comments: 40,
        user: ""),
    Post(
        id: "0",
        name: "Hany",
        body: "I have a confession",
        likes: 15,
        comments: 40,
        user: ""),
    Post(
        id: "0",
        name: "Hany",
        body: "I have a confession",
        likes: 15,
        comments: 40,
        user: "")
  ];

  gotoUpload(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadConfessionScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => gotoUpload(context),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: Container(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Post your own confession....',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )),
              ),
            ),
            Column(
                children: posts.map((post) {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: Image(
                                  image: AssetImage('assets/anonymous.png'),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              Text(
                                post.name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            post.body,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red[500],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(post.likes.toString()),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.message,
                                        color: Color.fromARGB(255, 255, 208, 0),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(post.comments.toString()),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
