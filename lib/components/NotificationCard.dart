import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/screens/OneEventScreen.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final bool read;
  final DocumentReference? ref;
  final VoidCallback setRead;

  NotificationCard(
      {required this.message,
      required this.read,
      required this.timestamp,
      required this.setRead,
      this.ref});

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Notifications');
  goToEvent(BuildContext myContext, String username, String title, String text,
      String imgURL) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return OneEventScreen(
        username: username,
        title: title,
        text: text,
        imgURL: imgURL,
      );
    }));
  }

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  @override
  Widget build(BuildContext context) {
    void handleTabForRejected() {
      setRead();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rejected'),
            content: Text('An admin rejected your event.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    Future<void> handleTabForApproved() async {
      setRead();
      try {
        DocumentSnapshot documentSnapshot = await ref!.get();
        String collection = ref!.path.split('/').first;
        print(collection);
        if (collection == 'Events') {
          if (documentSnapshot.exists) {
            Map<String, dynamic> eventData =
                documentSnapshot.data() as Map<String, dynamic>;

            String username = await getUsername(eventData['userId']);
            collectionRef.doc(eventData['userId']).update({'pending': false});

            goToEvent(context, username, eventData['Title'], eventData['text'],
                eventData['imgURL'] == null ? "" : eventData['imgURL']);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('An error occured. Please try again later.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } catch (e) {
        print("an error occured $e");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        enabled: true,
        // tileColor: read ? Colors.white : Color.fromARGB(66, 113, 144, 168),
        title: Text(message),
        subtitle:
            Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate())),
        onTap: ref == null ? handleTabForRejected : handleTabForApproved,
      ),
    );
  }
}
