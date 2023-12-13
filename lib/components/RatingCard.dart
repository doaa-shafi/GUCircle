import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingCard extends StatefulWidget {
  final String username;
  final double rating;
  final List<dynamic> comments;
  final String postId;
  final Function gotoComments;

  RatingCard({
    required this.username,
    required this.rating,
    required this.comments,
    required this.gotoComments,
    required this.postId,
  });

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  bool error = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<void> request() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       if (widget.likes.contains(user.uid)) {
  //         //already liked so unlike
  //         await firestore.collection('LostAndFound').doc(widget.postId).update({
  //           "likes": FieldValue.arrayRemove([user.uid])
  //         });
  //         setState(() {
  //           widget.likes.remove(user.uid);
  //         });
  //       } else {
  //         //like
  //         await firestore.collection('LostAndFound').doc(widget.postId).update({
  //           "likes": FieldValue.arrayUnion([user.uid])
  //         });
  //         setState(() {
  //           widget.likes.add(user.uid);
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error sending request: $e");
  //     setState(() {
  //       error = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15, 0, 0),
                  child: Text(
                    widget.username,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
              child: RatingBar.builder(
                ignoreGestures: true,
                initialRating: widget.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) => Icon(
                  Icons.star_outline,
                  color: Colors.amber,
                ),
                tapOnlyMode: true,
                onRatingUpdate: (double value) {},
                //   onRatingUpdate: (value) {
                //     setState(() {
                //       widget.rating = value;
                //     });
                //   },
              ),
            ),
            const SizedBox(
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
                          Text(widget.comments.length.toString()),
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
