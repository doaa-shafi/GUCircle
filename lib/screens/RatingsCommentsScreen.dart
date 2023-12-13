import 'dart:ffi';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gucircle/components/RatingCommentCard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingsCommentsScreen extends StatefulWidget {
  final String postId;
  final List<dynamic> comments;
  const RatingsCommentsScreen(
      {super.key, required this.postId, required this.comments});

  @override
  State<RatingsCommentsScreen> createState() => _RatingsCommentsScreenState();
}

class _RatingsCommentsScreenState extends State<RatingsCommentsScreen> {
  bool error = false;
  final newComment = TextEditingController();
  double rating = 0;
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
            title: Text('Sending Request...'),
            content: Text('Please wait...'),
            actions: [],
          );
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        widget.comments
            .add({"user": user.uid, "text": newComment.text, "stars": rating});
        double sum = widget.comments
            .map((rating) => (rating['stars'] as num).toDouble())
            .reduce((value, element) => value + element);
        double avgRating = sum / widget.comments.length;
        await firestore.collection('Ratings').doc(widget.postId).update({
          "ratings": FieldValue.arrayUnion([
            {"user": user.uid, "text": newComment.text, "stars": rating}
          ]),
          "avgRating": avgRating
        });
      }
      setState(() {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.comments.isNotEmpty
              ? Expanded(
                  // height: 600,
                  child: ListView.builder(
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<String>(
                        future: getUsername(widget.comments[index]['user']),
                        builder: (context, usernameSnapshot) {
                          return RatingCommentCard(
                            text: widget.comments[index]['text'],
                            username: usernameSnapshot.data.toString(),
                            rating: widget.comments[index]['stars'],
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  // height: 600,
                  child: Align(
                      heightFactor: 1.0,
                      alignment: Alignment.center,
                      child: Text(
                        'No Reviews',
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
                      child: Column(children: [
                        Text('Add your Rating'),
                        RatingBar.builder(
                          // ignoreGestures: true,
                          initialRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40,
                          itemBuilder: (context, _) => Icon(
                            Icons.star_outline,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                              labelText: 'Comment...',
                              border: InputBorder.none),
                          controller: newComment,
                        ),
                      ])),
                ),
              ),
              ElevatedButton(
                onPressed: request,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(0, 25, 0, 25)),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
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
    );
  }
}
