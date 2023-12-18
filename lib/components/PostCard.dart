import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String text;
  final String collection;
  final Image? attachedImg;
  final List<dynamic> likes;
  final List<dynamic>? comments;
  final String postId;
  final Function gotoComments;

  PostCard({
    required this.username,
    this.attachedImg,
    required this.collection,
    required this.text,
    required this.likes,
    required this.comments,
    required this.gotoComments,
    required this.postId,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool error = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> request() async {
    print("LIKEEEEEEE");
    print(widget.collection);
    print(widget.postId);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print(widget.collection);
      print(widget.postId);
      if (user != null) {
        if (widget.likes.contains(user.uid)) {
          //already liked so unlike
          await firestore
              .collection(widget.collection)
              .doc(widget.postId)
              .update({
            "likes": FieldValue.arrayRemove([user.uid])
          });
          setState(() {
            widget.likes.remove(user.uid);
          });
        } else {
          //like
          await firestore
              .collection(widget.collection)
              .doc(widget.postId)
              .update({
            "likes": FieldValue.arrayUnion([user.uid])
          });
          setState(() {
            widget.likes.add(user.uid);
          });
        }
      }
    } catch (e) {
      print("Error trying to like post");
      print(e);
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset(
                    'assets/default-user.png',
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                  child: Text(
                    widget.username,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.text,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            widget.attachedImg != null ? widget.attachedImg! : const SizedBox(),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.grey[100]),
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
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Row(children: [
                        IconButton(
                          onPressed: request,
                          icon: Icon(
                            widget.likes.contains(
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: widget.likes.contains(
                                  FirebaseAuth.instance.currentUser?.uid)
                              ? Colors.red
                              : null,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.likes.length.toString()),
                      ]),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: InkWell(
                        onTap: () => widget.gotoComments(
                            context, widget.postId, widget.comments),
                        child: Row(children: [
                          Icon(
                            Icons.message,
                            color: Color.fromARGB(255, 255, 208, 0),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(widget.comments!.length.toString()),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
