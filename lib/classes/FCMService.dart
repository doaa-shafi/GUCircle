import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFCM() async {
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

    await addTokenToDatabase(token.toString());

    print("token is:" + token.toString());

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received FCM message: ${message.notification?.body}');
      handleMessage(message);
    });

    // Handle incoming messages
    await initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // check for credentials
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // no user is logged in, so open the log in page
      navigatorKey.currentState?.pushNamed('/');
    } else {
      navigatorKey.currentState?.pushNamed('/notificationsRoute');
      print("notifications route");
    }
  }

// Background message handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
    navigatorKey.currentState?.pushNamed('/notificationsRoute');
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
        await tokenRef.doc(token).set({});
      }
    } catch (e) {
      print('an error occured $e');
    }
  }

//FirebaseMessaging.onBackgroundMessage(handleMessage);
  // Future<String> getFCMToken() async {
  //   String? token = await _firebaseMessaging.getToken();
  //   return token ?? '';
  // }
}
