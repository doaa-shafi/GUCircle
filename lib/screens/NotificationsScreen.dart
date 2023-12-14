import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucircle/components/NotificationCard.dart';

class MergedDocument {
  final String id;
  final Map<String, dynamic> data;

  MergedDocument(this.id, this.data);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<MergedDocument> getAllNotifications() async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('Notifications')
            .doc(user!.uid)
            .get();

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot2 =
        await FirebaseFirestore.instance
            .collection('Notifications')
            .doc('all')
            .get();

    // Extract the data maps from DocumentSnapshots
    Map<String, dynamic> data1 = documentSnapshot.data() ?? {};
    Map<String, dynamic> data2 = documentSnapshot2.data() ?? {};

    // Merge the notifications based on timestamps
    List<Map<String, dynamic>> mergedNotifications = [
      ...data2['notifications'] ?? [],
      ...data1['notifications'] ?? [],
    ];

    // Sort the merged notifications by timestamp in descending order
    mergedNotifications.sort((a, b) {
      Timestamp timestampA = a['timestamp'];
      Timestamp timestampB = b['timestamp'];
      return timestampB.compareTo(timestampA);
    });

    // Update the data in the original DocumentSnapshot with the merged notifications
    Map<String, dynamic> mergedData = {
      'notifications': mergedNotifications,
      // Add other fields if needed
    };

    MergedDocument mergedDocument = MergedDocument(
      documentSnapshot.id,
      mergedData,
    );

    return mergedDocument;
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: 'Notifications',
        goBack: true,
      ),
      body: RefreshIndicator(
          onRefresh: refreshData,
          child: FutureBuilder<MergedDocument>(
            future: getAllNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                    backgroundColor: Colors.grey,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                MergedDocument mergedDocument = snapshot.data!;
                List<Map<String, dynamic>> notifications =
                    (mergedDocument.data['notifications'] as List<dynamic>)
                        .cast<Map<String, dynamic>>();

                if (notifications.isNotEmpty) {
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> notification = notifications[index];
                      return NotificationCard(
                        message: notification['message'],
                        read: notification['read'],
                        timestamp: notification['timestamp'],
                        ref: notification['reference'],
                        setRead: () {
                          // FirebaseFirestore.instance
                          //   .collection('Notifications')
                          //   .doc(user!.uid)
                          //   .update({
                          //     'notifications.$index.read': true,
                          //   });
                          // setState(() {});
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'No Notifications yet',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text(
                    'No Notifications yet',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            },
          )),
    );
  }
}
