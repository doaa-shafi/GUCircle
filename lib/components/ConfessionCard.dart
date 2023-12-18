import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucircle/screens/CommentsScreen.dart';

class ConfessionCard extends StatefulWidget {
  final String username;
  final String text;
  final int likes;
  final int comments;
  final DocumentReference id;
  final ValueChanged<bool> update;

  ConfessionCard(
      {required this.username,
      required this.text,
      required this.likes,
      required this.comments,
      required this.id,
      required this.update});

  @override
  State<ConfessionCard> createState() => _ConfessionCardState();
}

class _ConfessionCardState extends State<ConfessionCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');
  bool error = false;
  bool liked = false;
  int likes = 0;

  @override
  void initState() {
    likes = widget.likes;
    checkLikedOrNot();
    super.initState();
  }

  gotoComments(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return CommentsScreen(
        username: widget.username,
        text: widget.text,
        likes: likes,
        comments: widget.comments,
        id: widget.id,
      );
    })).then((value) => widget.update(true));
  }

  Future<void> checkLikedOrNot() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userRef
            .doc(user.uid) // Document which contains the products array
            .get()
            .then((doc) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          setState(() {
            liked = docData['likedConfessions'].contains(widget.id);
          });
        });
      }
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  Future<void> like() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await userRef.doc(user.uid).update({
          'likedConfessions': FieldValue.arrayUnion([widget.id]),
        });
        await firestore
            .collection('Confessions')
            .doc(widget.id.id)
            .set({'likes': FieldValue.increment(1)}, SetOptions(merge: true));
        setState(() {
          liked = true;
          likes += 1;
        });
      }
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  Future<void> unLike() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await userRef.doc(user.uid).update({
          'likedConfessions': FieldValue.arrayRemove([widget.id]),
        });
        await firestore
            .collection('Confessions')
            .doc(widget.id.id)
            .set({'likes': FieldValue.increment(-1)}, SetOptions(merge: true));
        setState(() {
          liked = false;
          likes -= 1;
        });
      }
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        'assets/default-user.png',
                        height: 50,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      widget.username,
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
                  widget.text,
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
                      Row(children: [
                        liked
                            ? IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red[500],
                                ),
                                onPressed: unLike,
                              )
                            : IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.red[500],
                                ),
                                onPressed: like,
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(likes.toString()),
                      ]),
                      Row(children: [
                        IconButton(
                          icon: Icon(
                            Icons.message,
                            color: Color.fromARGB(255, 255, 208, 0),
                          ),
                          onPressed: () => {gotoComments(context)},
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.comments.toString()),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
