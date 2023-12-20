import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/screens/OneConfessionScreen.dart';
import 'package:gucircle/screens/OneEventScreen.dart';
import 'package:gucircle/screens/OneLostAndFoundScreen.dart';
import 'package:intl/intl.dart';
import 'package:gucircle/screens/OneQuestionScreen.dart';

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
    if (userId == "Anonymous") {
      return "Anonymous";
    }
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

        if (documentSnapshot.exists) {
          print(documentSnapshot.reference.id);
          if (collection == 'Events') {
            Map<String, dynamic> eventData =
                documentSnapshot.data() as Map<String, dynamic>;
            String username = await getUsername(eventData['userId']);
            collectionRef.doc(eventData['userId']).update({'pending': false});
            goToEvent(context, username, eventData['Title'], eventData['text'],
                eventData['imgURL'] == null ? "" : eventData['imgURL']);
          } else if (collection == 'AcademicQuestions') {
            Map<String, dynamic> postData =
                documentSnapshot.data() as Map<String, dynamic>;
            String username = await getUsername(postData['userId']);
            collectionRef.doc(postData['userId']).update({'pending': false});
            Navigator.of(context).push(MaterialPageRoute(builder: (ctxDummy) {
              return OneQuestionScreen(
                  post: postData,
                  username: username,
                  postId: documentSnapshot.reference.id.toString());
            }));
          } else if (collection == 'LostAndFound') {
            Map<String, dynamic> postData =
                documentSnapshot.data() as Map<String, dynamic>;
            String username = await getUsername(postData['userId']);
            //collectionRef.doc(postData['userId']).update({'pending': false});
            Navigator.of(context).push(MaterialPageRoute(builder: (ctxDummy) {
              return OneLostAndFoundScreen(
                  post: postData,
                  username: username,
                  postId: documentSnapshot.reference.id.toString());
            }));
          } else if (collection == 'Confessions') {
            Map<String, dynamic> postData =
                documentSnapshot.data() as Map<String, dynamic>;
            print("Data: " + postData.toString());
            String username = await getUsername(postData['user']);
            print("username: " + username);
            //collectionRef.doc(postData['userId']).update({'pending': false});
            Navigator.of(context).push(MaterialPageRoute(builder: (ctxDummy) {
              return OneConfessionScreen(
                post: postData,
                username: username,
                docRef: documentSnapshot.reference,
              );
            }));
          }
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
