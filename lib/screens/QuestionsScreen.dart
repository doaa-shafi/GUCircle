import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/LostAndFoundCommentsScreen.dart';
import 'package:gucircle/screens/QuestionsCommentsScreen.dart';
import 'package:gucircle/screens/UploadQuestionScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucircle/components/PostCard.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refreshData();
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
          'page': 'AcademicQuestions',
          'time': _elapsedSeconds,
          'user': user.uid,
        });
      }
    } catch (e) {
      print("Error saving scroll time");
    }
  }

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('AcademicQuestions');

  Future<QuerySnapshot> fetchLostAndFoundPosts() async {
    print('fetching data');
    QuerySnapshot snapshot =
        await collectionRef.orderBy('date', descending: true).get();
    snapshot.docs.forEach((document) {
      Map<String, dynamic> postData = document.data() as Map<String, dynamic>;

      // Access the 'comments' field
      List<dynamic>? comments = postData['comments'];

      print('Post Data:');
      print('Text: ${postData['text']}');
      print('Username: ${postData['username']}');
      print('Likes: ${postData['likes']}');

      if (comments != null) {
        if (comments.isNotEmpty) {
          print('Number of Comments: ${comments.length}');
          print('Comments:');
          for (var comment in comments) {
            print(comment);
          }
        } else {
          print('No Comments');
        }
      } else {
        print('No Comments');
      }
    });

    return snapshot;
  }

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  gotoUpload(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadQuestionScreen();
    }));
  }

  gotoComments(BuildContext myContext, String postId, List<dynamic> comments) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return QuestionsCommentsScreen(comments: comments, postId: postId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<QuerySnapshot>(
          future: fetchLostAndFoundPosts(),
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
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Ask a question...',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          )),
                    ),
                  ),
                  snapshot.data!.docs.isNotEmpty
                      ? Expanded(
                          child: ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot eventDoc) {
                              Map<String, dynamic> postData =
                                  eventDoc.data() as Map<String, dynamic>;

                              return FutureBuilder<String>(
                                future: getUsername(postData['userId']),
                                builder: (context, usernameSnapshot) {
                                  if (usernameSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      title: CircularProgressIndicator(),
                                    );
                                  } else if (usernameSnapshot.hasError) {
                                    return ListTile(
                                      title: Text(
                                          'Error: ${usernameSnapshot.error}'),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: PostCard(
                                          collection: "AcademicQuestions",
                                          postId:
                                              eventDoc.reference.id.toString(),
                                          gotoComments: gotoComments,
                                          username:
                                              usernameSnapshot.data.toString(),
                                          text: postData['text'],
                                          likes: postData['likes'],
                                          comments: postData['comments'],
                                          attachedImg: postData['imgURL'] != ""
                                              ? Image.network(
                                                  '${postData['imgURL']}')
                                              : null),
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        )
                      : Expanded(
                          child: Align(
                              heightFactor: 1.0,
                              alignment: Alignment.center,
                              child: Text(
                                'No Posts',
                                style: TextStyle(fontSize: 20),
                              )),
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
