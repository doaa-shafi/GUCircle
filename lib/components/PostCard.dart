import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gucircle/number.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String text;
  final Image? attachedImg;
  final int likes;
  final List<dynamic>? comments;
  final String postId;
  final Function gotoComments;
  PostCard(
      {required this.username,
      this.attachedImg,
      required this.text,
      required this.likes,
      required this.comments,
      required this.gotoComments,
      required this.postId});

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
                  username,
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
            text,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 30,
          ),
          attachedImg != null ? attachedImg! : const SizedBox(),
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
                      Icon(
                        Icons.favorite,
                        color: Colors.red[500],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(likes.toString()),
                    ]),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: InkWell(
                      onTap: () => gotoComments(context, postId, comments),
                      child: Row(children: [
                        Icon(
                          Icons.message,
                          color: Color.fromARGB(255, 255, 208, 0),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(comments!.length.toString()),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
