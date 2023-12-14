import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/LoastAndFoundCommentsScreen.dart';
import 'package:gucircle/screens/QuestionsCommentsScreen.dart';
import 'package:gucircle/screens/UploadQuestionScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucircle/components/PostCard.dart';

class OneQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String username;
  final String postId;
  @override
  const OneQuestionScreen(
      {super.key,
      required this.post,
      required this.username,
      required this.postId});
  State<OneQuestionScreen> createState() => _OneQuestionScreenState();
}

class _OneQuestionScreenState extends State<OneQuestionScreen> {
  @override
  void initState() {
    super.initState();
    refreshData();
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
        appBar: MainAppBar(
          appBar: AppBar(),
          title: 'Academic Question',
          goBack: true,
        ),
        body: Container(
          child: PostCard(
              collection: "AcademicQuestions",
              postId: widget.postId,
              gotoComments: gotoComments,
              username: widget.username,
              text: widget.post['text'],
              likes: widget.post['likes'],
              comments: widget.post['comments'],
              attachedImg: widget.post['imgURL'] != ""
                  ? Image.network('${widget.post['imgURL']}')
                  : null),
        ));
  }
}
