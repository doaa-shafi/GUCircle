import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  String username;
  ImageProvider profPic;
  String text;
  ImageProvider? attachedImg;

  EventCard(
      {required this.username,
      this.attachedImg,
      required this.profPic,
      required this.text});

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
              CircleAvatar(
                child: Image(
                  image: profPic,
                ),
                backgroundColor: Colors.white,
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: 20,
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
          attachedImg != null ? Image(image: attachedImg!) : const SizedBox(),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.grey[100]),
          )
        ],
      ),
    ));
  }
}
