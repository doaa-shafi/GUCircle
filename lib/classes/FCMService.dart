import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFCM() async {
    // Check if notifications are enabled in SharedPreferences
    // bool notificationsEnabled = await getNotificationStatus();

    // if (notificationsEnabled) {
    // Request permission for iOS devices
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }

    // get token
    final token = await _firebaseMessaging.getToken();
    try {
      await addTokenToDatabase(token.toString());
    } catch (e) {
      print("error adding token to database ${e}");
    }
    print("token is:" + token.toString());

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received FCM message: ${message.notification?.body}');
      handleMessage(message);
    });

    // Handle incoming messages
    await initPushNotification();
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    //Check if notifications are enabled in SharedPreferences
    bool notificationsEnabled = await getNotificationStatus();

    if (notificationsEnabled) {
      // check for credentials
      User? user = FirebaseAuth.instance.currentUser;
      print("User is:" + user.toString());
      if (user == null) {
        // no user is logged in, so open the log in page
        navigatorKey.currentState?.pushNamed('/');
      } else {
        navigatorKey.currentState?.pushNamed('/notificationsRoute');
        print("notifications route" + navigatorKey.currentState!.toString());
      }
    } else {
      print("notifications muted");
    }
  }

  // Background message handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
    bool notificationsEnabled = await getNotificationStatus();

    if (notificationsEnabled) {
      navigatorKey.currentState?.pushNamed('/notificationsRoute');
    } else {
      print("notifications muted");
    }
  }

  Future initPushNotification() async {
    // handle if app was termintaed
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Set up the onBackgroundMessage handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> addTokenToDatabase(String token) async {
    try {
      final CollectionReference tokenRef =
          FirebaseFirestore.instance.collection('NotificationTokens');

      // Check if the document exists
      final DocumentSnapshot tokenDoc = await tokenRef.doc(token).get();

      if (!tokenDoc.exists) {
        await tokenRef.doc(token).set({'token': token});
      }
    } catch (e) {
      print('an error occured while adding token $e');
    }
  }

//FirebaseMessaging.onBackgroundMessage(handleMessage);
  // Future<String> getFCMToken() async {
  //   String? token = await _firebaseMessaging.getToken();
  //   return token ?? '';
  // }

  Future<bool> getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications') ??
        true; // Default to true if not found
  }
}
