import 'dart:ffi';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/number.dart';

class RatingCommentCard extends StatelessWidget {
  final String username;
  final String text;
  final double rating;
  RatingCommentCard(
      {required this.username, required this.text, required this.rating});

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
          RatingBar.builder(
            ignoreGestures: true,
            initialRating: rating,
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
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }
}
