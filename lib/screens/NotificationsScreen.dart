import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucircle/components/NotificationCard.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getAllNotifications() async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('Notifications')
            .doc(user!.uid)
            .get();

    return documentSnapshot;
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
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getAllNotifications(),
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
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>> document = snapshot.data!;
              if (document.exists) {
                // Access the array of maps in the document
                List<Map<String, dynamic>> notifications =
                    (document['notifications'] as List<dynamic>)
                        .cast<Map<String, dynamic>>();

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> notification = notifications[index];
                    return NotificationCard(
                      message: notification['message'],
                      read: notification['read'],
                      timestamp: notification['timestamp'],
                      ref: notification['reference'],
                      setRead: () => {
                        // FirebaseFirestore.instance
                        //     .collection('Notifications')
                        //     .doc(user!
                        //         .uid) // replace 'userId' with the actual user's ID
                        //     .update({
                        //   'notifications.$index.read': true,
                        // });
                        // setState(() {});
                      },
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text(
                  'No Notifications yet',
                  style: TextStyle(fontSize: 20),
                ));
              }
            } else {
              return const Center(
                  child: Text(
                'No Notifications yet',
                style: TextStyle(fontSize: 20),
              ));
            }
          },
        ),
      ),
    );
  }
}
