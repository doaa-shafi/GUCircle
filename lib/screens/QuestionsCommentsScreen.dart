import 'dart:ffi';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gucircle/components/CommentCard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsCommentsScreen extends StatefulWidget {
  final String postId;
  final List<dynamic> comments;
  const QuestionsCommentsScreen(
      {super.key, required this.postId, required this.comments});

  @override
  State<QuestionsCommentsScreen> createState() =>
      _QuestionsCommentsScreenState();
}

class _QuestionsCommentsScreenState extends State<QuestionsCommentsScreen> {
  bool error = false;
  final newComment = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  Future<void> request() async {
    if (newComment.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Posting...'),
            content: Text('Please wait...'),
            actions: [],
          );
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await firestore
            .collection('AcademicQuestions')
            .doc(widget.postId)
            .update({
          "comments": FieldValue.arrayUnion([
            {"user": user.uid, "text": newComment.text}
          ])
        });
      }
      setState(() {
        widget.comments.add({"user": user!.uid, "text": newComment.text});
        newComment.clear();
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.comments.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: widget.comments.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<String>(
                          future: getUsername(widget.comments[index]['user']),
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
                              return CommentCard(
                                text: widget.comments[index]['text'],
                                username: usernameSnapshot.data.toString(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Align(
                        heightFactor: 1.0,
                        alignment: Alignment.center,
                        child: Text(
                          'No Comments',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                            labelText: 'Comment...', border: InputBorder.none),
                        controller: newComment,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: request,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(0, 25, 0, 25)),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Color.fromARGB(255, 107, 30, 24);
                      }
                      return const Color.fromARGB(255, 167, 46, 37);
                    }),
                  ),
                  child: Text(
                    "Post",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            error
                ? const Text(
                    "An error occured, please try again later",
                    style: TextStyle(color: Colors.red),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
