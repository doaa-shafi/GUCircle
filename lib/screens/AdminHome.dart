import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/AdminEventCard.dart';
import 'package:gucircle/components/EventCard.dart';
import 'package:gucircle/components/mainAppBar.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future sendNotificationToMultipleDevices() async {
    final CollectionReference tokensRef =
        FirebaseFirestore.instance.collection('NotificationTokens');
    QuerySnapshot querySnapshot = await tokensRef.get();

    List<DocumentSnapshot> documents = querySnapshot.docs;

    List<String> deviceTokens = documents.map((e) => e.id).toList();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final postUrl =
        'https://fcm.googleapis.com/v1/projects/gucircle-79792/messages:send';
    //'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'Bearer MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDN2bCtJkH7SWoz\nOIHQUuoLBoHsgsoDwVcdrzFwvXSTpsV8nRka9VtBvTOr7iwgIrce1zjBcYvcJDBx\nKB4OOiW7UYWNpMV/Hsa/HBWkAIZFsSZrHcKM4WKCyGDpCbN4VDrS1tuEzLlQmDto\n/JMKWZLiHBUZK3wiI4QHYaF8uxTmEzyv7YWRknazXqHjegucaF/OqeRkBaFW1ssr\nSVHVu+et7HVYTR1zKJEeOPH/BEeUnA57qxxeZHx+lkhcYaMO3YXvyCO7Ep++v3Aa\nyypyXeNE18RX63vh6NwHD2wFfYI/krFhsPyufTNFeYDVmjqk5mqnRCRgSjV0Tio6\nhqs3+8IlAgMBAAECggEAYm/MrGhEmjFnvxmw/hmAQQh6HcsHZpdQnOnXtyVp92eD\nPc10IW+eFYgwCvIomK9xKSbbRaoSKxIFNj9sa/pDa9mWh375UIo7mU0JTjVQAEiv\n6f4/uBXZgVfn+9h/QbXpsUQ8kjtCDPfXRSOu/v6JnmW2cyRXxo18R/lYe2iNHF3P\nqADGMfdlwfM+kEcDltg6GZ/5UvYDyw+UjgPsFX9VHFK+mQJjdFunovDH/sDH2J5k\nVFvR8xcycDccIzif9AYOBt7dxg1bp3CGwvBkDklc/WfI7dAc4M1Cl2M8i0/Xnu76\nZ1ZveYL/1PqSm3dUrljUxX+DiHH4ZFzqhWC4onp36wKBgQD0SGXfVIodMtyKovFo\n/EdOW8OQ0t5ZHOzgaZ33vWhPH5ZsLlwlqQKz+yZAWyJDA7ZzFULxeDVF9c4wf9Nj\nXvY3rEFgHhjTTN//EjuHqzpzM9XmglH4IkQftpPn64k/WVgNG7v5eedMDLt2kbKC\n3nixUGM+vgnF8k2QyqiO9ZaW/wKBgQDXuV8n7exJ45GehiVdAGXOs0WUuXNTYDFe\n9lpa9ihvq716xU3eqTcco5LzH55ge+sAuKrpJY4l+BYtmHKhGcGfn6pCdcT8pTPu\njnz6kpYcR2M1hgdozyqznAoWWxRLiQ6hbZJxiPzl+eK9riBIxT562dbeqpNS4NM4\nOV5pFV1q2wKBgQDHE6052OqJqyaCMRJuDZKK8EurXb3of6Mnq8sZ15kHSmXLGejs\npBTY2mcs8Vg1pvPsS7p3kRBRSGXVroZ2KDCd5FqO21g98xtlAtXS1Z9XvTmnljL4\n9evwsFlPGuuJ3eTdIeoKAOeXWZT4pvoEnwta7XlD65mJYNMHmbDOeKRVvwKBgDVO\n3p/cYI6lyL9WwPbpeT8J+ADXjxMkay7fS9a8i6OE2g7zoNmMEU1ncpHX12haVulX\nuQxiNm1VkA12ZaU/2yQZ7ZX8yk/wdxPVbDbzcFrOnUqFs2EICLJXtfpuSWadGNt1\nW0HpKy2dgZWD6QBylY0ANePSXROW8TssmhL3r50PAoGAKIZ39pFIcXC5R1tiWlr4\nK4pCyQs8lDh9Bp6mo9YzCLdFk1e15QX2wtc2CRED0Ra69J5sA1PS1qToFKWBwSY8\n7neNPgZRZ7OIUxBE+v3WLg3/u4QMb0VXYA2gg0XgPpDGcOXl6yptwfjHklxpZq+M\nnrm2b5Pe6ssb4kUWzI97PS4=',
      'Accept': 'application/json',
    };
    // Create the message data
    Map<String, dynamic> messageData = {
      'notification': {
        'title': 'New Event Posted',
        'body': 'Come check it out!',
      },
      'data': {
        'key1': 'value1',
        'key2': 'value2',
      },
      'token': deviceTokens.first,
    };

    Map<String, dynamic> testAPI = {'validate_only': true, 'message': {}};

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(testAPI),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      print('FCM request sent');
    } else {
      print('FCM request failed with status: ${response.body}');
    }

    // try {
    //   await messaging.sendMessage(
    //       to: deviceTokens.first,
    //       data: data,
    //       collapseKey: "key",
    //       messageId: "key",
    //       messageType: "type",
    //       ttl: 1000);
    // } catch (e) {
    //   print("error here ${e}");
    // }
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
      await sendNotificationToMultipleDevices();
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
