import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gucircle/number.dart';

class CommentCard extends StatelessWidget {
  final String username;
  final String text;
  CommentCard({required this.username, required this.text});

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
        ],
      ),
    ));
  }
}
