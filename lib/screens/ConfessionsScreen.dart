import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/ConfessionCard.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';

class ConfessionsScreen extends StatefulWidget {
  @override
  State<ConfessionsScreen> createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends State<ConfessionsScreen> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Confessions');

  Future<QuerySnapshot> fetchConfessions() async {
    return collectionRef.orderBy('timestamp', descending: true).get();
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
    })).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<QuerySnapshot>(
          future: fetchConfessions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  backgroundColor: Colors.grey,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    const Center(
                        child: Text(
                      'No Confessions yet',
                      style: TextStyle(fontSize: 20),
                    )),
                  ],
                ),
              );
            } else {
              return Column(
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
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot confessionDoc) {
                        Map<String, dynamic> confessionData =
                            confessionDoc.data() as Map<String, dynamic>;

                        return FutureBuilder<String>(
                          future:
                              getUsername(confessionData['user'].toString()),
                          builder: (context, usernameSnapshot) {
                            if (usernameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: CircularProgressIndicator(),
                              );
                            } else if (usernameSnapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${usernameSnapshot.error}'),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ConfessionCard(
                                  username: usernameSnapshot.data.toString(),
                                  text: confessionData['text'],
                                  likes: confessionData['likes'],
                                  comments: confessionData['comments'],
                                  id: confessionDoc.reference,
                                  update: _update,
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
