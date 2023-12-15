import 'dart:ffi';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gucircle/components/ConfessionCard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadConfessionScreen extends StatefulWidget {
  const UploadConfessionScreen({super.key});

  @override
  State<UploadConfessionScreen> createState() => _UploadConfessionScreenState();
}

class _UploadConfessionScreenState extends State<UploadConfessionScreen> {
  final ConfessionText = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool anonymous = false;
  bool error = false;
  changeAnonymous() => {
        setState(() {
          anonymous = !anonymous;
        })
      };

  Future<void> post() async {
    if (ConfessionText.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Cannot upload an empty confession'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sending Request...'),
            content: Text('Please wait...'),
            actions: [],
          );
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      if (user != null) {
        if (anonymous == false) {
          DocumentReference docRef =
              await firestore.collection('Confessions').add({
            'user': user.uid,
            'text': ConfessionText.text,
            'likes': 0,
            'comments': 0,
            'timestamp': Timestamp.now(),
          });
          await firestore.collection('Notifications').doc("all").update({
            'notifications': FieldValue.arrayUnion([
              {
                'message': "New confession posted",
                'reference': docRef,
                "timestamp": Timestamp.now(),
                "read": false
              }
            ]),
          });
        } else {
          DocumentReference docRef =
              await firestore.collection('Confessions').add({
            'user': "Anonymous",
            'text': ConfessionText.text,
            'likes': 0,
            'comments': 0,
            'timestamp': Timestamp.now(),
          });
          await firestore.collection('Notifications').doc("all").update({
            'notifications': FieldValue.arrayUnion([
              {
                'message': "New confession posted",
                'reference': docRef,
                "timestamp": Timestamp.now(),
                "read": false
              }
            ]),
          });
        }
      }

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uploaded Successful'),
            content: Text('Your confession is successfully uploaded.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/mainPage');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add confession'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                              labelText: 'What is your confession....',
                              border: InputBorder.none),
                          controller: ConfessionText,
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        GestureDetector(
                          onTap: () => {changeAnonymous()},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: anonymous
                                    ? Image.asset(
                                        "assets/silent.png",
                                      )
                                    : Image.asset(
                                        "assets/silent1.png",
                                      ),
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(20, 6, 20, 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: anonymous
                                      ? Text("anonymous")
                                      : Text("post it anonymously?"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: post,
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red[500];
                    }
                    return Colors.red[500];
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
