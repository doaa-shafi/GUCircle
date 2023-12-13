import 'package:flutter/material.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the user details
    Map<String, dynamic> userDetails = Provider.of<UserModel>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Image.asset('assets/logo.png', height: 40, width: 40),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "GUCircle",
            style: TextStyle(color: Colors.white),
          )
        ]),
        iconTheme:
            const IconThemeData(color: const Color.fromARGB(255, 255, 208, 59)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${userDetails['username']}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Email: ${userDetails['email']}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'GUC ID: ${userDetails['gucId']}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
