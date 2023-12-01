import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/EventCard.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Events');

  //List<Event> eventsList = [];
  Future<QuerySnapshot> fetchEvents() async {
    return collectionRef.where('pending', isEqualTo: false).get();
  }

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return const Center(
                  child: Text(
                'No Events yet',
                style: TextStyle(fontSize: 20),
              ));
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
                          child: EventCard(
                              username: usernameSnapshot.data.toString(),
                              text: eventData['text'],
                              title: eventData['Title'],
                              attachedImg: eventData['imgURL'] != ""
                                  ? Image.network('${eventData['imgURL']}')
                                  : null),
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
