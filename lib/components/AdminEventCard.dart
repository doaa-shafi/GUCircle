import 'package:flutter/material.dart';

class AdminEventCard extends StatelessWidget {
  final String username;
  final String text;
  final Image? attachedImg;
  final String title;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  AdminEventCard(
      {required this.username,
      this.attachedImg,
      required this.text,
      required this.onApprove,
      required this.onReject,
      required this.title});

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
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: onApprove,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 36, 105, 38);
                    }
                    return Colors.green;
                  }),
                ),
                child: Text(
                  "Approve",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: onReject,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 190, 52, 42);
                    }
                    return Colors.red[500];
                  }),
                ),
                child: Text(
                  "Reject",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
