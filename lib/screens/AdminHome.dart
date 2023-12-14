import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/AdminEventCard.dart';
import 'package:gucircle/components/EventCard.dart';
import 'package:gucircle/components/mainAppBar.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Events');

  //List<Event> eventsList = [];
  Future<QuerySnapshot> fetchEvents() async {
    return collectionRef.where('pending', isEqualTo: true).get();
  }

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  Future<void> notifyAllUsers(
      String userId, String message, DocumentReference? eventReference) async {
    try {
      final CollectionReference notificationsRef =
          FirebaseFirestore.instance.collection('Notifications');
      // notify all users
      await notificationsRef.doc("all").update({
        'notifications': FieldValue.arrayUnion([
          {
            'message': "New Event posted",
            'timestamp': Timestamp.now(),
            'read': false,
            'reference': eventReference,
          }
        ]),
      });
    } catch (e) {
      print('an error occured $e');
    }
  }

  Future<void> notifyUser(
      String userId, String message, DocumentReference? eventReference) async {
    try {
      final CollectionReference notificationsRef =
          FirebaseFirestore.instance.collection('Notifications');

      // Check if the document exists
      final DocumentSnapshot userDoc = await notificationsRef.doc(userId).get();

      if (userDoc.exists) {
        // If the document exists, update it
        await notificationsRef.doc(userId).update({
          'notifications': FieldValue.arrayUnion([
            {
              'message': message,
              'timestamp': Timestamp.now(),
              'read': false,
              'reference': eventReference,
            }
          ]),
        });
      } else {
        // If the document doesn't exist, create it
        await notificationsRef.doc(userId).set({
          'notifications': [
            {
              'message': message,
              'timestamp': Timestamp.now(),
              'read': false,
              'reference': eventReference,
            }
          ]
        });
      }
    } catch (e) {
      print('an error occured $e');
    }
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            Image.asset('assets/logo.png', height: 40, width: 40),
            const SizedBox(
              width: 10,
            ),
            Text('GUCircle - Admin', style: TextStyle(color: Colors.white))
          ]),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Provider.of<UserModel>(context, listen: false).clearUser();
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/loginRoute');
                },
                icon: Icon(Icons.logout))
          ],
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 83, 69, 22)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<QuerySnapshot>(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  backgroundColor: Colors.grey,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                      child: Text(
                    'No more events',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot eventDoc) {
                  Map<String, dynamic> eventData =
                      eventDoc.data() as Map<String, dynamic>;

                  return FutureBuilder<String>(
                    future: getUsername(eventData['userId']),
                    builder: (context, usernameSnapshot) {
                      if (usernameSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: CircularProgressIndicator(),
                        );
                      } else if (usernameSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${usernameSnapshot.error}'),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AdminEventCard(
                            username: usernameSnapshot.data.toString(),
                            title: eventData['Title'],
                            text: eventData['text'],
                            attachedImg: eventData['imgURL'] != ""
                                ? Image.network('${eventData['imgURL']}')
                                : null,
                            onApprove: () {
                              // Update Firestore document 'pending' field to true
                              collectionRef
                                  .doc(eventDoc.id)
                                  .update({'pending': false});
                              // Send notification
                              notifyUser(
                                  eventData['userId'],
                                  "Your event ${eventData['Title']} was approved!",
                                  eventDoc.reference);
                              notifyAllUsers(
                                  eventData['userId'],
                                  "Your event ${eventData['Title']} was approved!",
                                  eventDoc.reference);
                              setState(() {});
                            },
                            onReject: () async {
                              // Delete Firestore document
                              await collectionRef.doc(eventDoc.id).delete();
                              // Send notification
                              notifyUser(
                                  eventData['userId'],
                                  "Your event ${eventData['Title']} was rejected.",
                                  null);

                              setState(() {});
                            },
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
