import 'package:flutter/material.dart';
import 'package:gucircle/User.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user= User(username: "ahmed maohamed",email: "ahmed.mohamed@student.guc.edu.eg",password: "llllll",image: "");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: Column(
          children: [
            Image.asset('assets/anonymous.png'),
            Text(user.username)
          ],
        ),
      ),
    );
  }
}