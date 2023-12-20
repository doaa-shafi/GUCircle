import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/CommentCard.dart';
import 'package:gucircle/components/ConfessionCard.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsScreen extends StatefulWidget {
  final String username;
  final String text;
  final int likes;
  final int comments;
  final DocumentReference id;

  CommentsScreen({
    required this.username,
    required this.text,
    required this.likes,
    required this.comments,
    required this.id,
  });
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final comment = TextEditingController();
  String hintText =
      'Add a comment...\n You can tag your friends with @username#';
  int comments = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference confessionsRef =
      FirebaseFirestore.instance.collection('Confessions');

  final CollectionReference commentsRef =
      FirebaseFirestore.instance.collection('Comments');

  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> fetchConfession() async {
    return confessionsRef.doc(widget.id.id).get();
  }

  Future<QuerySnapshot> fetchComments() async {
    return commentsRef
        .where('confession', isEqualTo: widget.id)
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future<String> getUsername(String userId) async {
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

  @override
  void initState() {
    comments = widget.comments;
    super.initState();
  }

  Future<void> uploadComment() async {
    if (comment.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Cannot upload an empty comment'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sending Request...'),
            content: Text('Please wait...'),
            actions: [],
          );
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

      await firestore.collection('Comments').doc(user!.uid + uniqueName).set({
        'text': comment.text,
        'user': user!.uid,
        'confession': widget.id,
        'timestamp': Timestamp.now()
      });
      await firestore
          .collection('Confessions')
          .doc(widget.id.id)
          .set({'comments': FieldValue.increment(1)}, SetOptions(merge: true));
      setState(() {
        comments += 1;
      });
      final re = RegExp(r'@(\w+)#');
      final tags = re
          .allMatches(comment.text)
          .map((z) => z.group(0)!.substring(1, z.group(0)!.length - 1))
          .toList();
      if(!tags.isEmpty){
      QuerySnapshot taggedUsers = await firestore
          .collection('Users')
          .where('username', whereIn: tags)
          .get();
      print(taggedUsers);
      final username = await getUsername(user.uid);
      print(username);
      taggedUsers.docs.forEach((doc) async {
        print('here');
        final CollectionReference notificationsRef =
            FirebaseFirestore.instance.collection('Notifications');

        // Check if the document exists
        final DocumentSnapshot userDoc =
            await notificationsRef.doc(doc.reference.id.toString()).get();

        if (userDoc.exists) {
          // If the document exists, update it
          await firestore
              .collection('Notifications')
              .doc(doc.reference.id.toString())
              .update({
            'notifications': FieldValue.arrayUnion([
              {
                'message': "Your friend " + username + " tagged you",
                'reference': widget.id,
                "timestamp": Timestamp.now(),
                "read": false
              }
            ]),
          });
        } else {
          // If the document doesn't exist, create it
          await notificationsRef.doc(doc.reference.id.toString()).set({
            'notifications': [
              {
                'message': "Your friend " + username + " tagged you",
                'reference': widget.id,
                "timestamp": Timestamp.now(),
                "read": false
              }
            ]
          });
        }
      });}
      
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uploaded Successful'),
            content: Text('Your Comment is successfully uploaded.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.pop(context);
                  comment.clear();
                  refreshData();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Comments",
      )),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ConfessionCard(
                  username: widget.username,
                  text: widget.text,
                  likes: widget.likes,
                  comments: comments,
                  id: widget.id,
                  update: _update,),
            ),
            FutureBuilder<QuerySnapshot>(
              future: fetchComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                      backgroundColor: Colors.grey,
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Expanded(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Expanded(
                      child: Center(
                          child: Text(
                    'No comments yet',
                    style: TextStyle(fontSize: 20),
                  )));
                } else {
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot commentDoc) {
                        Map<String, dynamic> commentData =
                            commentDoc.data() as Map<String, dynamic>;

                        return FutureBuilder<String>(
                          future: getUsername(commentData['user']),
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
                                  child: CommentCard(
                                    username: usernameSnapshot.data.toString(),
                                    text: commentData['text'],
                                  ));
                            }
                          },
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.amber,
                    ),
                    onPressed: uploadComment,
                  ),
                ),
                controller: comment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
